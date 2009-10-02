<cfscript>

  function muonGeneratePropertyAccessors() {
    var local = {};
    local.fields = xmlSearch(_muon.schema, "//field");
    for (local.i = 1; local.i <= arrayLen(local.fields); local.i++) {
      local.property = local.fields[local.i].xmlAttributes['ColumnName'];
      local.scrubbedProperty = reReplaceNoCase(local.property, "[^a-z0-9]+", "", "all");
      if (local.property neq local.scrubbedProperty) {
        _muon.aliases[local.scrubbedProperty] = local.property;
      }
      propertyAccessor(local.scrubbedProperty);
    }
  }

  function propertyReader(property) {
    _muon.dynamicMethods["get#property#"] = "muonGet";
  }

  function propertyWriter(property) {
    _muon.dynamicMethods["set#property#"] = "muonSet";
  }

  function propertyAccessor(property) {
    propertyReader(property);
    propertyWriter(property);
  }

  function setProperties() {
    var local = {};
    if (isNumeric(listFirst(structKeyList(arguments)))) {
      local.args = arguments[1];
    } else {
      local.args = arguments;
    }
    for (local.key in local.args) {
      if (structKeyExists(this, "set#local.key#") or structKeyExists(_muon.dynamicMethods, "set#local.key#")) {
        evaluate("this.set#local.key#(local.args[local.key])");
      }
    }
  }

  function rollBackProperty(property) {
    if (structKeyExists(_muon.originalData, property)) {
      _muon.data[property] = _muon.originalData[property];
    } else {
      structDelete(_muon.data, property);
    }
  }

  function muonGet(method, args) {
    var property = right(method, len(method) - 3);
    var result = "";
    if (structKeyExists(_muon.aliases, property)) property = _muon.aliases[property];
    if (structKeyExists(_muon.data, property)) return _muon.data[property];
    if (structKeyExists(_muon.defaults, property)) {
      result = dao().runSQL("select (#_muon.defaults[property]#) as value");
      return result.value;
    }
    return "";
  }

  function muonSet(method, args) {
    var property = right(method, len(method) - 3);
    if (structKeyExists(_muon.aliases, property)) property = _muon.aliases[property];
    _muon.data[property] = args[1];
  }

  function muonSetProperties() {
    var local = {};
    if (isNumeric(listFirst(structKeyList(arguments)))) {
      local.args = arguments[1];
    } else {
      local.args = arguments;
    }
    if (isStruct(local.args)) {
      structAppend(_muon.data, local.args);
    } else {
      local.fields = listToArray(local.args.columnList);
      for (local.i = 1; local.i <= arrayLen(local.fields); local.i++) {
        local.field = local.fields[local.i];
        _muon.data[local.field] = local.args[local.field][1];
      }
    }
    _muon.originalData = structCopy(_muon.data);
  }

</cfscript>
