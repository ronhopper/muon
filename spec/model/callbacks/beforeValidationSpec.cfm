<cfimport taglib="/cfspec" prefix="">

<describe hint="model.beforeValidation">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("isNewRecord").returns(true);
    $(model).stubs("muonSave").returns(true);
  </cfscript></before>

  <it should="run the callback, validate, then save"><cfscript>
    model.beforeValidation("myCallback");
    s = sequence("callbacks");
    $(model).expects("myCallback").inSequence(s);
    $(model).expects("muonRunValidations").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

  <it should="run the callback (returning false), skip validation and not save"><cfscript>
    model.beforeValidation("myCallback");
    $(model).expects("myCallback").returns(false);
    $(model).expects("muonRunValidations").never();
    $(model).save().shouldBeFalse();
  </cfscript></it>

  <it should="run multiple callbacks, validate, then save"><cfscript>
    model.beforeValidation("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").inSequence(s);
    $(model).expects("cb3").inSequence(s);
    $(model).expects("muonRunValidations").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

  <it should="run multiple callbacks (2nd returns false), skip the rest, and not save"><cfscript>
    model.beforeValidation("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").returns(false).inSequence(s);
    $(model).expects("cb3").never();
    $(model).expects("muonRunValidations").never();
    $(model).save().shouldBeFalse();
  </cfscript></it>

</describe>
