public with sharing class MapUtility_ItemEvalImplementations {

  //--------------------------------------------------------
  // MapUtility_MappingMain.IncludeItemInMapInterface
  //--------------------------------------------------------

  public class ItemEvaluatorIncludeAll implements MapUtility_MappingMain.IncludeItemInMapInterface {
    public Boolean isIncludeItem(Object itemToCheckForInclusion) {
      return true;
    }
  }
  
  //--------------------------------------------------------
  // MapUtility_MappingMain.MapUtility_ValidKeyInterface
  //--------------------------------------------------------

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
