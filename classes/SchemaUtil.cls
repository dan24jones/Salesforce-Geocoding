public class SchemaUtil {
  /**
   * Read Field Set and return it's Fields
   *
   * @param  String objectAPIName
   * @param  String fieldSetAPIName
   * @return List<Schema.FieldSetMember>
   */
   
  public static List<Schema.FieldSetMember> ReadFieldSet(String objectAPIName, String fieldSetAPIName) {
    Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
    Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectAPIName);
    Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
    Schema.FieldSet fieldSet = describeSObjectResultObj.FieldSets.getMap().get(fieldSetAPIName);

    return fieldSet.getFields(); 
  }
}