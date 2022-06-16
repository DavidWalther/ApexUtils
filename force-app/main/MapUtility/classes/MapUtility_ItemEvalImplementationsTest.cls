@IsTest
private with sharing class MapUtility_ItemEvalImplementationsTest {
  private static Set<Object> OBJECTS_OF_MIXED_TYPES {
    get { return new Set<Object>{
      2,5,7,9, // use interger values for valid keys
      'abc','ef',  // use strings as valid keys
      NULL, // use NULL as valid Key
      new Lead(LastName= 'testLead') // use a sObject as valid key;}}= 
    };}
    private set;}


  //--------------------------------------------------------
  // MapUtility_MappingMain.IncludeItemInMapInterface
  //--------------------------------------------------------

  @IsTest
  static void IncludeItem_AllRecords() {
    /**
     * Given
     * - A Set of items with mixed Types
     */
    Set<Object> validItems = OBJECTS_OF_MIXED_TYPES;

    Test.startTest();
    /**
     * When
     * - each item is checked and combined via AND the previous results
     */
    MapUtility_MappingMain.IncludeItemInMapInterface itemEvaluator
      = new MapUtility_ItemEvalImplementations.ItemEvaluatorIncludeAll();

    Boolean resultToCheck = true;
    for(Object itemToCheck : validItems) {
      resultToCheck &= itemEvaluator.isIncludeItem(itemToCheck);
    }
    Test.stopTest();

    /**
     * Then
     * 
     */
    System.assertEquals(true, resultToCheck, 'all items must return \'true\'.');
  }
  
  //--------------------------------------------------------
  // MapUtility_MappingMain.MapUtility_ValidKeyInterface
  //--------------------------------------------------------

  @IsTest
  static void mapOption_IgnoreNull() {
    MapUtility_MappingMain.MapUtility_ValidKeyInterface ignoreNullEvaluator = new MapUtility_ItemEvalImplementations.IgnoreKeyNull();
    
    System.assertEquals(true, ignoreNullEvaluator.isValidKey(Math.random()), 'evaluation any value but NULL must evaluate to \'true\'');
    System.assertEquals(false, ignoreNullEvaluator.isValidKey(NULL), 'NULL must evaluate to \'false\'');
  }

  @IsTest
  static void mapOption_IncludesOnly() {
    /**
     * Given
     * a set of valid keys with mixed types
     */
    Set<Object> validKeys = OBJECTS_OF_MIXED_TYPES;

    /**
     * When
     * the evaluator is created with the set of valid keys
     */
    MapUtility_MappingMain.MapUtility_ValidKeyInterface includeOnlyEvaluator = new MapUtility_ItemEvalImplementations.IncludeOnly(validKeys);

    /**
     * Then
     * values in the valid value set evaluate to 'true' else 'false'
     */
    for(Object validKey : validKeys) {
      System.assertEquals(true, includeOnlyEvaluator.isValidKey(validKey), 'all valid keys must evaluate to \'true\'');
    }

    System.assertEquals(false, includeOnlyEvaluator.isValidKey(3), '3 is not in set of valid keys and must evaluate to \'false\'');
    System.assertEquals(false, includeOnlyEvaluator.isValidKey('value'), '\'value\' is not in set of valid keys and must evaluate to \'false\'');
    
    System.assertEquals(true, includeOnlyEvaluator.isValidKey(new Lead(LastName= 'testLead')), 'A new sObject instance with the same field values must evaluate to \'true\'');
    System.assertEquals(false, includeOnlyEvaluator.isValidKey(new Lead(LastName= 'testLead', FirstName='Max')), 'A new sObject instance with different field values must evaluate to \'false\'');
  }
}
