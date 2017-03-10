@isTest
private class GeocodeTest {
  @testSetup static void TestData() {
    Account acc = TestUtil.MakeAccounts(1)[0];
    
    acc.Name = 'Google';
    acc.BillingStreet = '1600 Amphitheatre Parkway';
    acc.BillingCity = 'Mountain View';
    acc.BillingState = 'CA';
    acc.BillingPostalCode = '94043';
    acc.BillingCountry = 'USA';

    INSERT acc;
  }

  @isTest static void TestUpdateGeocodeInsertContext() {
    TestUtil.SetTestingMethod('UpdateGeocode');

    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GetGeocodeResourceUSA');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);

    Account acc = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Name = 'Google' LIMIT 1];

    Test.startTest();
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', new Map<Id, Account> { acc.Id => acc });
    Test.stopTest();

    acc = [SELECT Billing_Geolocation__latitude__s, Billing_Geolocation__longitude__s FROM Account WHERE Name = 'Google' LIMIT 1];
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

    Account acc = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Name = 'Google' LIMIT 1];
     Map<Id, Account> oldAccMap = new Map<Id, Account> { acc.Id => acc };

    acc.BillingStreet = '1-13 St Giles High St';
    acc.BillingCity = 'London';
    acc.BillingState = '';
    acc.BillingPostalCode = 'WC2H 8LG';
    acc.BillingCountry = 'United Kingdom';
    UPDATE acc;   

    Test.startTest();
      Geocode.UpdateGeocode('Account', 'Billing_Geolocation__c', 'Billing_Address', new Map<Id, Account> { acc.Id => acc }, oldAccMap);
    Test.stopTest();

    acc = [SELECT Billing_Geolocation__latitude__s, Billing_Geolocation__longitude__s FROM Account WHERE Name = 'Google' LIMIT 1];
    System.assertEquals(51.5160322, acc.Billing_Geolocation__latitude__s);
    System.assertEquals(-0.1271091, acc.Billing_Geolocation__longitude__s);
  }
}