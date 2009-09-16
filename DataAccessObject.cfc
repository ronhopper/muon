<cfcomponent><cfscript>

  function init(datasource, schemaPath, modelPrefix) {
    _muon = {
      associations = {},
      constructors = "",
      getters = "",
      listers = ""
    };
    _muonSetupDataMgr(datasource, schemaPath);
    _muonGenerateMethodsForModels(modelPrefix);
    return this;
  }

  function inflector() {
    if (!structKeyExists(_muon, "inflector")) {
      _muon.inflector = createObject("component", "muon.util.Inflector").init();
    }
    return _muon.inflector;
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    if (listFindNoCase(_muon.constructors, missingMethodName)) {
      return _muonConstruct(right(missingMethodName, len(missingMethodName) - 3), missingMethodArguments);

    } else if (listFindNoCase(_muon.getters, missingMethodName)) {
      return _muonGet(right(missingMethodName, len(missingMethodName) - 3), missingMethodArguments);

    } else if (listFindNoCase(_muon.listers, missingMethodName)) {
      return _muonList(right(missingMethodName, len(missingMethodName) - 4), missingMethodArguments);

    } else {
      _throwMethodNotFound(missingMethodName);
    }
  }

  function muonAssociation(modelName) {
    return _muon.associations[modelName];
  }

  function muonSaveRecord() {
    _muon.dataMgr.saveRecord(argumentCollection=arguments);
  }

  function muonDeleteRecord() {
    _muon.dataMgr.deleteRecord(argumentCollection=arguments);
  }

  function _muonSetupDataMgr(datasource, schemaPath) {
    if (datasource eq "simulation") {
      _muon.dataMgr = createObject("component", "external.dataMgr.DataMgr").init("test", "Sim");
    } else {
      _muon.dataMgr = createObject("component", "external.dataMgr.DataMgr").init(datasource);
    }
    _muon.dataMgr.loadXml(_readFile(schemaPath));
  }

  function _muonGenerateMethodsForModels(modelPrefix) {
    var local = {};
    local.path = expandPath("/" & replace(modelPrefix, ".", "/", "all"));
    local.files = createObject("java", "java.io.File").init(local.path).list();
    for (local.i = 1; local.i <= arrayLen(local.files); local.i++) {
      local.file = local.files[local.i];
      if (reFindNoCase("\.cfc$", local.file)) {
        _muonGenerateMethodsForModel(modelPrefix, left(local.file, len(local.file) - 4));
      }
    }
  }

  function _muonGenerateMethodsForModel(modelPrefix, modelName) {
    var object = createObject("component", "#modelPrefix#.#modelName#");
    var tableName = inflector().pluralize(modelName);
    if (!isInstanceOf(object, "muon.model.Base")) return;

    _muon.associations[modelName] = {
      classPath = "#modelPrefix#.#modelName#",
      tableName = tableName
    };
    _muon.listers = listAppend(_muon.listers, "list#tableName#");
    _muon.constructors = listAppend(_muon.constructors, "new#modelName#");
    _muon.getters = listAppend(_muon.getters, "get#modelName#");
  }

  function _muonList(tableName, args) {
    var local = {};
    local.args = { tableName = tableName };
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

  function _muonConstruct(modelName, args) {
    var local = {};
    local.assoc = _muon.associations[modelName];
    local.object = createObject("component", local.assoc.classPath).init(this);
    local.args = { id = 0 };
    local.record = _muon.dataMgr.getRecord(local.assoc.tableName, local.args);
    local.object._muonSetProperties(local.record);
    local.object.setProperties(args);
    return local.object;
  }

  function _muonGet(modelName, args) {
    var local = {};
    local.assoc = _muon.associations[modelName];
    local.args = { tableName = local.assoc.tableName };
    if (isNumeric(listFirst(structKeyList(args)))) {
      local.count = arrayLen(args);
      if (local.count ge 1) local.args.data = args[1];
      if (local.count ge 2) local.args.fieldList = args[2];
    } else {
      structAppend(local.args, args);
    }
    if (!isStruct(local.args.data)) {
      local.args.data = { id = local.args.data };
    }

    local.record = _muon.dataMgr.getRecord(argumentCollection=local.args);
    if (local.record.recordCount neq 1) return false;

    local.object = createObject("component", local.assoc.classPath).init(this);
    local.object._muonSetProperties(local.record);
    return local.object;
  }

</cfscript>

<cffunction name="_readFile">
  <cfargument name="path">
  <cfset var content = "">
  <cffile action="read" file="#path#" variable="content">
  <cfreturn content>
</cffunction>

<cffunction name="_throwMethodNotFound">
  <cfargument name="methodName">
  <cfthrow message="The method #methodName# was not found in component #getMetaData(this).name#."
           detail="Ensure that the method is defined, and that it is spelled correctly.">
</cffunction>

</cfcomponent>
