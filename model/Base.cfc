<cfcomponent>
<cfinclude template="accessors.cfm">
<cfinclude template="callbacks.cfm">
<cfinclude template="associations.cfm">
<cfinclude template="validations.cfm">
<cfscript>

  _muon = { data = {}, defaults = {}, dynamicMethods = {} };

  function init(dao, metaData) {
    _muon.dao = dao;
    structAppend(_muon, metaData);
    muonSetDefaults();
    muonGeneratePropertyAccessors();
    muonGenerateAssociationMethods();
    return this;
  }

  function muonSetDefaults() {
    var local = {};
    local.fields = xmlSearch(_muon.schema, "//field");
    for (local.i = 1; local.i <= arrayLen(local.fields); local.i++) {
      local.attrs = local.fields[local.i].xmlAttributes;
      local.property = local.attrs.ColumnName;
      if (structKeyExists(local.attrs, "Default")) {
        _muon.defaults[local.property] = evaluate(local.attrs.Default);
      }
    }
  }

  function errors() {
    if (!structKeyExists(_muon, "errors")) {
      _muon.errors = createObject("component", "muon.model.Errors").init();
    }
    return _muon.errors;
  }

  function isNewRecord() {
    return !structKeyExists(_muon.data, "id") or _muon.data.id eq "";
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    var local = {};
    if (structKeyExists(_muon.dynamicMethods, missingMethodName)) {
      local.args = { method = missingMethodName, args = missingMethodArguments };
      return muonInvoke(_muon.dynamicMethods[missingMethodName], local.args);
    } else {
      _muon.dao.muonThrowMethodNotFound(missingMethodName, _muon.classPath);
    }
  }

  function save() {
    var local = {};
    errors().clear();
    if (!muonRunCallbacks("beforeValidation", true)) return false;
    muonRunValidations();
    if (!errors().isEmpty()) return false;
    muonRunCallbacks("afterValidation", false);
    if (!muonRunCallbacks("beforeSave", true)) return false;
    muonSave();
    muonRunCallbacks("afterSave", false);
    return true;
  }

  function delete() {
    if (!muonRunCallbacks("beforeDelete", true)) return false;
    muonDelete();
    muonRunCallbacks("afterDelete", false);
  }

  function muonEvaluate(expression) {
    return evaluate(expression);
  }

  function muonSave() {
    var id = "";
    if (isNewRecord()) {
      id = _muon.dao.muonInsertRecord(_muon.tableName, _muon.data);
      if (isDefined("id")) _muon.data.id = id;
    } else {
      _muon.dao.muonUpdateRecord(_muon.tableName, _muon.data);
    }
  }

  function muonDelete() {
    var data = { id = _muon.data.id };
    _muon.dao.muonDeleteRecord(_muon.tableName, data);
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

</cfcomponent>
