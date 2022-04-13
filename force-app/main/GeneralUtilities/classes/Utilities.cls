public class Utilities {
    //----------------------------
    // public properties
    //----------------------------
    public static IMappingUtility_SObjects mapping_SObject {get {return new MappingUtility_SObjects();} private set;}
    public static IMappingUtility_Objects mapping_Object {get {return new MappingUtility_Objects();} private set;}

    //----------------------------
    // public utility interfaces for quick overview of what can be accessed via properties
    //----------------------------

    public interface IMappingUtility_SObjects {
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

    public interface IMappingUtility_Objects {
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

    //----------------------------
    // actual implementation
    //----------------------------

    /**
     * This class contains utilities for the general SObject type.
     *
     * Note:
     * This class is intended to be stateless. If the necessity of storing data comes up,
     * store it in a static variable.
     */
    private class MappingUtility_SObjects implements IMappingUtility_SObjects {
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

    private class MappingUtility_Objects implements IMappingUtility_Objects {
        public Map<String, Object> mapObjectListByValueReaderResults(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
            return new MapUtility_MappingMain().generateMapFromObjectList(objects, valueReader, retainingMode, mapOptions, keySet);
        }
    } 
}