@IsTest
private without sharing class QueryCounterTest {

    @IsTest
    static void testCounterMapGetsInitialized() {
        /**
         * Given
         * -
         */

        Test.startTest();
        /**
         * When
         * A new instance is created
         */
        QueryCounter counter = new QueryCounter();
        Test.stopTest();
        
        /**
         * Then
         * The counter map is defined
         */
        System.assertNotEquals(NULL, counter.counter);
    }

    @IsTest
    static void testAddMethod(){
        /**
         * Given
         * An istance of the counter class
         */
        QueryCounter counter = new QueryCounter();
        System.Type classToTrack = QueryCounter.class;
        String methodName = 'Some method';

        Test.startTest();
        /**
         * When
         * The "add" method is called three times
         */
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        Test.stopTest();
        
        /**
         * Then
         * The counter stores a '3' for this method
         */
        System.assert(counter.counter.containsKey(classToTrack));
        System.assertEquals(1, counter.counter.size());
        System.assert(counter.counter.get(classToTrack).containsKey(methodName));
        System.assertEquals(1, counter.counter.get(classToTrack).size());
        System.assertEquals(3, counter.counter.get(classToTrack).get(methodName));
    }

    @IsTest
    static void toStringReturnsJson(){
        /**
         * Given
         * 1. An istance of the counter class
         * 2. A method call was logged three times
         */
        QueryCounter counter = new QueryCounter();
        System.Type classToTrack = QueryCounter.class;
        String methodName = 'Some method';
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        
        Test.startTest();
        /**
         * When
         * toString is called
         */
        String value_ToCheck = counter.toString();
        Test.stopTest();

        /**
         * Then
         * A JSON representation of the stored counter is returned
         */
        final String expectedJson = '{"QueryCounter":{"Some method":3}}';
        System.assertEquals(expectedJson, value_ToCheck);
    }

    @IsTest
    static void printPretty() {
        /**
         * Given
         * 1. An istance of the counter class
         * 2. A method call was logged three times
         */
        QueryCounter counter = new QueryCounter();
        System.Type classToTrack = QueryCounter.class;
        String methodName = 'Some method';
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        counter.add(classToTrack, methodName);
        
        Test.startTest();
        /**
         * When
         * printPretty is called
         */
        String value_ToCheck = counter.printPretty();
        Test.stopTest();


        /**
         * Then
         * A pretty version of JSON of the stored counter is returned
         */
        final String expectedJson = '{\n  "QueryCounter" : {\n    "Some method" : 3\n  }\n}';
        System.assertEquals(expectedJson, value_ToCheck);
    }
}
