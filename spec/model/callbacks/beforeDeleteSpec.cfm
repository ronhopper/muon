<cfimport taglib="/cfspec" prefix="">

<describe hint="model.beforeDelete">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("muonDelete").returns(true);
  </cfscript></before>

  <it should="run the callback, then delete the object"><cfscript>
    model.beforeDelete("myCallback");
    s = sequence("callbacks");
    $(model).expects("myCallback").inSequence(s);
    $(model).expects("muonDelete").inSequence(s);
    model.delete();
  </cfscript></it>

  <it should="run the callback (return false), then not delete the object"><cfscript>
    model.beforeDelete("myCallback");
    $(model).expects("myCallback").returns(false);
    $(model).expects("muonDelete").never();
    model.delete();
  </cfscript></it>

  <it should="run multiple callbacks, then delete the object"><cfscript>
    model.beforeDelete("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").inSequence(s);
    $(model).expects("cb3").inSequence(s);
    $(model).expects("muonDelete").inSequence(s);
    model.delete();
  </cfscript></it>

  <it should="run multiple callbacks (2nd returns false), then skips the rest"><cfscript>
    model.beforeDelete("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").returns(false).inSequence(s);
    $(model).expects("cb3").never();
    $(model).expects("muonDelete").never();
    model.delete();
  </cfscript></it>

</describe>
