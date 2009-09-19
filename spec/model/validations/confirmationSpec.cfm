<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesConfirmationOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesConfirmationOf("password");
    </cfscript></before>

    <it should="not add any errors if the password matches its confirmation"><cfscript>
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("qwerty12");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the password doesn't match its confirmation"><cfscript>
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("Qwerty12");
      model.muonRunValidations();
      $(model).errors().on("password").shouldEqual("doesn't match confirmation");
    </cfscript></it>

    <it should="add an error if the password is not a simple value"><cfscript>
      $(model).stubs("getPassword").returns(structNew());
      $(model).stubs("getPasswordConfirmation").returns("");
      model.muonRunValidations();
      $(model).errors().on("password").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesConfirmationOf("password", "must be confirmed for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("User");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("");
      model.muonRunValidations();
      $(model).errors().on("password").shouldEqual("must be confirmed for User");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesConfirmationOf(property="password", on="create");
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("");
    </cfscript></before>

    <it should="not run validation if this is an existing record"><cfscript>
      $(model).stubs("isNewRecord").returns(false);
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="run validation if this is a new record"><cfscript>
      $(model).stubs("isNewRecord").returns(true);
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(on update)">

    <before><cfscript>
      model.validatesConfirmationOf(property="password", on="update");
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("");
    </cfscript></before>

    <it should="run validation if this is an existing record"><cfscript>
      $(model).stubs("isNewRecord").returns(false);
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="not run validation if this is a new record"><cfscript>
      $(model).stubs("isNewRecord").returns(true);
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(conditionally)">

    <before><cfscript>
      model.validatesConfirmationOf(property="password", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getPassword").returns("qwerty12");
      $(model).stubs("getPasswordConfirmation").returns("");
    </cfscript></before>

    <it should="run validation if the condition evaluates to true"><cfscript>
      $(model).stubs("getResult").returns(2);
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="not run validation if the condition evaluates to false"><cfscript>
      $(model).stubs("getResult").returns(3);
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(multiple properties)">

    <before><cfscript>
      model.validatesConfirmationOf(properties="a,b,c,d");
      $(model).stubs("getA").returns("a");
      $(model).stubs("getB").returns("b");
      $(model).stubs("getC").returns("c");
      $(model).stubs("getD").returns("d");
      $(model).stubs("getAConfirmation").returns("a");
      $(model).stubs("getBConfirmation").returns("b");
      $(model).stubs("getCConfirmation").returns("");
      $(model).stubs("getDConfirmation").returns("");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("a").shouldBeEmpty();
      $(model).errors().on("b").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("c").shouldNotBeEmpty();
      $(model).errors().on("d").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
