<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["message", "on", "condition"];
  _optionDefaults = ["can't be blank", "save", "true"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (isSimpleValue(local.value)) {
      local.empty = !reFind("\S", local.value);
    } else {
      local.empty = local.value.isEmpty();
    }
    if (local.empty) {
      _model.errors.add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
