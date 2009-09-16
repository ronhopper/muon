<cfcomponent><cfscript>

  function init(model, methods, phase) {
    _model = model;
    _methods = methods;
    _phase = phase;
    return this;
  }

  function run(useResult) {
    var local = {};
    switch (_phase) {
      case "create": if (!_model.isNewRecord()) return true; break;
      case "update": if (_model.isNewRecord()) return true; break;
    }
    for (local.i = 1; local.i <= arrayLen(_methods); local.i++) {
      local.method = _methods[local.i];
      local.result = evaluate("_model.#local.method#()");
      if (useResult and isDefined("local.result") and isBoolean(local.result) and !local.result) {
        return false;
      }
    }
    return true;
  }

</cfscript></cfcomponent>
