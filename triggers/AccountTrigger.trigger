trigger AccountTrigger on Account (after insert, after update) {
  if (Trigger.isAfter) {
    if (Trigger.isInsert) {
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', Trigger.newMap);
      Geocode.UpdateGeocode('Account', 'Shipping_Geolocation__c', 'Shipping_Address', Trigger.newMap);
    }

    if (Trigger.isUpdate) {
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', Trigger.newMap, Trigger.oldMap);
      Geocode.UpdateGeocode('Account', 'Shipping_Geolocation__c', 'Shipping_Address', Trigger.newMap, Trigger.oldMap);
    }
  }
}