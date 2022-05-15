@IsTest
public with sharing class FieldValueReaderTest {
  
  @IsTest
  static void fieldValueReaderReturnsTheValueOfTheFieldImplementsValueReaderInterface() {
    SObjectField leadCompanyField = Lead.Company;
    IValueReader instanceToCheck = new FieldValueReader(leadCompanyField);
    
    Lead lead1 = new Lead();
    lead1.put(leadCompanyField, 'testCompanyName1');
    Lead lead2 = new Lead();
    lead2.put(leadCompanyField, NULL);
    
    Test.startTest();
    String value1 = instanceToCheck.getValue(lead1);
    String value2 = instanceToCheck.getValue(lead2);
    Test.stopTest();
    
    System.assertEquals(lead1.get(leadCompanyField), value1);
    System.assertEquals(lead2.get(leadCompanyField), value2);
  }
}