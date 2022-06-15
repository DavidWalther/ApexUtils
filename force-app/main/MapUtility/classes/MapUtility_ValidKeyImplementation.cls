public with sharing class MapUtility_ValidKeyImplementation {
  
  public class IgnoreKeyNull implements MapUtility_MappingMain.MapUtility_ValidKeyInterface {
    public Boolean isValidKey(Object keyToEvaluate) {
      return keyToEvaluate != NULL;
    }
  }

  public class IncludeOnly implements MapUtility_MappingMain.MapUtility_ValidKeyInterface {
    private Set<Object> validKeys;
    public IncludeOnly(Set<Object> validKeys) {
      this.validKeys = validKeys;
    }

    public Boolean isValidKey(Object keyToEvaluate) {
      return this.validKeys.contains(keyToEvaluate);
    }
  }
}
