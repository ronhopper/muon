<cfscript>

  _muonValidations = [];

  function validatesAcceptanceOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Acceptance").init(this, arguments));
  }

  function validatesConfirmationOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Confirmation").init(this, arguments));
  }

  function validatesExclusionOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Exclusion").init(this, arguments));
  }

  function validatesFormatOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Format").init(this, arguments));
  }

  function validatesInclusionOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Inclusion").init(this, arguments));
  }

  function validatesLengthOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Length").init(this, arguments));
  }

  function validatesNotFormatOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.NotFormat").init(this, arguments));
  }

  function validatesNumericalityOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Numericality").init(this, arguments));
  }

  function validatesPresenceOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Presence").init(this, arguments));
  }

  function validatesUniquenessOf() {
    arrayAppend(_muonValidations, createObject("component", "validations.Uniqueness").init(this, arguments));
  }

  function validate() {
    arrayAppend(_muonValidations, createObject("component", "Callback").init(this, arguments, "save"));
  }

  function validateOnCreate() {
    arrayAppend(_muonValidations, createObject("component", "Callback").init(this, arguments, "create"));
  }

  function validateOnUpdate() {
    arrayAppend(_muonValidations, createObject("component", "Callback").init(this, arguments, "update"));
  }

  function _muonRunValidations() {
    var local = {};
    for (local.i = 1; local.i <= arrayLen(_muonValidations); local.i++) {
      _muonValidations[local.i].run(false);
    }
  }

</cfscript>
