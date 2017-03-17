@isTest
private class GeocodeTest {
  @testSetup static void TestData() {
    List<Account> accountList = TestUtil.MakeAccounts(100);
    
    for (Account acc : accountList) {
      acc.BillingStreet = '1600 Amphitheatre Parkway';
      acc.BillingCity = 'Mountain View';
      acc.BillingState = 'CA';
      acc.BillingPostalCode = '94043';
      acc.BillingCountry = 'USA';
    }

    INSERT accountList;
  }

  @isTest static void TestUpdateGeocodeInsertContext() {
    TestUtil.SetTestingMethod('UpdateGeocode');

    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GetGeocodeResourceUSA');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);

    List<Account> accountList = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account];

    Map<Id, Account> mapIdToAccount = new Map<Id, Account>();

    for (Account acc : accountList) {
      mapIdToAccount.put(acc.Id, acc);
    }

    Test.startTest();
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', mapIdToAccount);
    Test.stopTest();

    Account acc = [SELECT Billing_Geolocation__latitude__s, Billing_Geolocation__longitude__s FROM Account LIMIT 1];
    System.assertEquals(37.4219493, acc.Billing_Geolocation__latitude__s);
    System.assertEquals(-122.0847727, acc.Billing_Geolocation__longitude__s);
  }

  @isTest static void TestUpdateGeocodeUpdateContext() {
    TestUtil.SetTestingMethod('UpdateGeocode');

    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GetGeocodeResourceUK');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);

    List<Account> accountList = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account];
    Map<Id, Account> oldAccMap = new Map<Id, Account>();
    Map<Id, Account> newAccMap = new Map<Id, Account>();

    for (Account acc : accountList) {
      oldAccMap.put(acc.id, acc);

      acc.BillingStreet = '1-13 St Giles High St';
      acc.BillingCity = 'London';
      acc.BillingState = '';
      acc.BillingPostalCode = 'WC2H 8LG';
      acc.BillingCountry = 'United Kingdom';

      newAccMap.put(acc.Id, acc);
    }

    UPDATE accountList;

    Test.startTest();
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', newAccMap, oldAccMap);
    Test.stopTest();

    Account acc = [SELECT Billing_Geolocation__latitude__s, Billing_Geolocation__longitude__s FROM Account LIMIT 1];
    System.assertEquals(51.5160322, acc.Billing_Geolocation__latitude__s);
    System.assertEquals(-0.1271091, acc.Billing_Geolocation__longitude__s);
  }
}