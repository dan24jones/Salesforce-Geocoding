@isTest
private class SchemaUtilTest {
  @isTest static void TestReadFieldSet() {
    List<Schema.FieldSetMember> fieldSet = SchemaUtil.ReadFieldSet('Account', 'Billing_Address');
    System.assertEquals(5, fieldSet.size());
    System.assertEquals('BillingStreet', fieldSet[0].getFieldPath());
  }
}