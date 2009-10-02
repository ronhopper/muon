<cfcomponent output="false">
<cfinclude template="accessors.cfm">
<cfinclude template="callbacks.cfm">
<cfinclude template="associations.cfm">
<cfinclude template="validations.cfm">
<cfscript>

  _muon = { data = {}, aliases = {}, defaults = {}, dynamicMethods = {} };

  function init(dao, metaData) {
    _muon.dao = dao;
    structAppend(_muon, metaData);
    muonSetDefaults();
    muonGeneratePropertyAccessors();
    muonGenerateAssociationMethods();
    return this;
  }

  function dao() {
    return _muon.dao;
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

  function save() {
    var local = {};
    errors().clear();
    if (!muonRunCallbacks("beforeValidation", true)) return false;
    this.muonRunValidations();
    if (!errors().isEmpty()) return false;
    muonRunCallbacks("afterValidation", false);
    if (!muonRunCallbacks("beforeSave", true)) return false;
    this.muonSave();
    muonRunCallbacks("afterSave", false);
    return true;
  }

  function delete() {
    if (this.isNewRecord()) return false;
    if (!muonRunCallbacks("beforeDelete", true)) return false;
    this.muonDelete();
    muonRunCallbacks("afterDelete", false);
    return true;
  }

  function muonSetDefaults() {
    var local = {};
    local.fields = xmlSearch(_muon.schema, "//field");
    for (local.i = 1; local.i <= arrayLen(local.fields); local.i++) {
      local.attrs = local.fields[local.i].xmlAttributes;
      local.property = local.attrs.ColumnName;
      if (structKeyExists(local.attrs, "Default")) {
        _muon.defaults[local.property] = local.attrs.Default;
      }
    }
  }

  function muonEvaluate(expression) {
    return evaluate(expression);
  }

  function muonSave() {
    var id = "";
    var userId = "";
    try {
      if (isDefined("session.userId")) userId = session.userId;
    } catch (Any e) {}
    if (val(userId)) {
      _muon.data.updatedBy = userId;
      _muon.data.updated_by = userId;
    }
    if (isNewRecord()) {
      if (val(userId)) {
        _muon.data.createdBy = userId;
        _muon.data.created_by = userId;
      }
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

<cffunction name="onMissingMethod" output="false">
  <cfargument name="missingMethodName">
  <cfargument name="missingMethodArguments">
  <cfscript>
    var local = {};
    if (structKeyExists(_muon.dynamicMethods, missingMethodName)) {
      local.args = { method = missingMethodName, args = missingMethodArguments };
      return muonInvoke(_muon.dynamicMethods[missingMethodName], local.args);
    } else {
      _muon.dao.muonThrowMethodNotFound(missingMethodName, _muon.classPath);
    }
  </cfscript>
</cffunction>


</cfcomponent>
