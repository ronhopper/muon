<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validatesUniquenessOf">

  <before><cfscript>
    dao = stub("DAO");
    metaData = {
      tableName = "widgets",
      classPath = "muon.model.Base",
      schema = "<fields></fields>"
    };
    model = createObject("component", "muon.model.Base").init(dao, metaData);
    propertyMap = { username="jadams" };
    resultSet = queryNew("");
    dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
  </cfscript></before>

  <describe hint="(with no options)">

    <before><cfscript>
      model.validatesUniquenessOf("username");
      $(model).stubs("isNewRecord").returns(false);
      $(model).stubs("getId").returns(42);
      $(model).stubs("getUsername").returns("jadams");
    </cfscript></before>

    <it should="not add any errors if the username is unique"><cfscript>
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the username is unique (except for this record)"><cfscript>
      queryAddColumn(resultSet, "id", listToArray("42"));
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the username is already taken"><cfscript>
      queryAddColumn(resultSet, "id", listToArray("3"));
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("has already been taken");
    </cfscript></it>

  </describe>

  <describe hint="(with scope)">

    <before><cfscript>
      model.validatesUniquenessOf("username", "siteId,groupId");
      $(model).stubs("isNewRecord").returns(false);
      $(model).stubs("getId").returns(42);
      $(model).stubs("getUsername").returns("jadams");
      $(model).stubs("getSiteId").returns(23);
      $(model).stubs("getGroupId").returns(42);
      propertyMap = { username="jadams", siteId=23, groupId=42 };
      dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
    </cfscript></before>

    <it should="not add any errors if the username is unique"><cfscript>
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="not add any errors if the username is unique (except for this record)"><cfscript>
      queryAddColumn(resultSet, "id", listToArray("42"));
      model.muonRunValidations();
      $(model).errors().shouldBeEmpty();
    </cfscript></it>

    <it should="add the default error message if the username is already taken"><cfscript>
      queryAddColumn(resultSet, "id", listToArray("3"));
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("has already been taken");
    </cfscript></it>

  </describe>

  <describe hint="(with a custom message)">

    <before><cfscript>
      model.validatesUniquenessOf("username", "", "must be unique in ##this.getClassName()##");
      $(model).stubs("getUsername").returns("jadams");
      $(model).stubs("getClassName").returns("User");
    </cfscript></before>

    <it should="add the specified error message if validation fails"><cfscript>
      queryAddColumn(resultSet, "id", listToArray("1,2,3"));
      model.muonRunValidations();
      $(model).errors().on("username").shouldEqual("must be unique in User");
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      model.validatesUniquenessOf(property="username", on="create");
      $(model).stubs("getUsername").returns("jadams");
      queryAddColumn(resultSet, "id", listToArray("1,2,3"));
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
      model.validatesUniquenessOf(property="username", on="update");
      $(model).stubs("getUsername").returns("jadams");
      queryAddColumn(resultSet, "id", listToArray("1,2,3"));
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
      model.validatesUniquenessOf(property="username", condition="1 + 1 eq ##this.getResult()##");
      $(model).stubs("getUsername").returns("jadams");
      queryAddColumn(resultSet, "id", listToArray("1,2,3"));
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
      model.validatesUniquenessOf(properties="username,accountId,email,phone");
      $(model).stubs("getUsername").returns("jadams");
      $(model).stubs("getAccountId").returns("1234567890");
      $(model).stubs("getEmail").returns("jadams@example.org");
      $(model).stubs("getPhone").returns("555-1234");

      resultSet = queryNew("");
      propertyMap = { username="jadams" };
      dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
      propertyMap = { accountId="1234567890" };
      dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
      resultSet = queryNew("");
      queryAddColumn(resultSet, "id", listToArray("1,2,3"));
      propertyMap = { email="jadams@example.org" };
      dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
      propertyMap = { phone="555-1234" };
      dao.stubs("listWidgets").with(propertyMap).returns(resultSet);
    </cfscript></before>

    <it should="not add errors to valid properties"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("username").shouldBeEmpty();
      $(model).errors().on("accountId").shouldBeEmpty();
    </cfscript></it>

    <it should="add errors to each invalid property"><cfscript>
      model.muonRunValidations();
      $(model).errors().on("email").shouldNotBeEmpty();
      $(model).errors().on("phone").shouldNotBeEmpty();
    </cfscript></it>

  </describe>

</describe>
