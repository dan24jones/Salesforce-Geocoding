@isTest
private class SObjectUtilTest {
  @testSetup static void TestData() {
    List<Account> accountList = TestUtil.MakeAccounts(10);

    System.debug('##### ' + accountList);

    INSERT accountList;
  }

  @isTest static void TestJSONMapToListSObject() {
    Map<Id, Account> accountList = new Map<Id, Account>([SELECT Id FROM Account]);
    System.assertEquals(10, accountList.size());

    List<SObject> objectList = new List<SObject>();

    Test.startTest();
      objectList = SObjectUtil.JSONMapToListSObject(JSON.serialize(accountList));
    Test.stopTest();

    System.assertEquals(10, objectList.size());
  }
  
  @isTest static void TestBadJSON() {
    List<SObject> objectList = new List<SObject>();

    Test.startTest();
      objectList = SObjectUtil.JSONMapToListSObject(JSON.serialize('"Bad": "JSON"'));
    Test.stopTest();

    System.assertEquals(0, objectList.size());
  }
}