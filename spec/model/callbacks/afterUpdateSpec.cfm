<cfimport taglib="/cfspec" prefix="">

<describe hint="model.afterUpdate">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("muonSave").returns(true);
  </cfscript></before>

  <describe hint="(on update)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(false);
    </cfscript></before>

    <it should="save, then run the callback"><cfscript>
      model.afterUpdate("myCallback");
      s = sequence("callbacks");
      $(model).expects("muonSave").inSequence(s);
      $(model).expects("myCallback").inSequence(s);
      $(model).save().shouldBeTrue();
    </cfscript></it>

    <it should="save, then run multiple callbacks"><cfscript>
      model.afterUpdate("cb1", "cb2", "cb3");
      s = sequence("callbacks");
      $(model).expects("muonSave").inSequence(s);
      $(model).expects("cb1").inSequence(s);
      $(model).expects("cb2").inSequence(s);
      $(model).expects("cb3").inSequence(s);
      $(model).save().shouldBeTrue();
    </cfscript></it>

  </describe>

  <describe hint="(on create)">

    <before><cfscript>
      $(model).stubs("isNewRecord").returns(true);
    </cfscript></before>

    <it should="not run the callback"><cfscript>
      model.afterUpdate("myCallback");
      $(model).expects("myCallback").never();
      $(model).save().shouldBeTrue();
    </cfscript></it>

  </describe>

</describe>
