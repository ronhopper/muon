<cfimport taglib="/cfspec" prefix="">

<describe hint="model.afterSave">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("isNewRecord").returns(true);
    $(model).stubs("muonSave").returns(true);
  </cfscript></before>

  <it should="save, then run the callback"><cfscript>
    model.afterSave("myCallback");
    s = sequence("callbacks");
    $(model).expects("muonSave").inSequence(s);
    $(model).expects("myCallback").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

  <it should="save, then run multiple callbacks"><cfscript>
    model.afterSave("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("muonSave").inSequence(s);
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").inSequence(s);
    $(model).expects("cb3").inSequence(s);
    $(model).save().shouldBeTrue();
  </cfscript></it>

</describe>
