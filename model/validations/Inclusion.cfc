<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["with", "message", "on", "condition"];
  _optionDefaults = ["", "is not included in the list", "save", "true"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (isSimpleValue(local.value) and local.value eq "") return true;
    if (isSimpleValue(_options.with)) {
      local.valid = isSimpleValue(local.value) and listFind(_options.with, local.value);
    } else {
      local.valid = _options.with.contains(local.value);
    }
    if (!local.valid) {
      _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
