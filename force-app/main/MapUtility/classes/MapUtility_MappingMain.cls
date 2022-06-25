public with sharing class MapUtility_MappingMain {
    
    //----------------------------
    // Interfaces
    //----------------------------
    
    public interface IncludeItemInMapInterface {
        Boolean isIncludeItem(Object itemToCheckForInclusion);
    }

    public interface IncludeItemKeyInMapInterface {
        Boolean isIncludeItemKey(Object keyToEvaluate);
    }

    public interface MapUtility_MappingLogicInterface {
        Object execute(List<Object> objects, IValueReader valueReader, List<IncludeItemKeyInMapInterface> keyEvaluators, List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters);
    }

    /**
     * Objects can be casted into collecteions or Objects
     * BUT
     * A special logic is required to cast Objects into sObjects or Collections of sObjects.
     * 
     * This interface provides an abstraction
     */
    public interface MapUtility_TypeConverterInterface {
        Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap);
    }

    //----------------------------
    // Logic
    //----------------------------

    // Depricated
    public Map<Object, Object> generateMapFromObjectList(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
    
        //----------------------------
        // Guardians
        //----------------------------

        if(mapOptions == NULL) throw new MapUtility_Exception('A set of mapOptions must be provided');
        if(keySet == NULL) throw new MapUtility_Exception('A set of keys to in-/exclude must be provided');

        //----------------------------
        // Business logic
        //----------------------------
        List<IncludeItemKeyInMapInterface> keyEvaluators = this.createKeyEvaluatorsFromMapOptions(mapOptions, keySet);
        List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters = new List<MapUtility_MappingMain.IncludeItemInMapInterface>();
        return this.generateMapFromObjectList(objects, valueReader, retainingMode, keyEvaluators, itemFilters);
    }

    public Map<Object, Object> generateMapFromObjectList(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, List<IncludeItemKeyInMapInterface> keyEvaluators, List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters) {
    
        //----------------------------
        // Guardians
        //----------------------------

        if(objects == NULL) throw new MapUtility_Exception('The list of objects to map must not be NULL.');
        if(valueReader == NULL) throw new MapUtility_Exception('An instance of IValueReader must be provided.');
        if(retainingMode == NULL) throw new MapUtility_Exception('The retaining mode must be provided.');
        if(keyEvaluators == NULL) throw new MapUtility_Exception('A list of \'IncludeItemKeyInMapInterface\' must be provided.');

        //----------------------------
        // Business logic
        //----------------------------

        MapUtility_MappingLogicInterface mappingLogic = new MapUtility_MappingLogicFactory().getProduct(retainingMode);
        Map<Object, Object> tempMap = (Map<Object, Object>)mappingLogic
            .execute(objects, valueReader, keyEvaluators, itemFilters);

        MapUtility_MappingMain.MapUtility_TypeConverterInterface typeConverter = new MapUtility_TypeConverterFactory().getProduct(retainingMode, objects);
        return typeConverter.convertMappingResult(tempMap);
    }

    private List<IncludeItemKeyInMapInterface> createKeyEvaluatorsFromMapOptions(Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
        List<IncludeItemKeyInMapInterface> keyEvaluators = new List<IncludeItemKeyInMapInterface>();

        if(mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL)) {
            keyEvaluators.add(new MapUtility_ItemEvalImplementations.IgnoreKeyNull());
        }
        if(mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY)) {
            keyEvaluators.add(new MapUtility_ItemEvalImplementations.IncludeOnly(keySet));
        }

        return keyEvaluators;
    }
}
