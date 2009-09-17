<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["accept", "message", "on", "condition"];
  _optionDefaults = ["1", "must be accepted", "save", "true"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (not local.value.equals(_options.accept)) {
      _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
