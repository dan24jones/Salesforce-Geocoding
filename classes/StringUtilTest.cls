@isTest
private class StringUtilTest {
  @isTest static void TestRemoveDoubleUnderscoreC() {
    String withDoubleUnderscoreC = 'Field__c';
    withDoubleUnderscoreC = StringUtil.RemoveDoubleUnderscoreC(withDoubleUnderscoreC);
    System.assertEquals('Field', withDoubleUnderscoreC);

    String withoutDoubleUnderscoreC = 'Field';
    withoutDoubleUnderscoreC = StringUtil.RemoveDoubleUnderscoreC(withoutDoubleUnderscoreC);
    System.assertEquals('Field', withoutDoubleUnderscoreC);
  }

  @isTest static void TestRemoveEndCharacters() {
    String shouldRemove = 'Hello world!';
    shouldRemove = StringUtil.RemoveEndCharacters(shouldRemove, 7);
    System.assertEquals('Hello', shouldRemove);

    String shouldNotRemove = 'Hello!';
    shouldNotRemove = StringUtil.RemoveEndCharacters(shouldNotRemove, 100);
    System.assertEquals('Hello!', shouldNotRemove);
  }
}