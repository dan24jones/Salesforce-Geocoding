# Salesforce-Geocoding
Provides the framework including Apex Classes, Apex Triggers and Unit Tests to allow for easy Geocoding of Fields via Google's Geocoding API

**Important** This code is in it's early stages, thus care should be taken if you deploy to a Production environment. Any loss of code/data/sanity is **your** responsibility. :)

## Example
You can Geocode any object by calling the following method in the relevant Trigger in `Trigger.isAfter` context:

### Insert

`Geocode.UpdateGeocode(String objectAPIName, String geolocationFieldAPIName, String addressFieldSet, Trigger.newMap);`

For example:

`Geocode.UpdateGeocode('Account', 'Shipping_Geolocation__c', 'Shipping_Address', Trigger.newMap);`

### Update

`Geocode.UpdateGeocode(String objectAPIName, String geolocationFieldAPIName, String addressFieldSet, Trigger.newMap, Trigger.oldMap);`

For example:

`Geocode.UpdateGeocode('Account', 'Shipping_Geolocation__c', 'Shipping_Address', Trigger.newMap, Trigger.oldMap);`

### Considerations

- The object name **should** be the API name as a String. For example:
  - Account
  - Contact
  - Employee__c
- The Geolocation Field should be in the form of it's API name (e.g. Shipping_Geolocation__c)
- The Field Set should be in the form of it's API name (e.g. Shipping_Address)
  - **Ordering is Important!** Ensure the Fields are ordered as you'd expect an address to be read. For example, Billing Street, Billing City, Billing State/County, Billing Postal Code, Billing Country
  - You're not limited to using these Fields, so long as the Fields can be read as an address
- Maps **must** be used in the latter two parameters (i.e. `Trigger.newMap` and `Trigger.oldMap`)

## Motivation
Geocoding is an incredibly powerful feature Salesforce supports, I wanted to write a small application that allows developers to write one line of code, that can be used on any object, that can Geocode any Field.

## Installation
The package can be installed by going to [Salesforce Workbench](https://workbench.developerforce.com/login.php) and going to:

1. Migration
2. Deploy
3. Choose the package (contained as a .zip file)
4. Select "Rollback On Error"
5. Select "Single Package"
6. Select "RunLocalTests" on "Test Level"
7. Click "Next"

**Important** This code is in it's early stages and should be deployed to a Sandbox or Developer environment. Care should be taken if you deploy to a Production environment. Any loss of code/data/sanity is **your** responsibility. :)

## Considerations

- You'll need to modify the `Geocode` class and replace "[YOUR_API_KEY]" with your Google Geocode API key that you can obtain from [Google Maps APIs](https://developers.google.com/maps/documentation/geocoding/start)
- The app comes with several utility classes:
  - SchemaUtil
  - SObjectUtil
  - StringUtil
  - TestUtil
- The app comes with some example meta data primarily to support Unit Tests:
  - Two Fields:
    - Billing_Geolocation__c on Account
    - Shipping_Geolocation__c on Account
  - Two Field Sets:
    - Billing_Address
    - Shipping_Address
  - One Trigger:
    - AccountTrigger.trigger
  - Two Static Resources:
    - GetGeocodeResourceUK
    - GetGeocodeResourceUSA
    - **Important** These are used to provide a mock response when running Unit Tests
- The app **is not yet namespaced** which means there could be conflicts if you install this package to an Org that already has classes called Geocode.cls, AccountTrigger.trigger, SchemaUtil.cls etc...

## Tests

The following Test Classes:

- AccountTriggerTest
- GeocodeTest
- SchemaUtilTest
- SObjectUtilTest
- StringUtilTest
- TestUtilTest

Can be ran in your environment and should run with 100% coverage.
