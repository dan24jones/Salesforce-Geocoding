@isTest
private class AccountTriggerTest {
  @isTest static void TestInsertAccount() {
    List<Account> accountList = TestUtil.MakeAccounts(10);

    Test.startTest();
      INSERT accountList;
    Test.stopTest();

    System.assertEquals(10, [SELECT Count() FROM Account]);
  }

  @isTest static void TestUpdateAccount() {
    List<Account> accountList = TestUtil.MakeAccounts(10);
    INSERT accountList;
    System.assertEquals(0, [SELECT Count() FROM Account WHERE Type != NULL]);

    for (Account acc : accountList) {
      acc.Type = 'Other';
    }

    Test.startTest();
      UPDATE accountList;
    Test.stopTest();

    System.assertEquals(10, [SELECT Count() FROM Account WHERE Type = 'Other']);
  }
}