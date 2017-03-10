public class TestUtil {
  private static String testingMethod;

  /**
   * Checks if the method is being tested
   *
   * @param  String method
   * @return Boolean
   */

  public static Boolean IsTestingMethod(String method) {
    return (testingMethod == method ? true : false);
  }

  /**
   * Sets the method being tested
   *
   * @param  String method
   * @return void
   */

  public static void SetTestingMethod(String method) {
    testingMethod = method;
  }

  /**
   * Creates test Accounts
   *
   * @param  Integer count
   * @return List<Account>
   */

  public static List<Account> MakeAccounts(Integer count) {
    List<Account> accountList = new List<Account>();

    for (Integer i = 0; i < count; i++) {
      accountList.add(new Account(
        Name = 'Account ' + i
      ));
    }

    return accountList;
  }
}