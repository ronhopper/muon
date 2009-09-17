<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["scope", "message", "on", "condition"];
  _optionDefaults = ["", "has already been taken", "save", "true"];

  function validateProperty(property) {
    var local = {};
    local.map = _buildPropertyMap(property);
    local.dao = _model.muonEvaluate("_muon.dao");
    local.tableName = _model.muonEvaluate("_muon.tableName");
    local.resultSet = evaluate("local.dao.list#local.tableName#(local.map)");
    if (local.resultSet.recordCount eq 0) return true;
    if ((local.resultSet.recordCount eq 1) and !_model.isNewRecord()
        and (_model.getId() eq local.resultSet.id)) return true;
    _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
  }

  function _buildPropertyMap(property) {
    var local = {};
    local.map = {};
    local.map[property] = evaluate("_model.get#property#()");
    _appendScopedProperties(local.map);
    return local.map;
  }

  function _appendScopedProperties(map) {
    var local = {};
    local.scope = listToArray(_options.scope);
    for (local.i = 1; local.i <= arrayLen(local.scope); local.i++) {
      local.key = local.scope[local.i];
      map[local.key] = evaluate("_model.get#local.key#()");
    }
  }

</cfscript></cfcomponent>
