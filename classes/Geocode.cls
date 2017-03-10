public class Geocode {
  private static final String key = '[YOUR_API_KEY]';

  /*
  |--------------------------------------------------------------------------
  | JSON Parser
  |--------------------------------------------------------------------------
  |
  | This is a JSON to Apex Parser. Below will take the response
  | provided by Google's Geocoding API & deserialise it into
  | something we can refer to using Object-Oriented Apex.
  |
  */

  private List<Results> results;

  private class Results {
    private Geometry geometry;
  }

  private class Geometry {
    private Location location;
  }

  private class Location {
    private Double lat, lng;
  }

  private static Geocode Parse(String json) {
    return (Geocode)System.JSON.deserialize(json, Geocode.class);
  }

  /**
   * Make the callout to Google's API
   *
   * @param  String address
   * @return HttpResponse
   */

  private static HttpResponse MakeGetCallout(String address) {
    Http http = new Http();

    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + key);
    request.setMethod('GET');

    HttpResponse response = http.send(request);

    return response;
  }

  /**
   * Handle new object records
   *
   * @param  String objectAPIName
   * @param  String fieldAPIName
   * @param  String fieldSetAPIName
   * @param  Map<Id, sObject> objectMap
   * @return void
   */
  
  public static void UpdateGeocode(String objectAPIName, String fieldAPIName, String fieldSetAPIName, Map<Id, sObject> objectMap) {
    if (!Test.isRunningTest() || TestUtil.IsTestingMethod('UpdateGeocode')) {
      DoUpdateGeocode(objectAPIName, fieldAPIName, fieldSetAPIName, JSON.serialize(objectMap));
    }
  }

  /**
   * Handle new and old object records
   *
   * @param  String objectAPIName
   * @param  String fieldAPIName
   * @param  String fieldSetAPIName
   * @param  Map<Id, sObject> newObjectMap
   * @param  Map<Id, sObject> oldObjectMap
   * @return void
   */
    
  public static void UpdateGeocode(String objectAPIName, String fieldAPIName, String fieldSetAPIName, Map<Id, sObject> newObjectMap, Map<Id, sObject> oldObjectMap) {
    if (!Test.isRunningTest() || TestUtil.IsTestingMethod('UpdateGeocode')) {
      Map<Id, sObject> objectMap = new Map<Id, sObject>();

      for (sObject obj : newObjectMap.values()) {
        for (Schema.FieldSetMember field : SchemaUtil.ReadFieldSet(objectAPIName, StringUtil.RemoveDoubleUnderscoreC(fieldSetAPIName))) {
          if (obj.get(field.getFieldPath()) != oldObjectMap.get(obj.Id).get(field.getFieldPath())) {
            objectMap.put(obj.Id, obj);

            break;
          }
        }
      }

      if (objectMap.size() > 0) {
        DoUpdateGeocode(objectAPIName, fieldAPIName, fieldSetAPIName, JSON.serialize(objectMap));
      }
    }
  }

  /**
   * Get objects, make callout and update
   *
   * @param  String objectAPIName
   * @param  String fieldAPIName
   * @param  String fieldSetAPIName
   * @param  String objectMap
   * @return void
   */

  @future(callout = true)
  private static void DoUpdateGeocode(String objectAPIName, String fieldAPIName, String fieldSetAPIName, String objectJSON) {
    List<sObject> objList = SObjectUtil.JSONMapToListSObject(objectJSON);
    fieldAPIName = StringUtil.RemoveDoubleUnderscoreC(fieldAPIName);
    String latitudeFieldAPIName = fieldAPIName + '__latitude__s', longitudeFieldAPIName = fieldAPIName + '__longitude__s', address;

    for (SObject obj : objList) {
      address = MakeAddress(obj, objectAPIName, fieldSetAPIName);

      if (!address.equals('')) {
        HttpResponse response = MakeGetCallout(address);

        if (response.getStatusCode() == 200) {
          Geocode geocodeClass = Parse(response.getBody());

          obj.put(latitudeFieldAPIName, geocodeClass.results[0].Geometry.Location.lat);
          obj.put(longitudeFieldAPIName, geocodeClass.results[0].Geometry.Location.lng);
        }
      }
    }

    Database.update(objList, false);
  }

  /**
   * Build the address
   *
   * @param  sObject obj
   * @param  String objectAPIName
   * @param  String fieldSetAPIName
   * @return String
   */

  private static String MakeAddress(sObject obj, String objectAPIName, String fieldSetAPIName) {
    String address = '';

    for (Schema.FieldSetMember field : SchemaUtil.ReadFieldSet(objectAPIName, StringUtil.RemoveDoubleUnderscoreC(fieldSetAPIName))) {
      if (obj.get(field.getFieldPath()) != null) {
        address += obj.get(field.getFieldPath()) + ', ';
      }
    }

    return StringUtil.RemoveEndCharacters(address, 2);
  }
}