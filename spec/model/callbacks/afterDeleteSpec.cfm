<cfimport taglib="/cfspec" prefix="">

<describe hint="model.afterDelete">

  <before><cfscript>
    model = createObject("component", "muon.model.Base");
    $(model).stubs("muonDelete");
  </cfscript></before>

  <it should="delete the object, then run the callback"><cfscript>
    model.afterDelete("myCallback");
    s = sequence("callbacks");
    $(model).expects("muonDelete").inSequence(s);
    $(model).expects("myCallback").inSequence(s);
    model.delete();
  </cfscript></it>

  <it should="delete the object, then run multiple callbacks"><cfscript>
    model.afterDelete("cb1", "cb2", "cb3");
    s = sequence("callbacks");
    $(model).expects("muonDelete").inSequence(s);
    $(model).expects("cb1").inSequence(s);
    $(model).expects("cb2").inSequence(s);
    $(model).expects("cb3").inSequence(s);
    model.delete();
  </cfscript></it>

</describe>
