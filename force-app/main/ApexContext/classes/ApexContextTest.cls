@IsTest
private with sharing class ApexContextTest {

    @IsTest
    private static void stateStoresPrimitives() {
        ApexContext context = ApexContext.getInstance();

        Integer testInteger = 42;
        Boolean testBoolean = true;

        Integer testInteger_ToCheck = NULL;
        Boolean testBoolean_ToCheck = NULL;

        context.put('data-Int', testInteger);
        context.put('data-Boolean', testBoolean);

        testInteger_ToCheck = Integer.valueOf(context.get('data-Int'));
        testBoolean_ToCheck = Boolean.valueOf(context.get('data-Boolean'));

        System.assertEquals(testInteger, testInteger_ToCheck);
        System.assertEquals(testBoolean, testBoolean_ToCheck);
    }
 
    @IsTest
    private static void contextIsSingleton() {
        ApexContext context = ApexContext.getInstance();

        Integer testInteger = 42;
        
        Integer testInteger_ToCheck = NULL;

        context.put('data-Int', testInteger);

        ApexContext context_ToCheck = ApexContext.getInstance();
        testInteger_ToCheck = Integer.valueOf(context_ToCheck.get('data-Int'));

        System.assertEquals(testInteger, testInteger_ToCheck);
    }

    @IsTest
    private static void stateStoresStructuredTypes() {
        ApexContext context = ApexContext.getInstance();

        Map<String, Integer> storedMap = new Map<String, Integer>{'one'=>1,'two'=>2};

        Map<String, Integer> storedMap_ToCheck = NULL;

        context.put('data-Map', storedMap);

        storedMap_ToCheck = (Map<String, Integer>)(ApexContext.getInstance().get('data-Map'));

        System.assertNotEquals(NULL, storedMap_ToCheck);
        System.assertEquals(1, storedMap_ToCheck.get('one'));
        System.assertEquals(2, storedMap_ToCheck.get('two'));
    }
}
