<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesLengthOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(minimum length)">

    <before><cfscript>
      model.validatesLengthOf("username", 3);
    </cfscript></before>

    <it should="not add any errors if the username is at least 3 characters long"><cfscript>
      $(model).stubs("getUsername").returns("foo");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the username is less than 3 characters long"><cfscript>
      $(model).stubs("getUsername").returns("fo");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is too short (min is 3 characters)");
    </cfscript></it>

    <it should="not add an error if the username is null"><cfscript>
      $(model).stubs("getUsername").returns("");
      model.muonRunValidations();
      $(model).errors().on("username").shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(maximum length)">

    <before><cfscript>
      model.validatesLengthOf("username", 3, 12);
    </cfscript></before>

    <it should="not add any errors if the username is no more than 12 characters long"><cfscript>
      $(model).stubs("getUsername").returns("supercalifra");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the username is more than 12 characters long"><cfscript>
      $(model).stubs("getUsername").returns("supercalifrag");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is too long (max is 12 characters)");
    </cfscript></it>

  </describe>

  <describe hint="(exact length)">

    <before><cfscript>
      model.validatesLengthOf(property="username", exactly=8);
    </cfscript></before>

    <it should="not add any errors if the username is exactly 8 characters long"><cfscript>
      $(model).stubs("getUsername").returns("supercal");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the username is less than 8 characters long"><cfscript>
      $(model).stubs("getUsername").returns("superca");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is the wrong length (should be 8 characters)");
    </cfscript></it>

    <it should="add the default error message if the username is more than 8 characters long"><cfscript>
      $(model).stubs("getUsername").returns("supercali");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is the wrong length (should be 8 characters)");
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <it should="add the specified error message if validation fails"><cfscript>
      model.validatesLengthOf("username", 3, 12, "must be a good length for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Person");
      $(model).stubs("getUsername").returns("x");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("must be a good length for Person");
    </cfscript></it>

    <it should="add the specified tooShort message if validation fails"><cfscript>
      model.validatesLengthOf(property="username", min=3, tooShort="is less than ? letters");
      $(model).stubs("getUsername").returns("x");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is less than 3 letters");
    </cfscript></it>

    <it should="add the specified tooLong message if validation fails"><cfscript>
      model.validatesLengthOf(property="username", max=12, tooLong="is more than ? letters");
      $(model).stubs("getUsername").returns("supercalifrag");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is more than 12 letters");
    </cfscript></it>

    <it should="add the specified wrongLength message if validation fails"><cfscript>
      model.validatesLengthOf(property="username", exactly=8, wrongLength="is not ? letters");
      $(model).stubs("getUsername").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("is not 8 letters");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesLengthOf(property="username", exactly=8, on="create");
      $(model).stubs("getUsername").returns("foo");
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
      model.validatesLengthOf(property="username", exactly=8, on="update");
      $(model).stubs("getUsername").returns("foo");
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
      model.validatesLengthOf(property="username", exactly=8, condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getUsername").returns("foo");
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
      model.validatesLengthOf(properties="username1,username2,username3,username4", min=3);
      $(model).stubs("getUsername1").returns("foo");
      $(model).stubs("getUsername2").returns("bar");
      $(model).stubs("getUsername3").returns("a");
      $(model).stubs("getUsername4").returns("b");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("username1").shouldBeEmpty();
      $(model).errors().on("username2").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("username3").shouldNotBeEmpty();
      $(model).errors().on("username4").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
