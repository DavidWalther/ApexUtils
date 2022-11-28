@IsTest
public with sharing class MapUtility_MappingMainTest {

    private static Integer fakeIdCount = 0;
    private static final String ID_PATTERN = '000000000000';

    public static Id generateFakeId(Schema.SObjectType sobjectType)
    {
        String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
        fakeIdCount++;

        String fakeIdPrefix = ID_PATTERN.substring(0, 12 - fakeIdCount.format().length());

        return Id.valueOf(keyPrefix + fakeIdPrefix + fakeIdCount);
    }

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
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        Test.startTest();

        /**
        * When
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<Object, List<SObject>> mappedLeads = (Map<Object, List<SObject>>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);
        Lead lead6 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5, lead6};

        Test.startTest();

        /**
        * When
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<Object, SObject> mappedLeads = (Map<Object, SObject>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_FIRST,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);
        Lead lead6 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5, lead6};

        Test.startTest();

        /**
        * When
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<Object, SObject> mappedLeads = (Map<Object, SObject>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Map<Object, List<Object>> mappedLeads2 = (Map<Object, List<Object>>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Map<Object, Object> mappedLeads2 = (Map<Object, Object>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_FIRST,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Map<Object, Object> mappedLeads2 = (Map<Object, Object>)new MapUtility_MappingMain().generateMapFromObjectList(
            integerpairs,
            new ModValueReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2};

        /**
         * When
         * The result is a map containing a collection and is casted to a map of collection of specific
         */
        Test.startTest();
        System.Exception exception_ToCheck = NULL;
        Map<Object, List<Lead>> mappedLeads2;
        try {
            mappedLeads2 = (Map<Object, List<Lead>>)new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_ALL,
                new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
                new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1};

        /**
         * When
         * the result is casted implicitly from Object to Lead by casting the map
         */
        Test.startTest();
        System.Exception exceptionToCheck = NULL;
        try {
            Map<Object, Lead> typecastedLeadMap = (Map<Object, Lead>)new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_LAST,
                new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
                new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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
        System.assertEquals('Invalid conversion from runtime type Map<ANY,SObject> to Map<ANY,Lead>', exceptionToCheck.getMessage());
    }

    @IsTest
    static void typeCast_SpecificTypeCastOfRecordSucceeds() {
        /**
         * Given
         * A list of leads to map
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        Lead lead1 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);

        List<Lead> leadList = new List<Lead>{lead1};

        /**
         * When
         * An entry of the map is casted by itself
         */
        Test.startTest();
        Lead leadToCheck;
        System.Exception exceptionToCheck = NULL;
        try {
            Map<Object, Object> notTypecastedLeadMap = new MapUtility_MappingMain().generateMapFromObjectList(
                leadList,
                new LeadCompanyReader(),
                MAP_RETAIN_MODE.RETAIN_LAST,
                new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
                    new MapUtility_ItemEvalImplementations.IgnoreKeyNull()
                },
                new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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

        Lead lead1 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead3 = new Lead(Id = generateFakeId(Lead.getSObjectType()));

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3};

        Test.startTest();
        /**©
         * When
         * the lead list is mapped with the option to ignore NULL as key
         */
        Map<Object, Object> mappedLeads = new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_LAST,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
                new MapUtility_ItemEvalImplementations.IgnoreKeyNull()
            },
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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

        Lead lead1 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead3 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);
        Lead lead4 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_4_NAME);
        Lead lead5 = new Lead(Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_4_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        Test.startTest();
        /**
         * When
         * the lead list is mapped with the option to contain only certain values
         */
        Set<Object> keysForMapping = new Set<Object>{TESTCOMPANY_2_NAME, TESTCOMPANY_4_NAME};
        Map<Object, List<SObject>> mappedLeads = (Map<Object, List<SObject>>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
                new MapUtility_ItemEvalImplementations.IncludeOnly(keysForMapping)
            },
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
        );
        Test.stopTest();

        /**
         * Then
         * the resulting map contains only the defined keys
         */
        Boolean isSizeOfMapEqual = keysForMapping.size() == mappedLeads.size();
        Boolean isMapContainingAllKeysFromDefindedSet = mappedLeads.containsKey(TESTCOMPANY_2_NAME);
        isMapContainingAllKeysFromDefindedSet &= mappedLeads.containsKey(TESTCOMPANY_4_NAME);
        System.assert(isSizeOfMapEqual && isMapContainingAllKeysFromDefindedSet, 'Only the map contains only the keys defined by set');

        System.assertEquals(lead2.Id, mappedLeads.get(TESTCOMPANY_2_NAME)[0].Id);
        System.assertEquals(lead4.Id, mappedLeads.get(TESTCOMPANY_4_NAME)[0].Id);
        System.assertEquals(lead5.Id, mappedLeads.get(TESTCOMPANY_4_NAME)[1].Id);
    }


    //----------------------------
    // Tests with evaluator List
    //----------------------------

    @IsTest
    static void mapUtil_SObjects_Evaluators_RetainMode_RetainAll() {
        /**
         * Given
         * - A list of leads with filled company fields.
         * - Multiple leads have the same value
         */
        final String TESTCOMPANY_1_NAME = 'TestCompany1';
        final String TESTCOMPANY_2_NAME = 'TestCompany2';
        final String TESTCOMPANY_3_NAME = 'TestCompany3';

        Lead lead1 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead2 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_1_NAME);
        Lead lead3 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead4 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_2_NAME);
        Lead lead5 = new Lead(
        Id = generateFakeId(Lead.getSObjectType()), Company = TESTCOMPANY_3_NAME);

        List<Lead> leadList = new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        Test.startTest();

        /**
        * When
        * The map method of SObjectMappingUtility is called for the leadList and the company field
        */
        Map<Object, List<SObject>> mappedLeads = (Map<Object, List<SObject>>)new MapUtility_MappingMain().generateMapFromObjectList(
            leadList,
            new LeadCompanyReader(),
            MAP_RETAIN_MODE.RETAIN_ALL,
            new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
            new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
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

    //----------------------------
    // complex mapping szenario
    //----------------------------

    /**
     * - In this Szenario we'll map OpportunityLineItems by their Products's family field.
     * - we'll include only certain families
     * - Also we'll exclude all LineItems with a closed Opportunity
     */
    private static final String FAMILY_ONE = 'familiy one';
    private static final String FAMILY_TWO = 'familiy two';
    private static final String FAMILY_THREE = 'familiy three'; // will be excluded

    private static final String PRODUCT_NAME_ONE = 'Product 1';
    private static final String PRODUCT_NAME_TWO = 'Product 2';
    private static final String PRODUCT_NAME_THREE = 'Product 3';
    private static final String PRODUCT_NAME_FOUR = 'Product 4';

    private static final List<Id> OLI_IDS = new List<Id>{
        generateFakeId(OpportunityLineItem.getSObjectType()), // 'familiy one' => mapped
        generateFakeId(OpportunityLineItem.getSObjectType()), // 'familiy two' => mapped
        generateFakeId(OpportunityLineItem.getSObjectType()), // 'familiy two' => mapped
        generateFakeId(OpportunityLineItem.getSObjectType()), // 'familiy three' => excluded
        generateFakeId(OpportunityLineItem.getSObjectType()), // opportunity will be closed => excluded
        generateFakeId(OpportunityLineItem.getSObjectType())  // opportunity will be closed => excluded
    };

    /**
     * This method creates Data. The strukture is:

        Opportunity (CloseDate: Today +10)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_ONE, Family: FAMILY_ONE)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_TWO, Family: FAMILY_TWO)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_THREE, Family: FAMILY_TWO)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_FOUR, Family: FAMILY_THREE)

        Opportunity (CloseDate: Today -1)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_THREE, Family: FAMILY_TWO)
            OpportunityLineItem
                PricebookEntry
                    Product(Name: PRODUCT_NAME_FOUR, Family: FAMILY_THREE)
     */
    private static List<OpportunityLineItem> createOppurtunityLineItemsWithData() {
        // FAMILY_ONE
        PricebookEntry pbeOne = new PricebookEntry(
            Product2 = new Product2(
                Id = generateFakeId(Product2.getSObjectType()),
                Name = PRODUCT_NAME_ONE,
                Family = FAMILY_ONE
        ));

        // FAMILY_TWO
        PricebookEntry pbeTwo = new PricebookEntry(
            Product2 = new Product2(
                Id = generateFakeId(Product2.getSObjectType()),
                Name = PRODUCT_NAME_TWO,
                Family = FAMILY_TWO
        ));

        PricebookEntry pbeThree = new PricebookEntry(
            Product2 = new Product2(
                Id = generateFakeId(Product2.getSObjectType()),
                Name = PRODUCT_NAME_THREE,
                Family = FAMILY_TWO
        ));

        // FAMILY_THREE
        PricebookEntry pbeFour = new PricebookEntry(
            Product2 = new Product2(
                Id = generateFakeId(Product2.getSObjectType()),
                Name = PRODUCT_NAME_FOUR,
                Family = FAMILY_THREE
        ));

        Opportunity opportunityOpen = new Opportunity(
            Id = generateFakeId(Opportunity.getSObjectType()),
            CloseDate = Date.today().addDays(10)
        );

        Opportunity opportunityClosed = new Opportunity(
            Id = generateFakeId(Opportunity.getSObjectType()),
            CloseDate = Date.today().addDays(-1)
        );

        List<OpportunityLineItem> result = new List<OpportunityLineItem>{
            new OpportunityLineItem(Opportunity = opportunityOpen, PriceBookEntry = pbeOne, Id = OLI_IDS[0]),
            new OpportunityLineItem(Opportunity = opportunityOpen, PriceBookEntry = pbeTwo, Id = OLI_IDS[1]),
            new OpportunityLineItem(Opportunity = opportunityOpen, PriceBookEntry = pbeThree, Id = OLI_IDS[2]),
            new OpportunityLineItem(Opportunity = opportunityOpen, PriceBookEntry = pbeFour, Id = OLI_IDS[3]),
            new OpportunityLineItem(Opportunity = opportunityClosed, PriceBookEntry = pbeThree, Id = OLI_IDS[4]),
            new OpportunityLineItem(Opportunity = opportunityClosed, PriceBookEntry = pbeFour, Id = OLI_IDS[5])
        };

        return result;
    }

    //----------------------------
    // Variant 1
    // Use MapUtility_ItemEvalImplementations.IgnoreKeyNull and IValueReader.getValue to exclude Keys
    //----------------------------

    /**
     * This class will do two things:
     * 1. Read the LineItem's Products Family field
     * 2. Check the LineItem's Opportunity for having a CloseDate in the future
     */
    private class KeyReaderVariant1 implements IValueReader{
        public Object getValue(Object objectToGetValueFrom) {
            OpportunityLineItem oli = (OpportunityLineItem)objectToGetValueFrom;

            if(oli?.Opportunity?.CloseDate <= Date.Today()) {
                // returning NULL will result in oli not being mapped
                return NULL;
            }

            // this String might be NULL
            String productFamily = oli?.PriceBookEntry?.Product2?.Family;
            return productFamily;
        }
    }


    @IsTest
    private static void testComplexSzenarioVariant1() {
        /**
         * Given
         * Test data created by factory method
         */
        List<OpportunityLineItem> lineItemsToCreateMapFrom = createOppurtunityLineItemsWithData();

        List<MapUtility_MappingMain.IncludeItemKeyInMapInterface> keyFilters = new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
            new MapUtility_ItemEvalImplementations.IgnoreKeyNull(),
            new MapUtility_ItemEvalImplementations.IncludeOnly(new Set<Object>{FAMILY_ONE, FAMILY_TWO})
        };

        /**
         * When
         * the map utility is called
         */
        Map<Object, Object> mappedData = new MapUtility_MappingMain().generateMapFromObjectList(
            lineItemsToCreateMapFrom, new KeyReaderVariant1(), MAP_RETAIN_MODE.RETAIN_ALL, keyFilters, new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
        );

        /**
         * Then
         * data is mapped according to specs
         */
        System.assertEquals(2, mappedData.size());
        System.assert(mappedData.containsKey(FAMILY_ONE), 'Map must contain ' + FAMILY_ONE);
        System.assert(mappedData.containsKey(FAMILY_TWO), 'Map must contain ' + FAMILY_TWO);
        System.assert(!mappedData.containsKey(FAMILY_THREE), 'Map must not contain ' + FAMILY_THREE);

        System.assertEquals(1, ((List<Object>)mappedData.get(FAMILY_ONE)).size(), 'A single record was created for \'' + FAMILY_ONE + '\'. The mapping by family was not correct!');

        OpportunityLineItem testOli1 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_ONE)).get(0);
        System.assertEquals(OLI_IDS[0], testOli1.Id, 'The there was a different OpportunityLineItem mapped for this family');

        System.assertEquals(2, ((List<Object>)mappedData.get(FAMILY_TWO)).size(), 'Two records were created for \'' + FAMILY_TWO + '\'. The mapping by family was not correct!');
        OpportunityLineItem testOli2 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_TWO)).get(0);
        System.assertEquals(OLI_IDS[1], testOli2.Id, 'The there was a different OpportunityLineItem mapped for this family');

        OpportunityLineItem testOli3 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_TWO)).get(1);
        System.assertEquals(OLI_IDS[2], testOli3.Id, 'The there was a different OpportunityLineItem mapped for this family');
    }


    //----------------------------
    // Variant 2
    // Exclude items with MapUtility_MappingMain.IncludeItemInMapInterface
    //----------------------------

    /**
     * This class will read the LineItem's Products Family field
     */
    private class KeyReaderVariant2 implements IValueReader{
        public Object getValue(Object objectToGetValueFrom) {
            OpportunityLineItem oli = (OpportunityLineItem)objectToGetValueFrom;
            String productFamily = oli?.PriceBookEntry?.Product2?.Family;
            return productFamily;
        }
    }

    /**
     * This class will exclude LineItems of already closed Opportunites
     */
    private class IncludeOnlyLineItemsOfClosedOpportunities implements MapUtility_MappingMain.IncludeItemInMapInterface {
        public Boolean isIncludeItem(Object itemToCheckForInclusion) {
            if(itemToCheckForInclusion != NULL && itemToCheckForInclusion instanceOf OpportunityLineItem) {
                OpportunityLineItem oli = (OpportunityLineItem)itemToCheckForInclusion;
                return oli?.Opportunity?.CloseDate > Date.Today();
            }
            return false;
        }
    }

    @IsTest
    private static void testComplexSzenarioVariant2() {
        /**
         * Given
         * Test data created by factory method
         */
        List<OpportunityLineItem> lineItemsToCreateMapFrom = createOppurtunityLineItemsWithData();

        List<MapUtility_MappingMain.IncludeItemKeyInMapInterface> keyFilters = new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
            new MapUtility_ItemEvalImplementations.IncludeOnly(new Set<Object>{FAMILY_ONE, FAMILY_TWO})
        };

        List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters = new List<MapUtility_MappingMain.IncludeItemInMapInterface>{
            new IncludeOnlyLineItemsOfClosedOpportunities()
        };

        /**
         * When
         * the map utility is called
         */
        Map<Object, Object> mappedData = new MapUtility_MappingMain().generateMapFromObjectList(
            lineItemsToCreateMapFrom, new KeyReaderVariant2(), MAP_RETAIN_MODE.RETAIN_ALL, keyFilters, itemFilters
        );

        /**
         * Then
         * data is mapped according to specs
         */
        System.assertEquals(2, mappedData.size());
        System.assert(mappedData.containsKey(FAMILY_ONE), 'Map must contain ' + FAMILY_ONE);
        System.assert(mappedData.containsKey(FAMILY_TWO), 'Map must contain ' + FAMILY_TWO);
        System.assert(!mappedData.containsKey(FAMILY_THREE), 'Map must not contain ' + FAMILY_THREE);

        System.assertEquals(1, ((List<Object>)mappedData.get(FAMILY_ONE)).size(), 'A single record was created for \'' + FAMILY_ONE + '\'. The mapping by family was not correct!');

        OpportunityLineItem testOli1 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_ONE)).get(0);
        System.assertEquals(OLI_IDS[0], testOli1.Id, 'The there was a different OpportunityLineItem mapped for this family');

        System.assertEquals(2, ((List<Object>)mappedData.get(FAMILY_TWO)).size(), 'Two records were created for \'' + FAMILY_TWO + '\'. The mapping by family was not correct!');
        OpportunityLineItem testOli2 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_TWO)).get(0);
        System.assertEquals(OLI_IDS[1], testOli2.Id, 'The there was a different OpportunityLineItem mapped for this family');

        OpportunityLineItem testOli3 = (OpportunityLineItem)((List<Object>)mappedData.get(FAMILY_TWO)).get(1);
        System.assertEquals(OLI_IDS[2], testOli3.Id, 'The there was a different OpportunityLineItem mapped for this family');
    }

    //==============================
    // Multi-Level Mapping vs. key-class
    //==============================

    /**
     * Given:
     *   List of Opportunities with Accounts, LineItems, PricebookEntries and Products
     *
     * Task:
     *   Map Products by Account.BillingCountryCode, AccountId, and Product.Family
     *
     * Structure:
     *
     *   classic:
     *   EU
     *     AccountId1
     *       Product.Family1
     *         List<Product2>
     *       Product.Family2
     *         List<Product2>
     *     AccountId2
     *       Product.Family1
     *         List<Product2>
     *       Product.Family2
     *         List<Product2>
     *   GB
     *     AccountId2
     *       Product.Family1
     *         List<Product2>
     *       Product.Family2
     *         List<Product2>
     *     AccountId3
     *       Product.Family1
     *         List<Product2>
     *       Product.Family2
     *         List<Product2>
     *
     *   Structured Key:
     *     (EUR, AccountId1, Product.Family1)
     *       List<Product2>
     *     (EUR, AccountId1, Product.Family2)
     *       List<Product2>
     *     (EUR, AccountId2, Product.Family1)
     *       List<Product2>
     *     (EUR, AccountId2, Product.Family2)
     *       List<Product2>
     *
     *     (USD, AccountId2, Product.Family1)
     *       List<Product2>
     *     (USD, AccountId2, Product.Family2)
     *       List<Product2>
     *     (USD, AccountId3, Product.Family1)
     *       List<Product2>
     *     (USD, AccountId3, Product.Family2)
     *       List<Product2>
     */

    @IsTest
    static void structuredKey_creatorsAreSetUp() {
        Account dummyAcc1 = createAccount('Dummy Account 1', 'EU');

        Opportunity dummyOpp1 = createOpportunity('Dummy Opportunity 1', dummyAcc1);

        Product2 family1Product = createProduct(PRODUCT_NAME_ONE, 'Family1');

        PricebookEntry pbe = createPriceBookEntry(NULL, family1Product);

        OpportunityLineItem oli1 = createOpportunityLineItem(dummyOpp1, pbe);

        System.assertEquals(family1Product.Id, oli1.PricebookEntry.Product2.Id);
        System.assertEquals(dummyAcc1.Id, oli1.Opportunity.Account.Id);
    }

    @IsTest
    static void structuredKey_setUpSimpleTestStructure() {
      /*
        Given Simple structure

        dummyAcc1
          - 'EU'
          dummyOpp1
            oli1
              pbe1
            oli2
              pbe2
            oli3
              pbe3
          dummyOpp2
            oli4
              pbe1
            oli5
              pbe2
            oli6
              pbe3

        product1
          - PRODUCT_FAMILY1
          pbe1
        product2
          - PRODUCT_FAMILY1
          pbe2
        product3
          - PRODUCT_FAMILY1
          pbe3
        product4
          - PRODUCT_FAMILY2
          pbe4
      */

      final String PRODUCT_FAMILY1 = 'Family1';
      final String PRODUCT_FAMILY2 = 'Family2';
      Product2 product1 = createProduct(PRODUCT_NAME_ONE, PRODUCT_FAMILY1);
      Product2 product2 = createProduct(PRODUCT_NAME_TWO, PRODUCT_FAMILY1);
      Product2 product3 = createProduct(PRODUCT_NAME_THREE, PRODUCT_FAMILY1);
      Product2 product4 = createProduct(PRODUCT_NAME_THREE, PRODUCT_FAMILY2);

      Pricebook2 pricebook = new Pricebook2();
      PricebookEntry pbe1 = createPriceBookEntry(pricebook, product1);
      PricebookEntry pbe2 = createPriceBookEntry(pricebook, product2);
      PricebookEntry pbe3 = createPriceBookEntry(pricebook, product3);
      PricebookEntry pbe4 = createPriceBookEntry(pricebook, product4);

      Account dummyAcc1 = createAccount('Dummy Account 1', 'EU');

      Opportunity dummyOpp1 = createOpportunity('Dummy Opportunity 1', dummyAcc1);

      OpportunityLineItem oli1 = createOpportunityLineItem(dummyOpp1, pbe1);
      OpportunityLineItem oli2 = createOpportunityLineItem(dummyOpp1, pbe2);
      OpportunityLineItem oli3 = createOpportunityLineItem(dummyOpp1, pbe3);

      Opportunity dummyOpp2 = createOpportunity('Dummy Opportunity 2', dummyAcc1);

      OpportunityLineItem oli4 = createOpportunityLineItem(dummyOpp2, pbe1);
      OpportunityLineItem oli5 = createOpportunityLineItem(dummyOpp2, pbe2);
      OpportunityLineItem oli6 = createOpportunityLineItem(dummyOpp2, pbe4);

      Test.startTest();
      /**
       * Build Map
       */
      List<OpportunityLineItem> opportunityLineList = new List<OpportunityLineItem>{oli1, oli2, oli3, oli4, oli5, oli6};
      Map<Object, Object> mappedData = new MapUtility_MappingMain().generateMapFromObjectList(
        opportunityLineList,
        new OpportunityKeyReader(),
        MAP_RETAIN_MODE.RETAIN_ALL,
        new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(), // evaluates to 'true' if not provided
        new List<MapUtility_MappingMain.IncludeItemInMapInterface>() // evaluates to 'true' if not provided
      );
      Test.stopTest();

      /**
       * Check mapped data
       *
       *  Structure:
       *  (PRODUCT_FAMILY1, EU, dummyAcc1.Id)
       *    [oli1, oli2, oli3, oli4, oli5]
       *  (PRODUCT_FAMILY2, EU, dummyAcc1.Id)
       *    [oli6]
       */
      System.assertEquals(2, mappedData.size());

      // create artifical key to access map
      CountryAccountFamilyKey checkKey = new CountryAccountFamilyKey();
      checkKey.productFamily = PRODUCT_FAMILY1;
      checkKey.accountCountry = 'EU';
      checkKey.accountId = dummyAcc1.Id;

      List<OpportunityLineItem> lineItemsToCheck = (List<OpportunityLineItem>)mappedData.get(checkKey);

      System.assertEquals(oli1.Id, lineItemsToCheck.get(0).Id);
      System.assertEquals(oli2.Id, lineItemsToCheck.get(1).Id);
      System.assertEquals(oli3.Id, lineItemsToCheck.get(2).Id);
      System.assertEquals(oli4.Id, lineItemsToCheck.get(3).Id);
      System.assertEquals(oli5.Id, lineItemsToCheck.get(4).Id);
      System.assertEquals(5, lineItemsToCheck.size());

      // Change key to look for (value: Family)
      checkKey = new CountryAccountFamilyKey();
      checkKey.productFamily = PRODUCT_FAMILY2;
      checkKey.accountCountry = 'EU';
      checkKey.accountId = dummyAcc1.Id;

      lineItemsToCheck = (List<OpportunityLineItem>)mappedData.get(checkKey);
      System.assertEquals(oli6.Id, lineItemsToCheck.get(0).Id);
      System.assertEquals(1, lineItemsToCheck.size());
    }

    /**
     * all elements of the result are mapped by an instance of this class
     */
    private class CountryAccountFamilyKey {
      private String productFamily;
      private String accountCountry;
      private String accountId;

      public CountryAccountFamilyKey() {}

      public CountryAccountFamilyKey(OpportunityLineItem oli) {
        this.productFamily = oli.pricebookEntry.product2.Family;
        this.accountCountry = oli.Opportunity.Account.ShippingCountry;
        this.accountId = oli.Opportunity.Account.Id;
      }

      public Boolean equals(Object obj) {
        CountryAccountFamilyKey otherObject = (CountryAccountFamilyKey)obj;

        Boolean result = true;
        result &= this.productFamily == otherObject.productFamily;
        result &= this.accountCountry == otherObject.accountCountry;
        result &= this.accountId == otherObject.accountId;
        return result;
      }

      public Integer hashCode() {
        return (this.productFamily.hashCode() + this.accountCountry.hashCode() + this.accountId.hashCode());
      }
    }

    /**
     * This class generates a structured Key for each OpportunityLineItem
     */
    private class OpportunityKeyReader implements IValueReader {
      public Object getValue(Object objectToGetValueFrom) {
        OpportunityLineItem oli = (OpportunityLineItem)objectToGetValueFrom;
        CountryAccountFamilyKey result = new CountryAccountFamilyKey(oli);
        return result;
      }
    }

    private class IncludeOpportunityEvaluator implements MapUtility_MappingMain.IncludeItemInMapInterface {
      public Boolean isIncludeItem(Object keyToEvaluate) {
        return false;
      }
    }

    public class IncludeOpportunityKey implements MapUtility_MappingMain.IncludeItemKeyInMapInterface {
      public Boolean isIncludeItemKey(Object keyToEvaluate) {
        return false;
      }
    }

    private static Account createAccount(String accountName, String countryCode) {
      Account result = new Account(
        Id = generateFakeId(Account.getSObjectType()),
        Name = accountName,
        ShippingCountry = countryCode
      );
      return result;
    }

  private static Product2 createProduct(String productName, String productFamily) {
    Product2 result = new Product2(
      Id = generateFakeId(Product2.getSObjectType()),
      Name = productName,
      Family = productFamily
    );
    return result;
  }

  private static Opportunity createOpportunity(String opportunityName, Account opportunityAccount) {
    Opportunity result = new Opportunity(
      Id = generateFakeId(Opportunity.getSObjectType()),
      AccountId = opportunityAccount?.Id,
      Account = opportunityAccount,
      Name = opportunityName
    );
    return result;
  }

  private static PricebookEntry createPriceBookEntry(Pricebook2 pricebook, Product2 product) {
    PricebookEntry result = new PricebookEntry(
      Id = generateFakeId(PricebookEntry.getSObjectType()),
      Pricebook2Id = pricebook?.Id,
      Pricebook2 = pricebook,

      Product2Id = product?.Id,
      Product2 = product
    );
    return result;
  }

  private static OpportunityLineItem createOpportunityLineItem(Opportunity opportunity, PricebookEntry pricebookEntry) {
    OpportunityLineItem result = new OpportunityLineItem(
        Id = generateFakeId(OpportunityLineItem.getSObjectType()),
        OpportunityId = opportunity.Id,
        Opportunity = opportunity,
        PricebookEntryId = pricebookEntry?.Id,
        PricebookEntry = pricebookEntry
      );
    return result;
  }
}