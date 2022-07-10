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
}
