public class StringUtil {
  /**
   * Removes "__c" from the end of a String
   *
   * @param  String str
   * @return String
   */

  public static String RemoveDoubleUnderscoreC(String text) {
    if (text.endsWith('__c')) {
      text = text.substring(0, text.length() - 3);
    }

    return text;
  }

  /**
   * Removes characters from the end of a String
   *
   * @param  String str
   * @param  Integer count
   * @return String
   */

  public static String RemoveEndCharacters(String text, Integer count) {
    if (text.length() > count) {
      text = text.substring(0, text.length() - count);
    }

    return text;
  }
}