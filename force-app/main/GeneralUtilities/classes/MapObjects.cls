public with sharing class MapObjects implements MapObjectsInterface{
    public Map<String, Object> mapObjectListByValueReaderResults(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
        return new MapUtility_MappingMain().generateMapFromObjectList(objects, valueReader, retainingMode, mapOptions, keySet);
    }
}
