<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesFormatOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesFormatOf("ssn", "^\d\d\d-\d\d-\d\d\d\d$");
    </cfscript></before>

    <it should="not add any errors if the SSN matches the format string"><cfscript>
      $(model).stubs("getSSN").returns("123-45-6789");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the SSN is null"><cfscript>
      $(model).stubs("getSSN").returns("");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the SSN does not match the format string"><cfscript>
      $(model).stubs("getSSN").returns("123456789");
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
      model.validatesFormatOf("ssn", "^\d\d\d-\d\d-\d\d\d\d$", "must be valid for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Person");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getSSN").returns("0");
      model.muonRunValidations();
      $(model).errors().on("ssn").shouldEqual("must be valid for Person");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesFormatOf(property="ssn", with="^\d\d\d-\d\d-\d\d\d\d$", on="create");
      $(model).stubs("getSSN").returns("0");
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
      model.validatesFormatOf(property="ssn", with="^\d\d\d-\d\d-\d\d\d\d$", on="update");
      $(model).stubs("getSSN").returns("0");
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
      model.validatesFormatOf(property="ssn", with="^\d\d\d-\d\d-\d\d\d\d$", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getSSN").returns("0");
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
      model.validatesFormatOf(properties="firstName,lastName,email,phone", with="\d");
      $(model).stubs("getFirstName").returns("John");
      $(model).stubs("getLastName").returns("Adams");
      $(model).stubs("getEmail").returns("jadams1776@example.org");
      $(model).stubs("getPhone").returns("555-1234");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("email").shouldBeEmpty();
      $(model).errors().on("phone").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("firstName").shouldNotBeEmpty();
      $(model).errors().on("lastName").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
