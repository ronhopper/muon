<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["with", "message", "on", "condition"];
  _optionDefaults = [".*", "is invalid", "save", "true"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (!isSimpleValue(local.value)
        or (local.value neq "" and reFind(_options.with, local.value) gt 0)) {
      _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
