@IsTest
public with sharing class UtilitiesTest {
    
    @IsTest
    static void mapSObjectListByFieldValuesCreatesPropperMap() {
        String TESTCOMPANY_1_NAME = 'TestCompany1';
        String TESTCOMPANY_2_NAME = 'TestCompany2';
        String TESTCOMPANY_3_NAME = 'TestCompany3';

        /**
         * Given
         * A list of leads with filled company fields
         */
        Lead lead1 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead3 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3};

        Test.startTest();
        /**
        * When
        * The map method of sobjectUtilities is called for the leadList and the company field
        */
        Map<String, SObject> mappedLeads = Utilities.sObjectsUtilities.mapSObjectListByFieldValues(leadList, Lead.Company);

        Test.stopTest();

        /**
         * Then
         * - The lead records are mapped
         * - The references are intact
         */
        //Check map
        System.assertEquals(3, mappedLeads.size());
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_1_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_2_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_3_NAME));

        // check lead1
        Lead lead1_ToCheck = (Lead)mappedLeads.get(TESTCOMPANY_1_NAME);
        System.assertEquals(lead1.Id, lead1_ToCheck.Id);
        lead1.LastName = TESTCOMPANY_1_NAME; // setting this value AFTER the mapping was done. if reference is not kept the mapped value won't change.
        System.assertEquals(lead1.LastName, lead1_ToCheck.LastName, 'The refence was not kept during mapping.');

        // check lead2
        Lead lead2_ToCheck = (Lead)mappedLeads.get(TESTCOMPANY_2_NAME);
        System.assertEquals(lead2.Id, lead2_ToCheck.Id);
        lead2.LastName = TESTCOMPANY_2_NAME; // setting this value AFTER the mapping was done. if reference is not kept the mapped value won't change.
        System.assertEquals(lead2.LastName, lead2_ToCheck.LastName, 'The refence was not kept during mapping.');

        // check lead3
        Lead lead3_ToCheck = (Lead)mappedLeads.get(TESTCOMPANY_3_NAME);
        System.assertEquals(lead3.Id, lead3_ToCheck.Id);
        lead3.LastName = TESTCOMPANY_3_NAME; // setting this value AFTER the mapping was done. if reference is not kept the mapped value won't change.
        System.assertEquals(lead3.LastName, lead3_ToCheck.LastName, 'The refence was not kept during mapping.');
    }

    @IsTest
    static void testMappingOfSObjectByFieldWithOptionRetainAll() {
        String TESTCOMPANY_1_NAME = 'TestCompany1';
        String TESTCOMPANY_2_NAME = 'TestCompany2';
        String TESTCOMPANY_3_NAME = 'TestCompany3';
        /**
            * Given
            * A list of leads with filled company fields
            */
        Lead lead1 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        Test.startTest();
        /**
        * When
        * The map method of sobjectUtilities is called for the leadList and the company field
        */
        Map<String, List<SObject>> mappedLeads = (Map<String, List<SObject>>)Utilities.sObjectsUtilities.mapSObjectListByValueReaderResults(
            leadList, new LeadCompanyReader());

        Test.stopTest();

        System.assertEquals(3, mappedLeads.size());
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_1_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_2_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_3_NAME));

        System.assertEquals(2, mappedLeads.get(TESTCOMPANY_1_NAME).size());
        System.assertEquals(2, mappedLeads.get(TESTCOMPANY_2_NAME).size());
        System.assertEquals(1, mappedLeads.get(TESTCOMPANY_3_NAME).size());

        System.assertEquals(lead1.Id, mappedLeads.get(TESTCOMPANY_1_NAME).get(0).Id);
        System.assertEquals(lead2.Id, mappedLeads.get(TESTCOMPANY_1_NAME).get(1).Id);
        System.assertEquals(lead3.Id, mappedLeads.get(TESTCOMPANY_2_NAME).get(0).Id);
        System.assertEquals(lead4.Id, mappedLeads.get(TESTCOMPANY_2_NAME).get(1).Id);
        System.assertEquals(lead5.Id, mappedLeads.get(TESTCOMPANY_3_NAME).get(0).Id);
    }

    @IsTest
    private static void testMappingOfSObjectByFieldWithOptionRetainLast() {
        String TESTCOMPANY_1_NAME = 'TestCompany1';
        String TESTCOMPANY_2_NAME = 'TestCompany2';
        String TESTCOMPANY_3_NAME = 'TestCompany3';
        /**
        * Given
        * A list of leads with filled company fields
        */
        Lead lead1 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);
        Lead lead6 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5, lead6};

        Test.startTest();
        /**
        * When
        * The map method of sobjectUtilities is called for the leadList and the company field
        */
        Map<String, SObject> mappedLeads = (Map<String, SObject>)Utilities.sObjectsUtilities.mapSObjectListByValueReaderResults(
            leadList, new LeadCompanyReader(), Utilities.MAP_RETAIN_MODE.RETAIN_LAST);
        Test.stopTest();

        System.assertEquals(3, mappedLeads.size());
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_1_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_2_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_3_NAME));

        System.assert(mappedLeads.get(TESTCOMPANY_1_NAME) instanceOf Lead);
        System.assertEquals(lead6.Id, mappedLeads.get(TESTCOMPANY_1_NAME).Id);

        System.assert(mappedLeads.get(TESTCOMPANY_2_NAME) instanceOf Lead);
        System.assertEquals(lead4.Id, mappedLeads.get(TESTCOMPANY_2_NAME).Id);

        System.assert(mappedLeads.get(TESTCOMPANY_3_NAME) instanceOf Lead);
        System.assertEquals(lead5.Id, mappedLeads.get(TESTCOMPANY_3_NAME).Id);
    }

    @IsTest
    static void mappingMethodTypeCastFromObjectToSObjectCausesException() {
     String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1};

        Test.startTest();
        System.Exception exception_ToCheck = NULL;
        try {
            Map<String, Lead> mappedLeads2 = (Map<String, Lead>)Utilities.sObjectsUtilities.mapSObjectListByValueReaderResults(
            leadList, new LeadCompanyReader(), Utilities.MAP_RETAIN_MODE.RETAIN_LAST);
        } catch(System.Exception exc) {
            exception_ToCheck = exc;
        }
        Test.stopTest();

        System.assertNotEquals(NULL, exception_ToCheck);
        System.assert(exception_ToCheck instanceOf System.TypeException);
        System.assertEquals('Invalid conversion from runtime type Map<String,SObject> to Map<String,Lead>', exception_ToCheck.getMessage());
    }

    @IsTest
    static void mappingMethodTypeCastFromObjectToListOfSObjectsIsFine() {
     String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
            Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2};

        Test.startTest();
        System.Exception exception_ToCheck = NULL;
        try {
            Map<String, List<Lead>> mappedLeads2 = (Map<String, List<Lead>>)Utilities.sObjectsUtilities.mapSObjectListByValueReaderResults(
            leadList, new LeadCompanyReader());
        } catch(System.Exception exc) {
            exception_ToCheck = exc;
        }
        Test.stopTest();

        System.assertEquals(NULL, exception_ToCheck);
    }

    private class LeadCompanyReader extends Utilities.FieldValueReader {
        public LeadCompanyReader() {
            super(Lead.Company);
        }
    }
}
