<cfimport taglib="/cfspec" prefix="">

<describe hint="model.validate">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
  </cfscript></before>

  <it should="runs the validation method"><cfscript>
    model.validate("ensureFoo");
    $(model).expects("ensureFoo");
    model.muonRunValidations();
  </cfscript></it>

  <it should="run each validation method in order"><cfscript>
    model.validate("ensureFoo", "ensureBar", "ensureBaz");
    s = sequence("validations");
    $(model).expects("ensureFoo").inSequence(s);
    $(model).expects("ensureBar").inSequence(s);
    $(model).expects("ensureBaz").inSequence(s);
    model.muonRunValidations();
  </cfscript></it>

</describe>
