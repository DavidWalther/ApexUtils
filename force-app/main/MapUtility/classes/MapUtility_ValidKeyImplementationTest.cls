@IsTest
private with sharing class MapUtility_ValidKeyImplementationTest {

  @IsTest
  static void MappingKeyEvaluator_MapOption_IgnoreNull() {
    MapUtility_ValidKeyInterface ignoreNullEvaluator = new MapUtility_ValidKeyImplementation.IgnoreKeyNull();
  }

}
