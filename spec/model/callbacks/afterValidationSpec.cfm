<cfimport taglib="/cfspec" prefix="">

<describe hint="model.afterValidation">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("isNewRecord").returns(true);
    $(model).stubs("muonSave").returns(true);
  </cfscript></before>

  <it should="validate, run the callback, then save"><cfscript>
    model.afterValidation("myCallback");
    s = sequence("callbacks");
    $(model).expects("muonRunValidations").inSequence(s);
    $(model).expects("myCallback").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

  <it should="validate, run multiple callbacks, then save"><cfscript>
    model.afterValidation("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("muonRunValidations").inSequence(s);
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").inSequence(s);
    $(model).expects("cb3").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

</describe>
