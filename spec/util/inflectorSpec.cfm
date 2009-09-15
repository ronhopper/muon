<cfimport taglib="/cfspec" prefix="">

<describe hint="Inflector">

  <before>
    <cfset inflector = createObject("component", "muon.util.Inflector").init()>
  </before>

  <describe hint="plurals">

    <it should="pluralize regular words">
      <cfset $(inflector).pluralize("post").shouldEqual("posts")>
    </it>

    <it should="pluralize irregular words">
      <cfset $(inflector).pluralize("octopus").shouldEqual("octopi")>
    </it>

    <it should="pluralize uncountable words">
      <cfset $(inflector).pluralize("sheep").shouldEqual("sheep")>
    </it>

    <it should="not re-pluralize words">
      <cfset $(inflector).pluralize("words").shouldEqual("words")>
    </it>

    <it should="pluralize phrases">
      <cfset $(inflector).pluralize("the blue mailman").shouldEqual("the blue mailmen")>
    </it>

    <it should="pluralize compound words">
      <cfset $(inflector).pluralize("CamelOctopus").shouldEqual("CamelOctopi")>
    </it>

    <it should="pluralize according to user-defined rules">
      <cfset inflector.plural("osha(d|t)$", "osha\1ki")>
      <cfset $(inflector).pluralize("loshad").shouldEqual("loshadki")>
    </it>

  </describe>

  <describe hint="singulars">

    <it should="singularize regular words">
      <cfset $(inflector).singularize("posts").shouldEqual("post")>
    </it>

    <it should="singularize irregular words">
      <cfset $(inflector).singularize("octopi").shouldEqual("octopus")>
    </it>

    <it should="singularize uncountable words">
      <cfset $(inflector).singularize("sheep").shouldEqual("sheep")>
    </it>

    <it should="not re-singularize words">
      <cfset $(inflector).singularize("word").shouldEqual("word")>
    </it>

    <it should="singularize phrases">
      <cfset $(inflector).singularize("the blue mailmen").shouldEqual("the blue mailman")>
    </it>

    <it should="singularize compound words">
      <cfset $(inflector).singularize("CamelOctopi").shouldEqual("CamelOctopus")>
    </it>

    <it should="singularize according to user-defined rules">
      <cfset inflector.singular("osha(d|t)ki$", "osha\1")>
      <cfset $(inflector).singularize("loshadki").shouldEqual("loshad")>
    </it>

  </describe>

  <describe hint="irregulars">

    <before>
      <cfset inflector.irregular("foo", "fooz")>
    </before>

    <it should="pluralize user-defined irregulars">
      <cfset $(inflector).pluralize("foo").shouldEqual("fooz")>
    </it>

    <it should="singularize user-defined irregulars">
      <cfset $(inflector).singularize("fooz").shouldEqual("foo")>
    </it>

  </describe>

  <describe hint="uncountables">

    <it should="recognize common uncountable words">
      <cfset $(inflector).shouldBeUncountable("fish")>
    </it>

    <it should="recognize common countable words">
      <cfset $(inflector).shouldNotBeUncountable("cat")>
    </it>

    <it should="recognize user-defined uncountable words">
      <cfset inflector.uncountable("dog,cat,fox")>
      <cfset $(inflector).shouldBeUncountable("cat")>
    </it>

  </describe>

</describe>
