<cfcomponent><cfscript>

  function init() {
    clear();
    return this;
  }

  function add(property, message) {
    if (!structKeyExists(_errors, property)) _errors[property] = [];
    if (arrayLen(arguments) < 2) arguments.message = "is invalid";
    arrayAppend(_errors[property], message);
  }

  function addToBase(message) {
    add("__base__", message);
  }

  function clear() {
    _errors = {};
  }

  function count() {
    var local = {};
    local.count = 0;
    for (local.property in _errors) {
      local.count += arrayLen(_errors[local.property]);
    }
  }

  function fullMessages() {
    var local = {};
    local.errors = onBase();
    local.labels = {};
    if (arrayLen(arguments) ge 1) local.labels = arguments[1];
    for (local.key in _errors) {
      if (local.key eq "__base__") continue;
      if (structKeyExists(local.labels, local.key)) {
        local.label = local.labels[local.key];
      } else {
        local.label = reReplace(local.key, "^(.)(.*)$", "\u\1\2");
      }
      for (local.i = 1; local.i <= arrayLen(_errors[local.key]); local.i++) {
        arrayAppend(local.errors, "#local.label# #_errors[local.key][local.i]#");
      }
    }
    return local.errors;
  }

  function isEmpty() {
    return structIsEmpty(_errors);
  }

  function on(property) {
    if (!structKeyExists(_errors, property)) return "";
    return _errors[property][1];
  }

  function onBase() {
    if (!structKeyExists(_errors, "__base__")) return arrayNew(1);
    return _errors.__base__;
  }

</cfscript></cfcomponent>
