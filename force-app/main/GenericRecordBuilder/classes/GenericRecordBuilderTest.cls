@isTest
public with sharing class GenericRecordBuilderTest
{
    @isTest
    private static void setAndGetPrimitives()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Lead.getSObjectType());
        String firstname = 'John';
        String lastname = 'Smith';

        System.Exception exceptionToCheck = NULL;
        String firstNameToCheck = NULL;
        String lastNameToCheck = NULL;

        Test.startTest();
        try
        {
            builder.setPrimitive(Lead.FirstName, firstname).setPrimitive(Lead.Lastname, lastname);
            firstNameToCheck = (String)builder.getPrimitive(Lead.FirstName);
            lastNameToCheck = (String)builder.getPrimitive(Lead.Lastname);
        } catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }
        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertEquals(firstname, firstNameToCheck);
        System.assertEquals(lastname, lastNameToCheck);
    }

    @isTest
    private static void setPrimitivesAndGetRecord()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Lead.getSObjectType());
        String firstname = 'John';
        String lastname = 'Smith';

        System.Exception exceptionToCheck = NULL;
        Lead recordToCheck = NULL;

        Test.startTest();
        try
        {
            builder.setPrimitive(Lead.FirstName, firstname).setPrimitive(Lead.Lastname, lastname);
            recordToCheck = (Lead)builder.getDeepClonedRecord();
        } catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }
        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, recordToCheck);
        System.assertEquals(firstname, recordToCheck.FirstName);
        System.assertEquals(lastname, recordToCheck.Lastname);
    }

    @isTest
    private static void setAndGetLookup()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Contact.getSObjectType());
        Account accountToBeReferenced = new Account(Id = '001000000000001', Name = 'ACME Inc');

        System.Exception exceptionToCheck = NULL;
        Account accountToCheck = NULL;

        Test.startTest();
        try
        {
            builder.setLookup(Contact.AccountId, accountToBeReferenced);
            accountToCheck = (Account)builder.getLookUp(Contact.AccountId);
            accountToBeReferenced.Id = '001000000000999';
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, accountToCheck);
        System.assertEquals(accountToBeReferenced.Id, accountToCheck.Id);
    }

    @isTest
    private static void setLookupAndGetRecord()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Contact.getSObjectType());
        Account accountToBeReferenced = new Account(Id = '001000000000001', Name = 'ACME Inc');

        System.Exception exceptionToCheck = NULL;
        Contact recordToCheck = NULL;

        Test.startTest();
        try
        {
            builder.setLookup(Contact.AccountId, accountToBeReferenced);
            recordToCheck = (Contact)builder.getDeepClonedRecord();
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, recordToCheck);
        System.assertNotEquals(NULL, recordToCheck.AccountId);
        System.assertEquals(accountToBeReferenced.Id, recordToCheck.AccountId);
        System.assertNotEquals(NULL, recordToCheck.Account);
        System.assertEquals(accountToBeReferenced.Id, recordToCheck.Account.Id);
    }

    @isTest
    private static void clearLookupAndGetRecord()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Contact.getSObjectType());
        Account accountToBeReferenced = new Account(Id = '001000000000001', Name = 'ACME Inc');

        System.Exception exceptionToCheck = NULL;
        Contact recordToCheck = NULL;

        builder.setLookup(Contact.AccountId, accountToBeReferenced);
        Test.startTest();
        try
        {
            builder.setLookup(Contact.AccountId, NULL);
            recordToCheck = (Contact)builder.getDeepClonedRecord();
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, recordToCheck);
        System.assertEquals(NULL, recordToCheck.AccountId);
        System.assertEquals(NULL, recordToCheck.Account);
    }

    @isTest
    private static void addAndGetRelated()
    {
        Schema.ChildRelationship contactList = NULL;
        for(Schema.ChildRelationship relationship : Schema.Account.getSObjectType().getDescribe().getChildRelationships())
        {
            if(relationship.getRelationshipName() == 'Contacts')
                contactList = relationship;
        }
        System.assertNotEquals(NULL, contactList);

        Contact cont_1 = new Contact(Id = '003000000000001');

        GenericRecordBuilder builder = new GenericRecordBuilder(Account.getSObjectType());

        System.Exception exceptionToCheck = NULL;
        List<Contact> relatedRecordsToCheck = NULL;

        Test.startTest();
        try
        {
            builder.addRelatedRecord(contactList, cont_1);
            relatedRecordsToCheck = (List<Contact>)builder.getRelatedRecords(contactList);
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, relatedRecordsToCheck);
        System.assertEquals(1, relatedRecordsToCheck.size());
        System.assertEquals(cont_1.Id, relatedRecordsToCheck[0].Id);
    }

    @isTest
    private static void addRelatedAndGetRecord()
    {
        Schema.ChildRelationship contactList = NULL;
        for(Schema.ChildRelationship relationship : Schema.Account.getSObjectType().getDescribe().getChildRelationships())
        {
            if(relationship.getRelationshipName() == 'Contacts')
                contactList = relationship;
        }
        System.assertNotEquals(NULL, contactList);

        Contact cont_1 = new Contact(Id = '003000000000001');
        Contact cont_2 = new Contact(Id = '003000000000002');

        GenericRecordBuilder builder = new GenericRecordBuilder(Account.getSObjectType());

        System.Exception exceptionToCheck = NULL;
        Account recordToCheck = NULL;
        List<Contact> relatedRecordsToCheck = NULL;

        Test.startTest();
        try
        {
            builder.addRelatedRecord(contactList, cont_1);
            builder.addRelatedRecord(contactList, cont_2);
            recordToCheck = (Account)builder.getDeepClonedRecord();
            relatedRecordsToCheck = recordToCheck.Contacts;
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, recordToCheck);
        System.assertNotEquals(NULL, relatedRecordsToCheck);
        System.assertEquals(2, relatedRecordsToCheck.size());
        System.assertEquals(cont_1.Id, relatedRecordsToCheck[0].Id);
        System.assertEquals(cont_2.Id, relatedRecordsToCheck[1].Id);
    }

    /**
     * This behavior is not intended but needs to be kept in mind
    **/
    @isTest
    private static void lookupConnectionLostOnClone()
    {
        GenericRecordBuilder builder = new GenericRecordBuilder(Contact.getSObjectType());
        Account accountToBeReferenced = new Account(Id = '001000000000001', Name = 'ACME Inc');

        System.Exception exceptionToCheck = NULL;
        Contact recordToCheck = NULL;
        builder.setLookup(Contact.AccountId, accountToBeReferenced);
        recordToCheck = (Contact)builder.getDeepClonedRecord();

        Test.startTest();
        try
        {
            accountToBeReferenced.Id = '001000000000999';
        }
        catch (System.Exception exc)
        {
            exceptionToCheck = exc;
        }

        Test.stopTest();

        System.assertEquals(NULL, exceptionToCheck);

        // after deepclone the connection between the original record and the result is lost
        System.assertNotEquals(accountToBeReferenced.Id, recordToCheck.Account.Id);
    }
}
