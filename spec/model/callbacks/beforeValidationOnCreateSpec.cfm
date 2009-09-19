<cfimport taglib="/cfspec" prefix="">

<describe hint="model.beforeValidationOnCreate">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("muonSave").returns(true);
  </cfscript></before>

  <describe hint="(on create)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(true);
    </cfscript></before>

    <it should="run the callback, validate, then save"><cfscript>
      model.beforeValidationOnCreate("myCallback");
      s = sequence("callbacks");
      $(model).expects("myCallback").inSequence(s);
      $(model).expects("muonRunValidations").inSequence(s);
      $(model).save().shouldBeTrue();
    </cfscript></it>

    <it should="run the callback (returning false), skip validation and not save"><cfscript>
      model.beforeValidationOnCreate("myCallback");
      $(model).expects("myCallback").returns(false);
      $(model).expects("muonRunValidations").never();
      $(model).save().shouldBeFalse();
    </cfscript></it>

    <it should="run multiple callbacks, validate, then save"><cfscript>
      model.beforeValidationOnCreate("cb1", "cb2", "cb3");
      s = sequence("callbacks");
      $(model).expects("cb1").inSequence(s);
      $(model).expects("cb2").inSequence(s);
      $(model).expects("cb3").inSequence(s);
      $(model).expects("muonRunValidations").inSequence(s);
      $(model).save().shouldBeTrue();
    </cfscript></it>

    <it should="run multiple callbacks (2nd returns false), skip the rest, and not save"><cfscript>
      model.beforeValidationOnCreate("cb1", "cb2", "cb3");
      s = sequence("callbacks");
      $(model).expects("cb1").inSequence(s);
      $(model).expects("cb2").returns(false).inSequence(s);
      $(model).expects("cb3").never();
      $(model).expects("muonRunValidations").never();
      $(model).save().shouldBeFalse();
    </cfscript></it>

  </describe>

  <describe hint="(on update)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(false);
    </cfscript></before>

    <it should="not run the callback"><cfscript>
      model.beforeValidationOnCreate("myCallback");
      $(model).expects("myCallback").never();
      $(model).save().shouldBeTrue();
    </cfscript></it>

  </describe>

</describe>
