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

  function isEmpty() {
    return structIsEmpty(_errors);
  }

  function on(property) {
    if (!structKeyExists(_errors, property)) return "";
    return _errors[property][1];
  }

</cfscript></cfcomponent>
