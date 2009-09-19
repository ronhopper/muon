<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesNumericalityOf">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesNumericalityOf("age");
    </cfscript></before>

    <it should="not add any errors if the age is numeric"><cfscript>
      $(model).stubs("getAge").returns("-42.0001");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the age is not numeric"><cfscript>
      $(model).stubs("getAge").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("age").shouldEqual("is not a number");
    </cfscript></it>

    <it should="not add an error if the age is null"><cfscript>
      $(model).stubs("getAge").returns("");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesNumericalityOf("age", "must be numeric for ##this.getClassName()##");
      $(model).stubs("getClassName").returns("Person");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      $(model).stubs("getAge").returns("foo");
      model.muonRunValidations();
      $(model).errors().on("age").shouldEqual("must be numeric for Person");
    </cfscript></it>

  </describe>

  <describe hint="(only integer)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", onlyInteger=true);
    </cfscript></before>

    <it should="not add an error if the age is an integer"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is not an integer"><cfscript>
      $(model).stubs("getAge").returns("42.5");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(greater than)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", greaterThan=42);
    </cfscript></before>

    <it should="not add an error if the age is greater than 42"><cfscript>
      $(model).stubs("getAge").returns("43");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is equal to 42"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is less than 42"><cfscript>
      $(model).stubs("getAge").returns("41");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(greater than or equal to)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", greaterThanOrEqualTo=42);
    </cfscript></before>

    <it should="not add an error if the age is greater than 42"><cfscript>
      $(model).stubs("getAge").returns("43");
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is equal to 42"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is less than 42"><cfscript>
      $(model).stubs("getAge").returns("41");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(equal to)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", equalTo=42);
    </cfscript></before>

    <it should="add an error if the age is greater than 42"><cfscript>
      $(model).stubs("getAge").returns("43");
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is equal to 42"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is less than 42"><cfscript>
      $(model).stubs("getAge").returns("41");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(less than or equal to)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", lessThanOrEqualTo=42);
    </cfscript></before>

    <it should="add an error if the age is greater than 42"><cfscript>
      $(model).stubs("getAge").returns("43");
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is equal to 42"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is less than 42"><cfscript>
      $(model).stubs("getAge").returns("41");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(less than)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", lessThan=42);
    </cfscript></before>

    <it should="add an error if the age is greater than 42"><cfscript>
      $(model).stubs("getAge").returns("43");
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is equal to 42"><cfscript>
      $(model).stubs("getAge").returns("42");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is less than 42"><cfscript>
      $(model).stubs("getAge").returns("41");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(range)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", greaterThanOrEqualTo=18, lessThan=26);
    </cfscript></before>

    <it should="add an error if the age is greater than 26"><cfscript>
      $(model).stubs("getAge").returns("27");
      model.muonRunValidations();
      $(model).errors().shouldNotBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is equal to 26"><cfscript>
      $(model).stubs("getAge").returns("26");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is between 18 and 26"><cfscript>
      $(model).stubs("getAge").returns("22");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

    <it should="not add an error if the age is equal to 18"><cfscript>
      $(model).stubs("getAge").returns("18");
      model.muonRunValidations();
      $(model).errors().on("age").shouldBeEmpty();
    </cfscript></it>

    <it should="add an error if the age is less than 18"><cfscript>
      $(model).stubs("getAge").returns("17");
      model.muonRunValidations();
      $(model).errors().on("age").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesNumericalityOf(property="age", on="create");
      $(model).stubs("getAge").returns("foo");
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
      model.validatesNumericalityOf(property="age", on="update");
      $(model).stubs("getAge").returns("foo");
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
      model.validatesNumericalityOf(property="age", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getAge").returns("foo");
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
      model.validatesNumericalityOf(properties="age1,age2,age3,age4");
      $(model).stubs("getAge1").returns(1);
      $(model).stubs("getAge2").returns(2);
      $(model).stubs("getAge3").returns("three");
      $(model).stubs("getAge4").returns("four");
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("age1").shouldBeEmpty();
      $(model).errors().on("age2").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("age3").shouldNotBeEmpty();
      $(model).errors().on("age4").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
