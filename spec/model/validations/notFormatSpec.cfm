<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesNotFormatOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesNotFormatOf("ssn", "[a-z]");
    </cfscript></before>

    <it should="not add any errors if the SSN does not match the notFormat string"><cfscript>
      $(model).stubs("getSSN").returns("123-45-6789");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the SSN is null"><cfscript>
      $(model).stubs("getSSN").returns("");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the SSN does not match the notFormat string"><cfscript>
      $(model).stubs("getSSN").returns("xxx-xx-xxxx");
      model.muonRunValidations();
      $(model).errors().on("ssn").shouldEqual("is invalid");
    </cfscript></it>

    <it should="add an error if the SSN is not a simple value"><cfscript>
      $(model).stubs("getSSN").returns(structNew());
      model.muonRunValidations();
      $(model).errors().on("ssn").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesNotFormatOf("ssn", "[a-z]", "must be valid for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Person");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getSSN").returns("xxx-xx-xxxx");
      model.muonRunValidations();
      $(model).errors().on("ssn").shouldEqual("must be valid for Person");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesNotFormatOf(property="ssn", with="[a-z]", on="create");
      $(model).stubs("getSSN").returns("xxx-xx-xxxx");
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
      model.validatesNotFormatOf(property="ssn", with="[a-z]", on="update");
      $(model).stubs("getSSN").returns("xxx-xx-xxxx");
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
      model.validatesNotFormatOf(property="ssn", with="[a-z]", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getSSN").returns("xxx-xx-xxxx");
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
      model.validatesNotFormatOf(properties="firstName,lastName,email,phone", with="\d");
      $(model).stubs("getFirstName").returns("John");
      $(model).stubs("getLastName").returns("Adams");
      $(model).stubs("getEmail").returns("jadams1776@example.org");
      $(model).stubs("getPhone").returns("555-1234");
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
