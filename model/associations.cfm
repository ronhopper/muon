<cfscript>

  _muonAssociations = {};

  function belongsTo() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    local.args.type = "belongsTo";
    _muonAssociations[local.args.associationName] = local.args;
  }

  function hasOne() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    local.args.type = "hasOne";
    _muonAssociations[local.args.associationName] = local.args;
  }

  function hasMany() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    local.args.type = "hasMany";
    _muonAssociations[local.args.associationName] = local.args;
  }

  function hasAndBelongsToMany() {
    var local = {};
    local.args = muonExtractAssociationArgs(argumentCollection=arguments);
    local.args.type = "hasAndBelongsToMany";
    _muonAssociations[local.args.associationName] = local.args;
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

  function muonGenerateAssociationMethods() {
    var local = {};
    for (local.key in _muonAssociations) {
      local.assoc = _muonAssociations[local.key];
      switch (local.assoc.type) {
        case "belongsTo":
          muonGenerateBelongsToMethods(local.assoc);
          break;
        case "hasOne":
          muonGenerateHasOneMethods(local.assoc);
          break;
        case "hasMany":
          muonGenerateHasManyMethods(local.assoc);
          break;
        case "hasAndBelongsTo":
          muonGenerateHasAndBelongsToManyMethods(local.assoc);
          break;
      }
    }
  }

  function muonGenerateBelongsToMethods(assoc) {
    if (!structKeyExists(assoc, "modelName")) {
      assoc.modelName = assoc.associationName;
    }
    if (!structKeyExists(assoc, "foreignKey")) {
      assoc.foreignKey = assoc.associationName & "Id";
    }
    _muon.dynamicMethods["get#assoc.associationName#"] = "muonGetBelongsTo";
    _muon.dynamicMethods["set#assoc.associationName#"] = "muonSetBelongsTo";
  }


  function muonGenerateHasOneMethods(assoc) {
    if (!structKeyExists(assoc, "modelName")) {
      assoc.modelName = assoc.associationName;
    }
    if (!structKeyExists(assoc, "foreignKey")) {
      assoc.foreignKey = _muon.modelName & "Id";
    }
    _muon.dynamicMethods["get#assoc.associationName#"] = "muonGetHasOne";
    _muon.dynamicMethods["set#assoc.associationName#"] = "muonSetHasOne"; //TODO
  }

  function muonGenerateHasManyMethods(assoc) {
    assoc.singularName = _muon.dao.inflector().singularize(assoc.associationName);
    if (!structKeyExists(assoc, "modelName")) {
      assoc.modelName = assoc.singularName;
    }
    if (!structKeyExists(assoc, "foreignKey")) {
      assoc.foreignKey = _muon.modelName & "Id";
    }
    _muon.dynamicMethods["list#assoc.associationName#"] = "muonListHasMany";
    _muon.dynamicMethods["new#assoc.singularName#"] = "muonNewHasMany"; //TODO
    _muon.dynamicMethods["get#assoc.singularName#"] = "muonGetHasMany"; //TODO
    _muon.dynamicMethods["add#assoc.singularName#"] = "muonAddHasMany"; //TODO
    _muon.dynamicMethods["remove#assoc.singularName#"] = "muonRemoveHasMany"; //TODO
  }

  function muonGenerateHasAndBelongsToManyMethods(assoc) {
    //TODO
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

  function muonGetHasOne(method, args) {
    var local = {};
    local.assoc = _muonAssociations[right(method, len(method) - 3)];
    local.args = { data = { #local.assoc.foreignKey# = this.getId() }};
    return _muon.dao.muonGet("get#local.assoc.modelName#", local.args);
  }

  function muonListHasMany(method, args) {
    var local = {};
    local.assoc = _muonAssociations[right(method, len(method) - 4)];
    local.tableName = _muon.dao.muonModelData(local.assoc.modelName).tableName;
    if (isNumeric(listFirst(structKeyList(args))) and arrayLen(args) ge 1) {
      args[1][local.assoc.foreignKey] = this.getId();
    } else {
      if (!structKeyExists(args, "data")) args.data = {};
      args.data[local.assoc.foreignKey] = this.getId();
    }
    return _muon.dao.muonList("list#local.tableName#", args);
  }

</cfscript>
