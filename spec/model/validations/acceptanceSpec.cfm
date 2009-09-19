<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesAcceptanceOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesAcceptanceOf("isAgreed");
    </cfscript></before>

    <it should="not add any errors if isAgreed == 1"><cfscript>
      $(model).stubs("getIsAgreed").returns("1");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if isAgreed != 1"><cfscript>
      $(model).stubs("getIsAgreed").returns("0");
      model.muonRunValidations();
      $(model).errors().on("isAgreed").shouldEqual("must be accepted");
    </cfscript></it>

    <it should="add an error if isAgreed is not a simple value"><cfscript>
      $(model).stubs("getIsAgreed").returns(structNew());
      model.muonRunValidations();
      $(model).errors().on("isAgreed").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom acceptance value)">

    <before><cfscript>
      model.validatesAcceptanceOf("isAgreed", "indeed!");
    </cfscript></before>

    <it should="not add any errors if isAgreed == the custom acceptance value"><cfscript>
      $(model).stubs("getIsAgreed").returns("indeed!");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if isAgreed != the custom acceptance value"><cfscript>
      $(model).stubs("getIsAgreed").returns("1");
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesAcceptanceOf("isAgreed", "1", "must accept for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("License");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getIsAgreed").returns("");
      model.muonRunValidations();
      $(model).errors().on("isAgreed").shouldEqual("must accept for License");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesAcceptanceOf(property="isAgreed", on="create");
      $(model).stubs("getIsAgreed").returns("");
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
      model.validatesAcceptanceOf(property="isAgreed", on="update");
      $(model).stubs("getIsAgreed").returns("");
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
      model.validatesAcceptanceOf(property="isAgreed", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getIsAgreed").returns("");
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
      model.validatesAcceptanceOf(properties="oneIsAgreed,twoIsAgreed,threeIsAgreed,fourIsAgreed");
      $(model).stubs("getOneIsAgreed").returns("1");
      $(model).stubs("getTwoIsAgreed").returns("1");
      $(model).stubs("getThreeIsAgreed").returns("0");
      $(model).stubs("getFourIsAgreed").returns("0");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("oneIsAgreed").shouldBeEmpty();
      $(model).errors().on("twoIsAgreed").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("threeIsAgreed").shouldNotBeEmpty();
      $(model).errors().on("fourIsAgreed").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
