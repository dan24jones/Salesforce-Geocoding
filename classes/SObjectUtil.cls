public class SObjectUtil {
  /**
   * Turn JSON Serialised Map<Id, sObject> to a List<sObject>
   *
   * @param  String objectJSON
   * @return List<sObject>
   */
   
  public static List<sObject> JSONMapToListSObject(String objectJSON) {
    List<sObject> objList = new List<sObject>();

    try {
      for (sObject obj : ((Map<Id, sObject>)JSON.deserialize(objectJSON, Type.forName('Map<Id, sObject>'))).values()) {
        objList.add(obj);
      }
    }
    catch (JSONException e) {
      System.debug('##### ' + e);
    }

    return objList;
  }
}