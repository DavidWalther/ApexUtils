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

  }
}
