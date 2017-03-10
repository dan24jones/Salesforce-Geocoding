@isTest
private class TestUtilTest {
  @isTest static void TestTestingMethod() {
    TestUtil.SetTestingMethod('TrueTestMethod');
    System.assertEquals(true, TestUtil.IsTestingMethod('TrueTestMethod'));
    System.assertEquals(false, TestUtil.IsTestingMethod('FalseTestMethod'));
  }

  @isTest static void TestMakeAccounts() {
  	List<Account> accountList = TestUtil.MakeAccounts(15);
  	System.assertEquals(15, accountList.size());
  }
}