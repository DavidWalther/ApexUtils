public with sharing class MapUtility_MappingMain {
    public Map<Object, Object> generateMapFromObjectList(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
    
        //----------------------------
        // Guardians
        //----------------------------

        if(objects == NULL) throw new MapUtility_Exception('The list of objects to map must not be NULL.');
        if(valueReader == NULL) throw new MapUtility_Exception('An Instance of Utilities.IValueReader must be provided.');
        if(retainingMode == NULL) throw new MapUtility_Exception('The retaining mode must be provided.');
        if(mapOptions == NULL) throw new MapUtility_Exception('A set of mapOptions must be provided');
        if(keySet == NULL) throw new MapUtility_Exception('A set of keys to in-/exclude must be provided');

        //----------------------------
        // Business logic
        //----------------------------

        MapUtility_MappingLogicInterface mappingLogic = new MapUtility_MappingLogicFactory().getProduct(retainingMode);
        Map<Object, Object> tempMap = (Map<Object, Object>)mappingLogic
            .execute(objects, valueReader, mapOptions, keySet);

        MapUtility_TypeConverterInterface typeConverter = new MapUtility_TypeConverterFactory().getProduct(retainingMode, objects);
        return typeConverter.convertMappingResult(tempMap);
    }

    public Map<Object, Object> generateMapFromObjectList(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, List<MapUtility_ValidKeyInterface> keyEvaluators) {
    
        //----------------------------
        // Guardians
        //----------------------------

        if(objects == NULL) throw new MapUtility_Exception('The list of objects to map must not be NULL.');
        if(valueReader == NULL) throw new MapUtility_Exception('An Instance of Utilities.IValueReader must be provided.');
        if(retainingMode == NULL) throw new MapUtility_Exception('The retaining mode must be provided.');
        if(keyEvaluators == NULL) throw new MapUtility_Exception('A list of \'MapUtility_ValidKeyInterface\' must be provided.');

        //----------------------------
        // Business logic
        //----------------------------

        MapUtility_MappingLogicInterface mappingLogic = new MapUtility_MappingLogicFactory().getProduct(retainingMode);
        Map<Object, Object> tempMap = (Map<Object, Object>)mappingLogic
            .execute(objects, valueReader, keyEvaluators);

        MapUtility_TypeConverterInterface typeConverter = new MapUtility_TypeConverterFactory().getProduct(retainingMode, objects);
        return typeConverter.convertMappingResult(tempMap);
    }
}
