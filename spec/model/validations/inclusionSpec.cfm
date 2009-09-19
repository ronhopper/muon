<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesInclusionOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesInclusionOf("status", "good,bad,ugly");
    </cfscript></before>

    <it should="not add any errors if the status is in the list"><cfscript>
      $(model).stubs("getStatus").returns("ugly");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the status is null"><cfscript>
      $(model).stubs("getStatus").returns("");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the status is not included in the list"><cfscript>
      $(model).stubs("getStatus").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("status").shouldEqual("is not included in the list");
    </cfscript></it>

    <it should="add an error if the status is not a simple value"><cfscript>
      $(model).stubs("getStatus").returns(structNew());
      model.muonRunValidations();
      $(model).errors().on("status").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with an array of options)">

    <before><cfscript>
      options = ["good", "bad", "ugly"];
      model.validatesInclusionOf("status", options);
    </cfscript></before>

    <it should="not add any errors if the status is in the list"><cfscript>
      $(model).stubs("getStatus").returns("ugly");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the status is null"><cfscript>
      $(model).stubs("getStatus").returns("");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the status is not included in the list"><cfscript>
      $(model).stubs("getStatus").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("status").shouldEqual("is not included in the list");
    </cfscript></it>

    <it should="add an error if the status is not a simple value"><cfscript>
      $(model).stubs("getStatus").returns(structNew());
      model.muonRunValidations();
      $(model).errors().on("status").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesInclusionOf("status", "good,bad,ugly", "must be a good ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Movie");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getStatus").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("status").shouldEqual("must be a good Movie");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesInclusionOf(property="status", with="good,bad,ugly", on="create");
      $(model).stubs("getStatus").returns("foo");
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
      model.validatesInclusionOf(property="status", with="good,bad,ugly", on="update");
      $(model).stubs("getStatus").returns("foo");
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
      model.validatesInclusionOf(property="status", with="good,bad,ugly", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getStatus").returns("foo");
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
      model.validatesInclusionOf(properties="s1,s2,s3,s4", with="good,bad,ugly");
      $(model).stubs("getS1").returns("good");
      $(model).stubs("getS2").returns("ugly");
      $(model).stubs("getS3").returns("foo");
      $(model).stubs("getS4").returns("bar");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("s1").shouldBeEmpty();
      $(model).errors().on("s2").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("s3").shouldNotBeEmpty();
      $(model).errors().on("s4").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
