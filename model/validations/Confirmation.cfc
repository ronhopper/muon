<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["message", "on", "condition", "confirmation"];
  _optionDefaults = ["doesn't match confirmation", "save", "true", ""];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (_options.confirmation eq "") {
      local.confirmation = evaluate("_model.get#property#Confirmation()");
    } else {
      local.confirmation = evaluate("_model.get#_options.confirmation#()");
    }
    if (not local.value.equals(local.confirmation)) {
      _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
