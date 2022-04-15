public interface MapObjectsInterface {
    /**
     * @param objects A list of class instances to create a map for.
     * @param valueReader An instance of IValueReader. It is used to read the mapping key for each entry in 'objects'.
     * @param retainingMode the retaining mode to use RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL
     * @param mapOptions A Set of options to configure the map creation. Possible values are: KEY_IGNORE_NULL, KEY_INCLUDE_ONLY
     * @param keySet A Set of keys to exlude or to retain. The keys are compared via String.valueOf
     *
     * @return A map of all entries in objects mapped by the key returned by valueReader.getValue. The Structure of the values depend on the reaining option.
     */
    Map<String, Object> mapObjectListByValueReaderResults(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet);
}