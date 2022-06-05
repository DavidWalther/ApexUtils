public with sharing class MapUtility_ValidKeyImplementation {
  
  public class IgnoreKeyNull implements MapUtility_ValidKeyInterface {
    public Boolean isValidKey(Object keyToEvaluate) {
      return NULL;
    }
  }
}
