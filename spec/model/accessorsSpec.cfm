<cfimport taglib="/cfspec" prefix="">

<describe hint="model.Base (accessors)">

  <before>
    <cfset dao = stub("DataAccessObject")>
    <cfset metaData = {
      tableName = "widgets",
      schema = '<table>
                  <field ColumnName="id"/>
                  <field ColumnName="name" Default="''foo''"/>
                  <field ColumnName="createdAt" Default="current_timestamp()"/>
                </table>'
    }>
    <cfset model = createObject("component", "muon.model.Base").init(dao, metaData)>
  </before>

  <it should="auto-generate getters/setters for schema fields">
    <cfset model.setName("My Name")>
    <cfset $(model).getName().shouldEqual("My Name")>
  </it>

  <it should="have default values for properties">
    <cfset $(model).getName().shouldEqual("foo")>
    <cfset $(model).getCreatedAt().shouldBeDate()>
  </it>

  <describe hint="propertyReader">

    <before>
      <cfset model.propertyReader("size")>
      <cfset model.muonSet("setSize", listToArray("small"))>
    </before>

    <it should="generate a getter for the property">
      <cfset $(model).getSize().shouldEqual("small")>
    </it>

    <it should="not generate a setter for the property">
      <cfset $(model).setSize("large").shouldThrow()>
    </it>

  </describe>

  <describe hint="propertyWriter">

    <before>
      <cfset model.propertyWriter("size")>
      <cfset model.muonSet("setSize", listToArray("small"))>
    </before>

    <it should="generate a setter for the property">
      <cfset model.setSize("large")>
      <cfset $(model).muonGet("getSize", listToArray("")).shouldEqual("large")>
    </it>

    <it should="not generate a getter for the property">
      <cfset $(model).getSize().shouldThrow()>
    </it>

  </describe>

  <describe hint="propertyAccessor">

    <before>
      <cfset model.propertyAccessor("size")>
      <cfset model.muonSet("setSize", listToArray("small"))>
    </before>

    <it should="generate a getter for the property">
      <cfset $(model).getSize().shouldEqual("small")>
    </it>

    <it should="generate a setter for the property">
      <cfset model.setSize("large")>
      <cfset $(model).muonGet("getSize", listToArray("")).shouldEqual("large")>
    </it>

  </describe>

  <describe hint="muonSetProperties">

    <it should="set each property from a given struct">
      <cfset data = { name = "George" }>
      <cfset model.muonSetProperties(data)>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

    <it should="set each property from named arguments">
      <cfset model.muonSetProperties(name="George")>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

    <it should="set each property from a single-row query">
      <cfset query = queryNew("")>
      <cfset queryAddColumn(query, "name", listToArray("George"))>
      <cfset model.muonSetProperties(query)>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

    <it should="set each property NOT through the setters (possibly overridden)">
      <cfset $(model).stubs("setName")><!--- makes the setter do nothing --->
      <cfset model.muonSetProperties(name="George")>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

  </describe>

  <describe hint="setProperties">

    <it should="set each property from a given struct">
      <cfset data = { name = "George" }>
      <cfset model.setProperties(data)>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

    <it should="set each property from named arguments">
      <cfset model.setProperties(name="George")>
      <cfset $(model).getName().shouldEqual("George")>
    </it>

    <it should="set each property through actual setters (possibly overridden)">
      <cfset $(model).stubs("setName")><!--- makes the setter do nothing --->
      <cfset model.setProperties(name="George")>
      <cfset $(model).getName().shouldEqual("foo")>
    </it>

  </describe>

</describe>
