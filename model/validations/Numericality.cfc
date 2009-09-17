<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["message", "on", "onlyInteger", "lessThan", "lessThanOrEqualTo", "equalTo",
                 "greaterThanOrEqualTo", "greaterThan", "condition"];
  _optionDefaults = ["is not a number", "save", false, "", "", "", "", "", "true"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (local.value eq "") return true;
    if (!isNumeric(local.value)) {
      local.valid = false;
    } else if (_options.onlyInteger and int(local.value) neq local.value) {
      local.valid = false;
    } else if (_options.greaterThan neq "" and local.value le _options.greaterThan) {
      local.valid = false;
    } else if (_options.greaterThanOrEqualTo neq "" and local.value lt _options.greaterThanOrEqualTo) {
      local.valid = false;
    } else if (_options.equalTo neq "" and local.value neq _options.equalTo) {
      local.valid = false;
    } else if (_options.lessThan neq "" and local.value ge _options.lessThan) {
      local.valid = false;
    } else if (_options.lessThanOrEqualTo neq "" and local.value gt _options.lessThanOrEqualTo) {
      local.valid = false;
    } else {
      local.valid = true;
    }
    if (!local.valid) {
      _model.errors().add(property, _model.muonEvaluate(de(_options.message)));
    }
  }

</cfscript></cfcomponent>
