<cfcomponent extends="muon.model.Validation"><cfscript>

  _optionList = ["min", "max", "message", "exactly", "on", "condition",
                 "tooShort", "tooLong", "wrongLength"];
  _optionDefaults = [0, 0, "", 0, "save", "true", "is too short (min is ? characters)",
                     "is too long (max is ? characters)", "is the wrong length (should be ? characters)"];

  function validateProperty(property) {
    var local = {};
    local.value = evaluate("_model.get#property#()");
    if (isSimpleValue(local.value) and local.value eq "") return true;
    local.length = local.value.length();
    if ((_options.exactly gt 0) and (local.length neq _options.exactly)) {
      local.message = replace(_options.wrongLength, "?", _options.exactly, "all");
    } else if ((_options.min gt 0) and (local.length lt _options.min)) {
      local.message = replace(_options.tooShort, "?", _options.min, "all");
    } else if ((_options.max gt 0) and (local.length gt _options.max)) {
      local.message = replace(_options.tooLong, "?", _options.max, "all");
    }
    if (structKeyExists(local, "message")) {
      if (_options.message neq "") local.message = _options.message;
      _model.errors().add(property, _model.muonEvaluate(de(local.message)));
    }
  }

</cfscript></cfcomponent>
