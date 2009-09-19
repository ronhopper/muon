<cfimport taglib="/cfspec" prefix="">

<describe hint="model.Base">

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

  <it should="make the DAO accessible">
    <cfset $(model).dao().shouldBe(dao)>
  </it>

  <it should="have a singleton Errors object">
    <cfset errors = model.errors()>
    <cfset $(errors).shouldBeAnInstanceOf("muon.model.Errors")>
    <cfset $(model).errors().shouldBe(errors)>
  </it>

  <describe hint="isNewRecord">

    <it should="be a new record if never saved">
      <cfset $(model).shouldBeNewRecord()>
    </it>

    <it should="not be a new record after it's been saved">
      <cfset dao.stubs("muonInsertRecord").with("widgets", anyStruct()).returns(42)>
      <cfset model.save()>
      <cfset $(model).shouldNotBeNewRecord()>
    </it>

  </describe>

  <describe hint="save">

    <describe hint="(new record)">

      <it should="insert the record">
        <cfset data = { name="Bar" }>
        <cfset dao.expects("muonInsertRecord").with("widgets", data).returns(42)>
        <cfset model.setName("Bar")>
        <cfset model.save()>
      </it>

      <it should="save the new primary key back to the record">
        <cfset dao.stubs("muonInsertRecord").returns(42)>
        <cfset model.save()>
        <cfset $(model).getId().shouldEqual(42)>
      </it>

    </describe>

    <describe hint="(old record)">

      <before>
        <cfset model.setProperties(id=42, name="Bar")>
      </before>

      <it should="update the record">
        <cfset data = { id=42, name="Baz" }>
        <cfset dao.expects("muonUpdateRecord").with("widgets", data).returns(42)>
        <cfset model.setName("Baz")>
        <cfset model.save()>
      </it>

    </describe>

  </describe>

  <describe hint="delete">

    <describe hint="(new record)">

      <it should="throw an error">
        <cfset dao.stubs("muonDeleteRecord")>
        <cfset $(model).delete().shouldThrow()>
      </it>

    </describe>

    <describe hint="(old record)">

      <before>
        <cfset model.setProperties(id=42, name="Bar")>
      </before>

      <it should="delete the record">
        <cfset data = { id=42 }>
        <cfset dao.expects("muonDeleteRecord").with("widgets", data)>
        <cfset model.delete()>
      </it>

    </describe>

  </describe>

</describe>
