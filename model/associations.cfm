<cfscript>

  _muonAssociations = {};

  function belongsTo() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    if (!structKeyExists(local.args, "modelName")) {
      local.args.modelName = local.args.associationName;
    }
    if (!structKeyExists(local.args, "foreignKey")) {
      local.args.foreignKey = local.args.associationName & "Id";
    }
    _muonAssociations[local.args.associationName] = local.args;
    _muon.dynamicMethods["get#local.args.associationName#"] = "muonGetBelongsTo";
    _muon.dynamicMethods["set#local.args.associationName#"] = "muonSetBelongsTo";
  }

  function hasOne() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    _muonAssociations[local.args.associationName] = local.args;
    //TODO
  }

  function hasMany() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    if (!structKeyExists(local.args, "modelName")) {
      local.args.modelName = createObject("component", "muon.util.Inflector").init().singularize(local.args.associationName);
    }
    if (!structKeyExists(local.args, "foreignKey")) {
      local.args.foreignKey = listLast(getMetaData(this).name, ".") & "Id";
    }
    _muonAssociations[local.args.associationName] = local.args;
    _muon.dynamicMethods["list#local.args.associationName#"] = "muonListHasMany";
    //TODO
  }

  function hasAndBelongsToMany() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    _muonAssociations[local.args.associationName] = local.args;
    //TODO
  }

  function muonExtractAssociationArgs() {
    var local = {};
    local.args = {};
    if (isNumeric(listFirst(structKeyList(arguments)))) {
      local.count = arrayLen(arguments);
      if (local.count ge 1) local.args.associationName = arguments[1];
      if (local.count ge 2) local.args.modelName = arguments[2];
      if (local.count ge 3) local.args.foreignKey = arguments[3];
    } else {
      structAppend(local.args, arguments);
    }
    return local.args;
  }

  function muonGetBelongsTo(method, args) {
    var local = {};
    local.assoc = _muonAssociations[right(method, len(method) - 3)];
    local.args = { data = { id = muonGet("get#local.assoc.foreignKey#", structNew()) }};
    return _muon.dao.muonGet("get#local.assoc.modelName#", local.args);
  }

  function muonSetBelongsTo(method, args) {
    var local = {};
    local.assoc = _muonAssociations[right(method, len(method) - 3)];
    local.args = [""];
    if (isObject(args[1])) local.args[1] = args[1].getId();
    muonSet("set#local.assoc.foreignKey#", local.args);
  }

  function muonListHasMany(method, arg) {
    var local = {};
    local.assoc = _muonAssociations[right(method, len(method) - 4)];
    local.tableName = _muon.dao.muonModelData(local.assoc.modelName).tableName;
    local.args = { data = {} };
    local.args.data[local.assoc.foreignKey] = this.getId();
    return _muon.dao.muonList("list#local.tableName#", local.args);
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

</cfscript>
