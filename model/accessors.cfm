<cfscript>

  function muonGeneratePropertyAccessors() {
    var local = {};
    local.fields = xmlSearch(_muon.schema, "//field");
    for (local.i = 1; local.i <= arrayLen(local.fields); local.i++) {
      local.property = local.fields[local.i].xmlAttributes['ColumnName'];
      propertyAccessor(local.property);
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
      evaluate("this.set#local.key#(local.args[local.key])");
    }
  }

  function muonGet(method, args) {
    var property = right(method, len(method) - 3);
    if (structKeyExists(_muon.data, property)) return _muon.data[property];
    if (structKeyExists(_muon.defaults, property)) return _muon.defaults[property];
    return "";
  }

  function muonSet(method, args) {
    _muon.data[right(method, len(method) - 3)] = args[1];
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
  }

</cfscript>
