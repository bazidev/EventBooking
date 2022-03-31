/**
 * @description       :
 * @author            : melbazi@salesforce.com
 * @group             :
 * @last modified on  : 31-03-2022
 * @last modified by  : melbazi@salesforce.com
 **/
@isTest
global with sharing class ExternalSystemServiceTest {
  /**
   * @description Setep test data for attendee registration
   * @author melbazi@salesforce.com | 31-03-2022
   **/
  @TestSetup
  static void setup() {
    Test.startTest();
    Account acc = (Account) TestDataFactory.createSObject('Account');

    List<Contact> conList = TestDataFactory.createSObjectList(
      'Contact',
      new Map<String, Object>{
        'AccountId' => acc.Id,
        'email' => new List<String>{
          'dr.mustaphaelbazi@gmail.com',
          'melbazi@salesforce.com',
          'muselbazi@gmail.com'
        }
      },
      3
    );

    Case caseList = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{ 'AccountId' => acc.Id, 'Origin' => 'Phone' }
    );

    Test.stopTest();
  }

  /**
   * @description test attendee registration
   * @author melbazi@salesforce.com | 31-03-2022
   **/
  @isTest
  static void testRegisterAttendees() {
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new ExternalSystemServiceMock());
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock.

    Test.startTest();
    Case request = [SELECT Id FROM Case LIMIT 1];
    ExternalSystemService.registerAttendees(request.Id);
    Test.stopTest();

    List<Log__c> logs = [SELECT Message__c FROM Log__c];
    System.assertEquals(1, logs.size());
    System.assertEquals('success ', logs[0].Message__c);
  }
}
