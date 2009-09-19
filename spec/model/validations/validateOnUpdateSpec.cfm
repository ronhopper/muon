<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validateOnUpdate">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <describe hint="(on update)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(false);
    </cfscript></before>

    <it should="run the validation method"><cfscript>
      model.validateOnUpdate("ensureFoo");
      $(model).expects("ensureFoo");
      model.muonRunValidations();
    </cfscript></it>

    <it should="run each validation method in order"><cfscript>
      model.validateOnUpdate("ensureFoo", "ensureBar", "ensureBaz");
      s = sequence("validations");
      $(model).expects("ensureFoo").inSequence(s);
      $(model).expects("ensureBar").inSequence(s);
      $(model).expects("ensureBaz").inSequence(s);
      model.muonRunValidations();
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(true);
    </cfscript></before>

    <it should="skip the validation method"><cfscript>
      model.validateOnUpdate("ensureFoo");
      $(model).expects("ensureFoo").never();
      model.muonRunValidations();
    </cfscript></it>

    <it should="skip all validation methods"><cfscript>
      model.validateOnUpdate("ensureFoo", "ensureBar", "ensureBaz");
      $(model).expects("ensureFoo").never();
      $(model).expects("ensureBar").never();
      $(model).expects("ensureBaz").never();
      model.muonRunValidations();
    </cfscript></it>

  </describe>

</describe>
