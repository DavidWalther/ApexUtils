public with sharing class MapUtility_ItemEvalImplementations {

  //--------------------------------------------------------
  // MapUtility_MappingMain.IncludeItemInMapInterface
  //--------------------------------------------------------

  //--------------------------------------------------------
  // MapUtility_MappingMain.IncludeItemKeyInMapInterface
  //--------------------------------------------------------

  public class IgnoreKeyNull implements MapUtility_MappingMain.IncludeItemKeyInMapInterface {
    public Boolean isIncludeItemKey(Object keyToEvaluate) {
      return keyToEvaluate != NULL;
    }
  }

  public class IncludeOnly implements MapUtility_MappingMain.IncludeItemKeyInMapInterface {
    private Set<Object> validKeys;
    public IncludeOnly(Set<Object> validKeys) {
      this.validKeys = validKeys;
    }

    public Boolean isIncludeItemKey(Object keyToEvaluate) {
      return this.validKeys.contains(keyToEvaluate);
    }
  }
}
