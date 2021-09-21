public class Utilities {
    //----------------------------
    // public properties
    //----------------------------
    public static ISObjectUtilities sObjectsUtilities {get {return new SObjectUtilities();} private set;}

    //----------------------------
    // public utility interfaces for quick overview of what can be accessed via properties
    //----------------------------

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

    // TODO: add option for exclude keys.
    // TODO: what about including and excluding at the same time? extra parameter for secound set of keys or structured parameter?
    public enum MAP_OPTIONS {KEY_IGNORE_NULL, KEY_INCLUDE_ONLY}

    public interface IValueReader {
        String getValue(Object objectToGetValueFrom);
    }

    public interface ISObjectUtilities {
        Map<String, SObject> mapSObjectListByFieldValues(List<SObject> sObjects, SObjectField field);

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
    private class SObjectUtilities implements ISObjectUtilities {

        public Map<String, SObject> mapSObjectListByFieldValues(List<SObject> sObjects, SObjectField field) {
            return (Map<String, SObject>)this.mapSObjectListByValueReaderResults(sObjects, new FieldValueReader(field), MAP_RETAIN_MODE.RETAIN_LAST);
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, MAP_RETAIN_MODE.RETAIN_ALL, new Set<MAP_OPTIONS>(), new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, retainingMode, new Set<MAP_OPTIONS>(), new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, retainingMode, mapOptions, new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {

            //----------------------------
            // Guardians
            //----------------------------

            if(SObjects == NULL) throw new SObjectUtilities_Exception('The list of objects to map must not be NULL.');
            if(valueReader == NULL) throw new SObjectUtilities_Exception('An Instance of Utilities.IValueReader must be provided.');
            if(retainingMode == NULL) throw new SObjectUtilities_Exception('The retaining mode must be provided.');
            if(mapOptions == NULL) throw new SObjectUtilities_Exception('A set of mapOptions must be provided');
            if(keySet == NULL) throw new SObjectUtilities_Exception('A set of keys to in-/exclude must be provided');

            //----------------------------
            // Business logic
            //----------------------------

            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            // Instead of checking the retainOption in every iteration we check only once
            switch on retainingMode {
                when RETAIN_FIRST {
                    Map<String, SObject> result = new Map<String, SObject>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        // only insert into map if key does not exist yet
                        if(!result.containsKey(key)) {
                            result.put(key, tempSObject);
                        }
                    }
                    return result;
                }
                when RETAIN_LAST {
                    Map<String, SObject> result = new Map<String, SObject>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        // insert into map no matter whether in object exist yet or not
                        result.put(key, tempSObject);
                    }
                    return result;
                }
                when RETAIN_ALL {
                    Map<String, List<SObject>> result = new Map<String, List<SObject>>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        List<SObject> alreadyMappedObjects = result.get(key);
                        // check whether the List for the key already exists or not
                        if(alreadyMappedObjects == NULL) {
                            alreadyMappedObjects = new List<SObject>();
                            result.put(key, alreadyMappedObjects);
                        }
                        alreadyMappedObjects.add(tempSObject);
                    }
                    return result;
                }
                when else {
                    throw new SObjectUtilities_Exception('Retaining option is not implemented yet.');
                }
            }
        }
    }

    public class SObjectUtilities_Exception extends System.Exception{}

    public virtual class FieldValueReader implements IValueReader {
        private SObjectField field;
        public FieldValueReader(SObjectField field) {
            this.field = field;
        }
        public String getValue(Object objectToGetValueFrom) {
            SObject recordToRead = (SObject)objectToGetValueFrom;
            return String.valueOf(recordToRead.get(String.valueOf(field)));
        }
    }
}