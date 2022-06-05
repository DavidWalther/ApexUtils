@IsTest
private with sharing class MapUtility_ValidKeyImplementationTest {

  @IsTest
  static void mapOption_IgnoreNull() {
    MapUtility_ValidKeyInterface ignoreNullEvaluator = new MapUtility_ValidKeyImplementation.IgnoreKeyNull();
    
    System.assertEquals(true, ignoreNullEvaluator.isValidKey(Math.random()), 'evaluation any value but NULL must evaluate to \'true\'');
    System.assertEquals(false, ignoreNullEvaluator.isValidKey(NULL), 'NULL must evaluate to \'false\'');
  }

  @IsTest
  static void mapOption_IncludesOnly() {
    Set<Object> validKeys = new Set<Object>{2,5,7,9, 'abc', NULL};
    MapUtility_ValidKeyInterface includeOnlyEvaluator = new MapUtility_ValidKeyImplementation.IncludeOnly(validKeys);
    
    for(Object validKey : validKeys) {
      System.assertEquals(true, includeOnlyEvaluator.isValidKey(validKey), 'all valid keys must evaluate to \'true\'');
    }

    System.assertEquals(false, includeOnlyEvaluator.isValidKey(3), '3 is not in set of valid keys and must evaluate to \'false\'');
    System.assertEquals(false, includeOnlyEvaluator.isValidKey('value'), '\'value\' is not in set of valid keys and must evaluate to \'false\'');
  }
}
