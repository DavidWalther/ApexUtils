@IsTest
public with sharing class UtilitiesTest {
    
    //----------------------------
    // Mapping of SObjects
    //----------------------------
    
    private class LeadCompanyReader extends Utilities.FieldValueReader {
        public LeadCompanyReader() {
            super(Lead.Company);
        }
    }
    
    @IsTest
    static void mapUtil_SObjects_RetainMode_RetainAll() {
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
    private static void mapUtil_SObjects_RetainMode_RetainFirst() {
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
            leadList, new LeadCompanyReader(), Utilities.MAP_RETAIN_MODE.RETAIN_FIRST);
        Test.stopTest();
        
        System.assertEquals(3, mappedLeads.size());
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_1_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_2_NAME));
        System.assertEquals(true, mappedLeads.containsKey(TESTCOMPANY_3_NAME));
        
        System.assert(mappedLeads.get(TESTCOMPANY_1_NAME) instanceOf Lead);
        System.assertEquals(lead1.Id, mappedLeads.get(TESTCOMPANY_1_NAME).Id);
        
        System.assert(mappedLeads.get(TESTCOMPANY_2_NAME) instanceOf Lead);
        System.assertEquals(lead3.Id, mappedLeads.get(TESTCOMPANY_2_NAME).Id);
        
        System.assert(mappedLeads.get(TESTCOMPANY_3_NAME) instanceOf Lead);
        System.assertEquals(lead5.Id, mappedLeads.get(TESTCOMPANY_3_NAME).Id);
    }
    
    @IsTest
    private static void mapUtil_SObjects_RetainMode_RetainLast() {
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
    
    //----------------------------
    // Mapping of Objects
    //----------------------------
    
    /**
    * This is a simple example class to be mapped. It's a simple pair of integer values
    */
    private class IntegerPair {
        private Integer valueA;
        private Integer valueB;
        
        public IntegerPair(Integer valueA, Integer valueB) {
            this.valueA = valueA;
            this.valueB = valueB;
        }
        
        public Integer getValueA() {return this.valueA;}
        public Integer getValueB() {return this.valueB;}
    }
    
    /**
    * this reader returns the result of the modulo function as mapping key
    */
    private class ModValueReader implements IValueReader {
        public String getValue(Object objectToGetValueFrom) {
            if(objectToGetValueFrom instanceOf IntegerPair) {
                IntegerPair pairInstance = (IntegerPair)objectToGetValueFrom;
                return String.valueOf(Math.mod(
                pairInstance.getValueA(),
                pairInstance.getValueB()
                ));
            }
            return NULL;
        }
    }
    
    @IsTest
    static void mapUtil_Objects_RetainMode_RetainAll() {
        /**
        * Given
        * A List of IntegerPairs
        */
        IntegerPair pair1Modulo1 = new IntegerPair(4, 3);
        IntegerPair pair1Modulo2 = new IntegerPair(5, 3);
        IntegerPair pair2Modulo1 = new IntegerPair(7, 6);
        
        List<IntegerPair> integerpairs = new List<IntegerPair>{pair1Modulo1, pair1Modulo2, pair2Modulo1};
        
        Test.startTest();
        /**
        * When
        * the pairs are mapped by their modulo result and all entries are kept in map
        */
        Map<String, List<Object>> mappedLeads2 = (Map<String, List<Object>>)Utilities.sObjectsUtilities.mapObjectListByValueReaderResults(
            integerpairs,
            new ModValueReader(),
            Utilities.MAP_RETAIN_MODE.RETAIN_ALL, 
            new Set<Utilities.MAP_OPTIONS>(),
            new Set<String>()
        );
        Test.stopTest();
        
        /**
        * Then
        * - pairs (4,3) and (7,6) are mapped by value '1' (4 % 3 == 1 and 7 % 6 == 1) 
        * - pair (5,3) is mapped by value '2' (5 % 3 == 2) 
        */
        System.assertEquals(2, mappedLeads2.size());
        System.assert(mappedLeads2.containsKey('1'));
        System.assertEquals(2, mappedLeads2.get('1').size());
        System.assertEquals(pair1Modulo1.getValueA(), ((IntegerPair)mappedLeads2.get('1')[0]).getValueA());
        System.assertEquals(pair1Modulo1.getValueB(), ((IntegerPair)mappedLeads2.get('1')[0]).getValueB());
        System.assertEquals(pair2Modulo1.getValueA(), ((IntegerPair)mappedLeads2.get('1')[1]).getValueA());
        System.assertEquals(pair2Modulo1.getValueB(), ((IntegerPair)mappedLeads2.get('1')[1]).getValueB());
        
        System.assert(mappedLeads2.containsKey('2'));
        System.assertEquals(1, mappedLeads2.get('2').size());
        System.assertEquals(pair1Modulo2.getValueA(), ((IntegerPair)mappedLeads2.get('2')[0]).getValueA());
        System.assertEquals(pair1Modulo2.getValueB(), ((IntegerPair)mappedLeads2.get('2')[0]).getValueB());
    }
    
    @IsTest
    static void mapUtil_Objects_RetainMode_RetainFirst() {
        /**
        * Given
        * A List of IntegerPairs
        */
        IntegerPair pair1Modulo1 = new IntegerPair(4, 3);
        IntegerPair pair1Modulo2 = new IntegerPair(5, 3);
        IntegerPair pair2Modulo1 = new IntegerPair(7, 6);
        
        List<IntegerPair> integerpairs = new List<IntegerPair>{pair1Modulo1, pair1Modulo2, pair2Modulo1};
        
        Test.startTest();
        /**
        * When
        * the pairs are mapped by their modulo result and only the first entriy for each key is retained
        */
        Map<String, Object> mappedLeads2 = (Map<String, Object>)Utilities.sObjectsUtilities.mapObjectListByValueReaderResults(
            integerpairs,
            new ModValueReader(),
            Utilities.MAP_RETAIN_MODE.RETAIN_FIRST, 
            new Set<Utilities.MAP_OPTIONS>(),
            new Set<String>()
        );
        Test.stopTest();
        
        /**
        * Then
        * - pair (4,3) is mapped by value '1' (4 % 3 == 1)
        * - pair (5,3) is mapped by value '2' (5 % 3 == 2) 
        */
        System.assert(mappedLeads2.containsKey('1'));
        System.assertEquals(pair1Modulo1.getValueA(), ((IntegerPair)mappedLeads2.get('1')).getValueA());
        System.assertEquals(pair1Modulo1.getValueB(), ((IntegerPair)mappedLeads2.get('1')).getValueB());
        
        System.assert(mappedLeads2.containsKey('2'));
        System.assertEquals(pair1Modulo2.getValueA(), ((IntegerPair)mappedLeads2.get('2')).getValueA());
        System.assertEquals(pair1Modulo2.getValueB(), ((IntegerPair)mappedLeads2.get('2')).getValueB());
    }
    
    @IsTest
    static void mapUtil_Objects_RetainMode_RetainLast() {
        /**
        * Given
        * A List of IntegerPairs
        */
        IntegerPair pair1Modulo1 = new IntegerPair(4, 3);
        IntegerPair pair1Modulo2 = new IntegerPair(5, 3);
        IntegerPair pair2Modulo1 = new IntegerPair(7, 6);
        
        List<IntegerPair> integerpairs = new List<IntegerPair>{pair1Modulo1, pair1Modulo2, pair2Modulo1};
        
        Test.startTest();
        /**
        * When
        * the pairs are mapped by their modulo result and only the first entriy for each key is retained
        */
        Map<String, Object> mappedLeads2 = (Map<String, Object>)Utilities.sObjectsUtilities.mapObjectListByValueReaderResults(
            integerpairs,
            new ModValueReader(),
            Utilities.MAP_RETAIN_MODE.RETAIN_LAST, 
            new Set<Utilities.MAP_OPTIONS>(),
            new Set<String>()
        );
        Test.stopTest();
        
        /**
        * Then
        * - pair (4,3) is mapped by value '1' (7 % 6 == 1)
        * - pair (5,3) is mapped by value '2' (5 % 3 == 2) 
        */
        System.assert(mappedLeads2.containsKey('1'));
        System.assertEquals(pair2Modulo1.getValueA(), ((IntegerPair)mappedLeads2.get('1')).getValueA());
        System.assertEquals(pair2Modulo1.getValueB(), ((IntegerPair)mappedLeads2.get('1')).getValueB());
        
        System.assert(mappedLeads2.containsKey('2'));
        System.assertEquals(pair1Modulo2.getValueA(), ((IntegerPair)mappedLeads2.get('2')).getValueA());
        System.assertEquals(pair1Modulo2.getValueB(), ((IntegerPair)mappedLeads2.get('2')).getValueB());
    }
    
    //----------------------------
    // Tests for mapping considerations
    //----------------------------
    
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
    static void mappingMethodResultCanBeTransformedIntoOriginalType() {
        String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
        Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        
        List<Lead> leadList = new List<Lead>{lead1};
        
        Lead leadToCheck = NULL;
        System.Exception exception_ToCheck = NULL;
        
        Test.startTest();
        try {
            Map<String, Object> mappedLeads2 = Utilities.sObjectsUtilities.mapSObjectListByValueReaderResults(
            leadList, new LeadCompanyReader(), Utilities.MAP_RETAIN_MODE.RETAIN_LAST);
            leadToCheck = (Lead)mappedLeads2.values().get(0);
        } catch(System.Exception exc) {
            exception_ToCheck = exc;
        }
        Test.stopTest();
        
        System.assertEquals(NULL, exception_ToCheck);
        System.assertNotEquals(NULL, leadToCheck);
        System.assertEquals(lead1.Id, leadToCheck.Id);
    }    
}
