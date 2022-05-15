@IsTest
public with sharing class MapUtility_MappingMainTest {

    //----------------------------
    // Mapping of SObjects
    //----------------------------

    /**
     * This extension of the FieldValueReader reads the Lead.Company field for a mapping key
     */
    private virtual class LeadCompanyReader extends FieldValueReader implements IValueReader {
        public LeadCompanyReader() {
            super(Lead.Company);
        }
    }

    @IsTest
    static void mapUtil_SObjects_RetainMode_RetainAll() {
        /**
         * Given
         * - A list of leads with filled company fields.
         * - Multiple leads have the same value
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        final String TESTCOMPANY_3_NAME = 'TestCompany3';

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
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<String, List<SObject>> mappedLeads = (Map<String, List<SObject>>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new Set<MAP_OPTIONS>(),
            new Set<String>()
        );

        Test.stopTest();

        /**
         * Then
         * A collection of all matching lead in list for every company value in the result
         */
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
    static void mapUtil_SObjects_RetainMode_RetainFirst() {
        /**
         * Given
         * - A list of leads with filled company fields.
         * - Multiple leads have the same value
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        final String TESTCOMPANY_3_NAME = 'TestCompany3';

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
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<String, SObject> mappedLeads = (Map<String, SObject>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_FIRST,
            new Set<MAP_OPTIONS>(),
            new Set<String>()
        );
        Test.stopTest();

        /**
         * Then
         * The first lead in list for every company value in the result
         */
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
    static void mapUtil_SObjects_RetainMode_RetainLast() {
        /**
         * Given
         * - A list of leads with filled company fields.
         * - Multiple leads have the same value
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        final String TESTCOMPANY_3_NAME = 'TestCompany3';

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
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<String, SObject> mappedLeads = (Map<String, SObject>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new Set<MAP_OPTIONS>(),
            new Set<String>()
        );
        Test.stopTest();

        /**
         * Then
         * The last lead in list for every company value in the result
         */
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
        Map<String, List<Object>> mappedLeads2 = (Map<String, List<Object>>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new Set<MAP_OPTIONS>(),
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
        Map<String, Object> mappedLeads2 = (Map<String, Object>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_FIRST,
            new Set<MAP_OPTIONS>(),
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
        Map<String, Object> mappedLeads2 = (Map<String, Object>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new Set<MAP_OPTIONS>(),
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
    // Typecast behavior
    //----------------------------

    @IsTest
    static void typeCast_ImplicitTypeCastOfCollectionSucceeds() {
        /**
         * Given
         * A list of leads to map
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';

        Lead lead1 = new Lead(
        Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2};

        /**
         * When
         * The result is a map containing a collection and is casted to a map of collection of specific
         */
        Test.startTest();
        System.Exception exception_ToCheck = NULL;
        Map<String, List<Lead>> mappedLeads2;
        try {
            mappedLeads2 = (Map<String, List<Lead>>)new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_ALL,
                new Set<MAP_OPTIONS>(),
                new Set<String>()
            );

        } catch(System.Exception exc) {
            exception_ToCheck = exc;
        }
        Test.stopTest();

        /**
         * Then
         * - No exceptions occurs
         * - the collection inside the map is accesible
         */
        System.assertEquals(NULL, exception_ToCheck);
        System.assertNotEquals(NULL, mappedLeads2);
        System.assertEquals(2, mappedLeads2.get(TESTCOMPANY_1_NAME).size());
        System.assertEquals(lead1.Id, mappedLeads2.get(TESTCOMPANY_1_NAME).get(0).Id);
        System.assertEquals(lead2.Id, mappedLeads2.get(TESTCOMPANY_1_NAME).get(1).Id);
    }

    @IsTest
    static void typeCast_ImplicitTypeCastOfRecordFails() {
        /**
         * Given
         * A list of leads to map
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
        Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1};

        /**
         * When
         * the result is casted implicitly from Object to Lead by casting the map
         */
        Test.startTest();
        System.Exception exceptionToCheck = NULL;
        try {
            Map<String, Lead> typecastedLeadMap = (Map<String, Lead>)new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_LAST,
                new Set<MAP_OPTIONS>(),
                new Set<String>()
            );

        } catch(System.Exception exc) {
            exceptionToCheck = exc;
        }
        Test.stopTest();

        /**
         * Then
         * casting the map fails
         */
        System.assertNotEquals(NULL, exceptionToCheck);
        System.assert(exceptionToCheck instanceOf System.TypeException);
        System.assertEquals('Invalid conversion from runtime type Map<String,SObject> to Map<String,Lead>', exceptionToCheck.getMessage());
    }

    @IsTest
    static void typeCast_SpecificTypeCastOfRecordSucceeds() {
        /**
         * Given
         * A list of leads to map
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
        Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1};

        /**
         * When
         * An entry of the map is casted by itself
         */
        Test.startTest();
        Lead leadToCheck;
        System.Exception exceptionToCheck = NULL;
        try {
            Map<String, Object> notTypecastedLeadMap = new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_LAST,
                new Set<MAP_OPTIONS>{MAP_OPTIONS.KEY_IGNORE_NULL},
                new Set<String>()
            );
            leadToCheck = (Lead)notTypecastedLeadMap.values().get(0);
        } catch (System.Exception exc) {
            exceptionToCheck = exc;
        }
        Test.stopTest();

        /**
         * Then
         * casting an entry succeeds
         */
        System.assertEquals(NULL, exceptionToCheck);
        System.assertNotEquals(NULL, leadToCheck);
        System.assertEquals(lead1.Id, leadToCheck.Id);
    }

    //----------------------------
    // Mapping Options
    //----------------------------

    @IsTest
    static void mapUtil_MapOptions_KEY_IGNORE_NULL() {
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        /**
        * Given
        * - two leads with a set Company field
        * - one lead without a value for Company
        */

        Lead lead1 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead3 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()));

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3};

        Test.startTest();
        /**©
         * When
         * the lead list is mapped with the option to ignore NULL as key
         */
        Map<String, Object> mappedLeads = new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new Set<MAP_OPTIONS>{MAP_OPTIONS.KEY_IGNORE_NULL},
            new Set<String>()
        );
        Test.stopTest();

        /**
         * Then
         * Only the two leads with a defined value are in the resulting map
         */
        System.assertEquals(2, mappedLeads.size(), 'Only two leads must be in resulting map');
        System.assert(mappedLeads.containsKey(TESTCOMPANY_1_NAME), 'A lead with defined company value must be inside the map');
        System.assert(mappedLeads.containsKey(TESTCOMPANY_2_NAME), 'A lead with defined company value must be inside the map');
    }

    @IsTest
    static void mapUtil_MapOptions_KEY_INCLUDE_ONLY() {
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        final String TESTCOMPANY_3_NAME = 'TestCompany3';
        final String TESTCOMPANY_4_NAME = 'TestCompany4';
        /**
        * Given
        * - five leads with a set Company field
        * - two of them having the same value
        */

        Lead lead1 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead3 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);
        Lead lead4 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_4_NAME);
        Lead lead5 = new Lead(Id = fflib_IDGenerator.generate(Lead.getSObjectType()), Company = TESTCOMPANY_4_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        Test.startTest();
        /**
         * When
         * the lead list is mapped with the option to contain only certain values
         */
        Set<String> keysForMapping = new Set<String>{TESTCOMPANY_2_NAME, TESTCOMPANY_4_NAME};
        Map<String, List<SObject>> mappedLeads = (Map<String, List<SObject>>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new Set<MAP_OPTIONS>{MAP_OPTIONS.KEY_INCLUDE_ONLY},
            keysForMapping
        );
        Test.stopTest();

        /**
         * Then
         * the resulting map contains only the defined keys
         */
        Boolean isSizeOfMapEqual = keysForMapping.size() == mappedLeads.size();
        Boolean isMapContainingAllKeysFromDefindedSet = mappedLeads.keySet().containsAll(keysForMapping);
        System.assert(isSizeOfMapEqual && isMapContainingAllKeysFromDefindedSet, 'Only the map contains only the keys defined by set');

        System.assertEquals(lead2.Id, mappedLeads.get(TESTCOMPANY_2_NAME)[0].Id);
        System.assertEquals(lead4.Id, mappedLeads.get(TESTCOMPANY_4_NAME)[0].Id);
        System.assertEquals(lead5.Id, mappedLeads.get(TESTCOMPANY_4_NAME)[1].Id);
    }
}
