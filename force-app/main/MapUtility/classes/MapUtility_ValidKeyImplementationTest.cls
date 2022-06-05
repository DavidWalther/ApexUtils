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
    Set<Object> validKeys = new Set<Object>{
      2,5,7,9, // use interger values for valid keys
      'abc','ef',  // use strings as valid keys
      NULL, // use NULL as valid Key
      new Lead(LastName= 'testLead') // use a sObject as valid key
    };
    MapUtility_ValidKeyInterface includeOnlyEvaluator = new MapUtility_ValidKeyImplementation.IncludeOnly(validKeys);
    
    for(Object validKey : validKeys) {
      System.assertEquals(true, includeOnlyEvaluator.isValidKey(validKey), 'all valid keys must evaluate to \'true\'');
    }

    System.assertEquals(false, includeOnlyEvaluator.isValidKey(3), '3 is not in set of valid keys and must evaluate to \'false\'');
    System.assertEquals(false, includeOnlyEvaluator.isValidKey('value'), '\'value\' is not in set of valid keys and must evaluate to \'false\'');
    
    System.assertEquals(true, includeOnlyEvaluator.isValidKey(new Lead(LastName= 'testLead')), 'A new sObject instance with the same field values must evaluate to \'true\'');
    System.assertEquals(false, includeOnlyEvaluator.isValidKey(new Lead(LastName= 'testLead', FirstName='Max')), 'A new sObject instance with different field values must evaluate to \'false\'');
  }
}
