public with sharing class MapSobjects implements MapSobjectsInterface{
    public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader) {
        return new MapUtility_MappingMain().generateMapFromObjectList(sObjects, valueReader, MAP_RETAIN_MODE.RETAIN_ALL, new Set<MAP_OPTIONS>(), new Set<String>());
    }

    public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode) {
        return new MapUtility_MappingMain().generateMapFromObjectList(sObjects, valueReader, retainingMode, new Set<MAP_OPTIONS>(), new Set<String>());
    }

    public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions) {
        return new MapUtility_MappingMain().generateMapFromObjectList(sObjects, valueReader, retainingMode, mapOptions, new Set<String>());
    }

    public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
        return new MapUtility_MappingMain().generateMapFromObjectList(sObjects,valueReader, retainingMode, mapOptions, keySet);
    }
}