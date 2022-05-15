public interface MapSobjectsInterface {
    /**
     * @param sObjects A list of SObjects to create a map for.
     * @param valueReader An instance of IValueReader. It is used to read the mapping key for each entry in 'sObjects'.
     * @param retainingMode the retaining mode to use RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL
     * @param mapOptions A Set of options to configure the map creation. Possible values are: KEY_IGNORE_NULL, KEY_INCLUDE_ONLY
     * @param keySet A Set of keys to exlude or to retain. The keys are compared via String.valueOf
     *
     * @return A Map of all entries in sObjects mapped by the key returned by valueReader.getValue. The Structure of the values depend on the reaining option.
     */
    Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet);
    // -- overloads --
    // keySet: {}
    Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions);
    // mapOptions: {}, keySet: {}
    Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode);
    // retainingMode: RETAIN_ALL, mapOptions: {}, keySet: {}
    Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader);
}
