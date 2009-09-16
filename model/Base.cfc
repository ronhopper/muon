<cfcomponent>
<cfinclude template="validations.cfm">
<cfscript>

  function init(dao) {
    _muon = { dao = dao, data = {} };
    _muon.modelName = listLast(getMetaData(this).name, ".");
    _muon.tableName = dao.muonAssociation(_muon.modelName).tableName;
    return this;
  }

  function isNewRecord() {
    return structKeyExists(_muon.data, "id") and _muon.data.id neq "";
  }

  function errors() {
    if (!structKeyExists(_muon, "errors")) {
      _muon.errors = createObject("component", "muon.model.Errors").init();
    }
    return _muon.errors;
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

  function save() {
    var local = {};
    local.isNewRecord = isNewRecord();
    errors().clear();
    _muonRunValidations();
    if (!errors().isEmpty()) return false;
    _muonSave();
    return true;
  }

  function delete() {
    _muonDelete();
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    if (reFindNoCase("get.", missingMethodName) eq 1) {
      return _muonGet(right(missingMethodName, len(missingMethodName) - 3));

    } else if (reFindNoCase("set.", missingMethodName) eq 1) {
      return _muonSet(right(missingMethodName, len(missingMethodName) - 3), missingMethodArguments[1]);

    } else {
      _muon.dao._throwMethodNotFound(missingMethodName);
    }
  }

  function muonEvaluate(expression) {
    return evaluate(expression);
  }

  function _muonSetProperties() {
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
        _muon.data[local.field] = local.args[local.field];
      }
    }
  }

  function _muonGet(property) {
    return _muon.data[property];
  }

  function _muonSet(property, value) {
    _muon.data[property] = value;
  }

  function _muonSave() {
    var id = _muon.dao.muonSaveRecord(_muon.tableName, _muon.data);
    if (isDefined("id")) _muon.data.id = id;
  }

  function _muonDelete() {
    var data = { id = _muon.data.id };
    _muon.dao.muonDeleteRecord(_muon.tableName, data);
  }

</cfscript></cfcomponent>
