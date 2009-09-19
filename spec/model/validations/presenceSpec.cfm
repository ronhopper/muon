<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesPresenceOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesPresenceOf("name");
    </cfscript></before>

    <it should="not add any errors if the name has non-whitespace characters"><cfscript>
      $(model).stubs("getName").returns("   John Adams   ");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the name is only whitespace"><cfscript>
      $(model).stubs("getName").returns("   #chr(10)#   ");
      model.muonRunValidations();
      $(model).errors().on("name").shouldEqual("can't be blank");
    </cfscript></it>

    <it should="add an error if the name is not a simple value"><cfscript>
      $(model).stubs("getName").returns(structNew());
      model.muonRunValidations();
      $(model).errors().on("name").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesPresenceOf("name", "must exist in ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Person");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getName").returns("");
      model.muonRunValidations();
      $(model).errors().on("name").shouldEqual("must exist in Person");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesPresenceOf(property="name", on="create");
      $(model).stubs("getName").returns("");
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
      model.validatesPresenceOf(property="name", on="update");
      $(model).stubs("getName").returns("");
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
      model.validatesPresenceOf(property="name", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getName").returns("");
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
      model.validatesPresenceOf(properties="firstName,lastName,email,phone");
      $(model).stubs("getFirstName").returns("John");
      $(model).stubs("getLastName").returns("Adams");
      $(model).stubs("getEmail").returns("");
      $(model).stubs("getPhone").returns("");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("firstName").shouldBeEmpty();
      $(model).errors().on("lastName").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("email").shouldNotBeEmpty();
      $(model).errors().on("phone").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
