<cfcomponent output="false"><cfscript>

  function init(datasource, modelPrefix, schemaPath) {
    _muon = {
      dynamicMethods = {},
      models = {},
      schemaPath = schemaPath
    };
    muonSetupDataMgr(datasource, schemaPath);
    muonSetupModels(modelPrefix);
    return this;
  }

  function recreateDatabase() {
    var local = {};
    local.tables = _muon.dataMgr.runSql("select table_name from information_schema.tables where table_type = 'BASE TABLE'");
    for (local.i = 1; local.i <= local.tables.recordCount; local.i++) {
      _muon.dataMgr.runSql("truncate table #local.tables.table_name[local.i]#");
    }
    _muon.dataMgr.loadXml(muonReadFile(_muon.schemaPath), true, true);
  }

  function muonSetupDataMgr(datasource, schemaPath) {
    if (datasource eq "simulation") {
      _muon.dataMgr = createObject("component", "external.dataMgr.DataMgr").init(datasource="test", database="Sim");
    } else {
      _muon.dataMgr = createObject("component", "external.dataMgr.DataMgr").init(datasource=datasource, smartCache=true);
    }
    _muon.dataMgr.loadXml(muonReadFile(schemaPath), true, true);
  }

  function muonSetupModels(modelPrefix) {
    var local = {};
    local.path = expandPath("/" & replace(modelPrefix, ".", "/", "all"));
    local.files = createObject("java", "java.io.File").init(local.path).list();
    for (local.i = 1; local.i <= arrayLen(local.files); local.i++) {
      local.file = local.files[local.i];
      if (reFindNoCase("\.cfc$", local.file)) {
        muonSetupModel(modelPrefix, left(local.file, len(local.file) - 4));
      }
    }
  }

  function muonSetupModel(modelPrefix, modelName) {
    var local = {};
    local.model = createObject("component", "#modelPrefix#.#modelName#");
    if (!isInstanceOf(local.model, "muon.model.Base")) return;

    local.metaData = getMetaData(local.model);
    if (structKeyExists(local.metaData, "tableName")) {
      local.tableName = local.metaData.tableName;
    } else {
      local.tableName = inflector().pluralize(modelName);
      local.tableName = muonCamelCase(local.tableName);
    }
    _muon.models[modelName] = {
      classPath = "#modelPrefix#.#modelName#",
      modelName = modelName,
      tableName = local.tableName
    };
    try {
      local.schema = _muon.dataMgr.getXML(local.tableName);
    } catch (Any e) {
      local.schema = "<fields></fields>";
    }
    _muon.models[modelName].schema = xmlParse(local.schema);
    if (!structKeyExists(_muon.models, local.tableName)) {
      _muon.models[local.tableName] = _muon.models[modelName];
    }
    _muon.dynamicMethods["list#local.tableName#"] = "muonList";
    _muon.dynamicMethods["new#modelName#"] = "muonNew";
    _muon.dynamicMethods["get#modelName#"] = "muonGet";
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    var local = {};
    if (structKeyExists(_muon.dynamicMethods, missingMethodName)) {
      local.args = { method = missingMethodName, args = missingMethodArguments };
      return muonInvoke(_muon.dynamicMethods[missingMethodName], local.args);

    } else if (structKeyExists(_muon.dataMgr, missingMethodName) and isCustomFunction(_muon.dataMgr[missingMethodName])) {
      return evaluate("_muon.dataMgr.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)");

    } else {
      muonThrowMethodNotFound(missingMethodName);
    }
  }

  function muonList(method, args) {
    var local = {};
    local.args = { tableName = muonCamelCase(right(method, len(method) - 4)) };
    if (isNumeric(listFirst(structKeyList(args)))) {
      local.count = arrayLen(args);
      if (local.count ge 1) local.args.data = args[1];
      if (local.count ge 2) local.args.orderBy = args[2];
      if (local.count ge 3) local.args.maxRows = args[3];
      if (local.count ge 4) local.args.fieldList = args[4];
      if (local.count ge 5) local.args.advSql = args[5];
      if (local.count ge 6) local.args.filters = args[6];
    } else {
      structAppend(local.args, args);
    }
    return _muon.dataMgr.getRecords(argumentCollection=local.args);
  }

  function muonNew(method, args) {
    var local = {};
    local.model = _muon.models[right(method, len(method) - 3)];
    local.object = createObject("component", local.model.classPath).init(this, local.model);
    local.object.setProperties(args);
    return local.object;
  }

  function muonGet(method, args) {
    var local = {};
    local.model = _muon.models[right(method, len(method) - 3)];

    local.args = { tableName = local.model.tableName };
    if (isNumeric(listFirst(structKeyList(args)))) {
      local.count = arrayLen(args);
      if (local.count ge 1) local.args.data = args[1];
      if (local.count ge 2) local.args.fieldList = args[2];
    } else {
      structAppend(local.args, args);
    }
    if (!isStruct(local.args.data)) {
      local.id = local.args.data;
      local.args.data = { id = local.id };
    }

    local.record = _muon.dataMgr.getRecords(argumentCollection=local.args);
    if (local.record.recordCount neq 1) return false;

    local.object = createObject("component", local.model.classPath).init(this, local.model);
    local.object.muonSetProperties(local.record);
    return local.object;
  }

  function inflector() {
    if (!structKeyExists(_muon, "inflector")) {
      _muon.inflector = createObject("component", "muon.util.Inflector").init();
    }
    return _muon.inflector;
  }

  function muonInsertRecord() {
    return _muon.dataMgr.insertRecord(argumentCollection=arguments);
  }

  function muonUpdateRecord() {
    structDelete(arguments[2], "createdAt");
    return _muon.dataMgr.updateRecord(argumentCollection=arguments);
  }

  function muonDeleteRecord() {
    return _muon.dataMgr.deleteRecord(argumentCollection=arguments);
  }

  function muonModelData(modelName) {
    return _muon.models[modelName];
  }

  function muonCamelCase(word) {
    var l = len(word);
    if (l le 1) return lCase(word);
    return lCase(left(word, 1)) & right(word, l - 1);
  }

</cfscript>

<cffunction name="muonInvoke">
  <cfargument name="methodName">
  <cfargument name="methodArguments">
  <cfset var result = "">
  <cfinvoke method="#methodName#" argumentCollection="#methodArguments#" returnVariable="result">
  <cfif isDefined("result")>
    <cfreturn result>
  </cfif>
</cffunction>

<cffunction name="muonReadFile">
  <cfargument name="path">
  <cfset var content = "">
  <cfset var root = getDirectoryFromPath(getBaseTemplatePath())>
  <cffile action="read" file="#replace(path, '%ROOT%', root, 'all')#" variable="content">
  <cfreturn content>
</cffunction>

<cffunction name="muonThrowMethodNotFound">
  <cfargument name="methodName">
  <cfargument name="componentName" default="#getMetaData(this).name#">
  <cfthrow message="The method #methodName# was not found in component #componentName#."
           detail="Ensure that the method is defined, and that it is spelled correctly.">
</cffunction>

</cfcomponent>
