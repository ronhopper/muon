<cfscript>

  _muonCallbacks = {
    beforeValidation = [],
    afterValidation = [],
    beforeSave = [],
    afterSave = [],
    beforeDelete = [],
    afterDelete = []
  };

  function beforeValidation() {
    arrayAppend(_muonCallbacks.beforeValidation,
                createObject("component", "Callback").init(this, arguments, "save"));
  }

  function beforeValidationOnCreate() {
    arrayAppend(_muonCallbacks.beforeValidation,
                createObject("component", "Callback").init(this, arguments, "create"));
  }

  function beforeValidationOnUpdate() {
    arrayAppend(_muonCallbacks.beforeValidation,
                createObject("component", "Callback").init(this, arguments, "update"));
  }

  function afterValidation() {
    arrayAppend(_muonCallbacks.afterValidation,
                createObject("component", "Callback").init(this, arguments, "save"));
  }

  function afterValidationOnCreate() {
    arrayAppend(_muonCallbacks.afterValidation,
                createObject("component", "Callback").init(this, arguments, "create"));
  }

  function afterValidationOnUpdate() {
    arrayAppend(_muonCallbacks.afterValidation,
                createObject("component", "Callback").init(this, arguments, "update"));
  }

  function beforeSave(methods) {
    arrayAppend(_muonCallbacks.beforeSave,
                createObject("component", "Callback").init(this, methods, "save"));
  }

  function beforeCreate(methods) {
    arrayAppend(_muonCallbacks.beforeSave,
                createObject("component", "Callback").init(this, methods, "create"));
  }

  function beforeUpdate(methods) {
    arrayAppend(_muonCallbacks.beforeSave,
                createObject("component", "Callback").init(this, methods, "update"));
  }

  function afterSave() {
    arrayAppend(_muonCallbacks.afterSave,
                createObject("component", "Callback").init(this, arguments, "save"));
  }

  function afterCreate() {
    arrayAppend(_muonCallbacks.afterSave,
                createObject("component", "Callback").init(this, arguments, "create"));
  }

  function afterUpdate() {
    arrayAppend(_muonCallbacks.afterSave,
                createObject("component", "Callback").init(this, arguments, "update"));
  }

  function beforeDelete() {
    arrayAppend(_muonCallbacks.beforeDelete,
                createObject("component", "Callback").init(this, arguments, "delete"));
  }

  function afterDelete() {
    arrayAppend(_muonCallbacks.afterDelete,
                createObject("component", "Callback").init(this, arguments, "delete"));
  }

  function _muonRunCallbacks(hook, useResult) {
    var local = {};
    for (local.i = 1; local.i <= arrayLen(_muonCallbacks[hook]); local.i++) {
      local.result = _muonCallbacks[hook][local.i].run(useResult);
      if (useResult and !local.result) return false;
    }
    return true;
  }

</cfscript>
