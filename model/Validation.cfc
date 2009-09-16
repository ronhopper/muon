<cfcomponent><cfscript>

  function init(model, args) {
    _model = model;
    _extractOptions(args);
    _setOptionDefaults();
    _properties = listToArray(_options.properties);
    return this;
  }

  function run() {
    var local = {};
    if (_isOutOfPhase() or _isOutOfCondition()) return;
    for (local.i = 1; local.i <= arrayLen(_properties); local.i++) {
      this.validateProperty(_properties[local.i]);
    }
  }

  function _extractOptions(args) {
    var local = {};
    _options = {};
    if (isNumeric(listFirst(structKeyList(args)))) {
      _extractOptionsAsArray(args);
    } else {
      structAppend(_options, args);
      if (not isDefined("_options.properties")) _options.properties = _options.property;
    }
  }

  function _extractOptionsAsArray(args) {
    var local = {};
    _options.properties = args[1];
    for (local.i = 2; local.i <= arrayLen(args); local.i++) {
      _options[_optionList[local.i - 1]] = args[local.i];
    }
  }

  function _setOptionDefaults() {
    var local = {};
    for (local.i = 1; local.i <= arrayLen(_optionDefaults); local.i++) {
      local.key = _optionList[local.i];
      if (!isDefined("_options.#local.key#")) _options[local.key] = _optionDefaults[local.i];
    }
  }

  function _isOutOfPhase() {
    switch (_options.on) {
      case "create": return !_model.isNewRecord();
      case "update": return _model.isNewRecord();
      default: return false;
    }
  }

  function _isOutOfCondition() {
    return !_model.muonEvaluate(_options.condition);
  }

</cfscript></cfcomponent>
