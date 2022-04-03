public class Utilities {
    //----------------------------
    // public properties
    //----------------------------
    public static IMappingUtility_SObjects mapping_SObject {get {return new MappingUtility_SObjects();} private set;}
    public static IMappingUtility_Objects mapping_Object {get {return new MappingUtility_Objects();} private set;}

    //----------------------------
    // public utility interfaces for quick overview of what can be accessed via properties
    //----------------------------

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

    public enum MAP_OPTIONS {KEY_IGNORE_NULL, KEY_INCLUDE_ONLY}

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

            if(SObjects == NULL) throw new MappingUtility_Exception('The list of objects to map must not be NULL.');
            if(valueReader == NULL) throw new MappingUtility_Exception('An Instance of Utilities.IValueReader must be provided.');
            if(retainingMode == NULL) throw new MappingUtility_Exception('The retaining mode must be provided.');
            if(mapOptions == NULL) throw new MappingUtility_Exception('A set of mapOptions must be provided');
            if(keySet == NULL) throw new MappingUtility_Exception('A set of keys to in-/exclude must be provided');

            //----------------------------
            // Business logic
            //----------------------------

            /**
             * direct casting from Object into result doesn't work here.
             * => createing new Collection of mapped entries
             */

            switch on retainingMode {
                when RETAIN_FIRST {
                    Map<String, Object> tempMap = (Map<String, Object>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(sObjects, valueReader, mapOptions, keySet); 
                    
                    return new ConvertMapObjectIntoMapOfSObject().convertMappingResult(tempMap);
                }
                when RETAIN_LAST {
                    Map<String, Object> tempMap = (Map<String, Object>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(sObjects, valueReader, mapOptions, keySet); 
                    
                    return new ConvertMapObjectIntoMapOfSObject().convertMappingResult(tempMap);
                }
                when RETAIN_ALL {
                    Map<String, List<Object>> tempMap = (Map<String, List<Object>>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(sObjects, valueReader, mapOptions, keySet); 
                    return new ConvertMapObjectIntoMapOfSObjectLists().convertMappingResult(tempMap);
                }
                when else {
                    throw new MappingUtility_Exception('Retaining option is not implemented yet.');
                }
            }
        }
    }
    
    private class MappingUtility_Objects implements IMappingUtility_Objects {
        public Map<String, Object> mapObjectListByValueReaderResults(List<Object> objects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
    
            //----------------------------
            // Guardians
            //----------------------------
    
            if(objects == NULL) throw new MappingUtility_Exception('The list of objects to map must not be NULL.');
            if(valueReader == NULL) throw new MappingUtility_Exception('An Instance of Utilities.IValueReader must be provided.');
            if(retainingMode == NULL) throw new MappingUtility_Exception('The retaining mode must be provided.');
            if(mapOptions == NULL) throw new MappingUtility_Exception('A set of mapOptions must be provided');
            if(keySet == NULL) throw new MappingUtility_Exception('A set of keys to in-/exclude must be provided');
    
            //----------------------------
            // Business logic
            //----------------------------
    
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);
    
            // Instead of checking the retainOption in every iteration we check only once
            switch on retainingMode {
                when RETAIN_FIRST {
                    Map<String, Object> tempMap = (Map<String, Object>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(objects, valueReader, mapOptions, keySet);
                    return new ConvertMapObjectIntoMapOfObject().convertMappingResult(tempMap);
                }
                when RETAIN_LAST {
                    Map<String, Object> tempMap = (Map<String, Object>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(objects, valueReader, mapOptions, keySet);
                    return new ConvertMapObjectIntoMapOfObject().convertMappingResult(tempMap);
                }
                when RETAIN_ALL {
                    Map<String, List<Object>> tempMap = (Map<String, List<Object>>)new MappingLogicFactory()
                        .getProduct(retainingMode)
                        .execute(objects, valueReader, mapOptions, keySet); 
                    return new ConvertMapObjectIntoMapOfObjectLists().convertMappingResult(tempMap);
                        
                }
                when else {
                    throw new MappingUtility_Exception('Retaining option is not implemented yet.');
                }
            }
        }
    }
    
    public class MappingUtility_Exception extends System.Exception{}

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

    //----------------------------
    // MappingLogicFactory
    //----------------------------

    public class MappingLogicFactory {
        public IMappingLogic getProduct(MAP_RETAIN_MODE retainingMode) {
            switch on retainingMode {
                when RETAIN_FIRST {
                    return new MappingLogicSObjectRetainFirst();
                }
                when RETAIN_LAST {
                    return new MappingLogicSObjectRetainLast();
                }
                when RETAIN_ALL {
                    return new MappingLogicSObjectRetainAll();
                }
                when else {
                    throw new MappingUtility_Exception('Retaining option is not implemented yet.');
                }
            }
        }
    }

    private interface IMappingLogic {
        Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<String> keySet);
    }

    private class MappingLogicSObjectRetainAll implements IMappingLogic {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            Map<String, List<Object>> result = new Map<String, List<Object>>();
            for(Object tempSObject : objects) {
                String key = valueReader.getValue(tempSObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                List<Object> alreadyMappedObjects = result.get(key);
                // check whether the List for the key already exists or not
                if(alreadyMappedObjects == NULL) {
                    alreadyMappedObjects = new List<Object>();
                    result.put(key, alreadyMappedObjects);
                }
                alreadyMappedObjects.add(tempSObject);
            }
            return result;
        }
    }

    private class MappingLogicSObjectRetainFirst implements IMappingLogic {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            Map<String, Object> result = new Map<String, Object>();
            for(Object tempObject : objects) {
                String key = valueReader.getValue(tempObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                // only insert into map if key does not exist yet
                if(!result.containsKey(key)) {
                    result.put(key, tempObject);
                }
            }
            return result;
        }
    }

    private class MappingLogicSObjectRetainLast implements IMappingLogic {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);
            
            Map<String, Object> result = new Map<String, Object>();
            for(Object tempSObject : objects) {
                String key = valueReader.getValue(tempSObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                // insert into map no matter whether in object exist yet or not
                result.put(key, tempSObject);
            }
            return result;
        }
    }

    //----------------------------
    // Result Map type converter
    //----------------------------
    
    private interface ITypeConverter {
        Map<String, Object> convertMappingResult(Map<String, Object> tempMap);
    }

    private class TypeConverterFactory {
        public ITypeConverter getProduct(MAP_RETAIN_MODE retainingMode, Object objectsToMap) {
            if(objectsToMap instanceOf List<SObject>) {
                switch on retainingMode {   
                    when RETAIN_FIRST {
                        return new ConvertMapObjectIntoMapOfSObject();
                    }
                    when RETAIN_LAST {
                        return new ConvertMapObjectIntoMapOfSObject();
                    }
                    when RETAIN_ALL {
                        return new ConvertMapObjectIntoMapOfSObjectLists();
                    }
                }
            }

            if(objectsToMap instanceOf List<Object>) {
                switch on retainingMode {   
                    when RETAIN_FIRST {
                        return new ConvertMapObjectIntoMapOfObject();
                    }
                    when RETAIN_LAST {
                        return new ConvertMapObjectIntoMapOfObject();
                    }
                    when RETAIN_ALL {
                        return new ConvertMapObjectIntoMapOfObjectLists();
                    }
                }
            }

            throw new MappingUtility_Exception();
        }
    }

    private class ConvertMapObjectIntoMapOfObject implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            return tempMap;
        }
    }

    private class ConvertMapObjectIntoMapOfObjectLists implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            Map<String, List<Object>> workingMap = (Map<String, List<Object>>)tempMap;
            return workingMap;
        }
    }

    private class ConvertMapObjectIntoMapOfSObject implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            Map<String, SObject> result = new Map<String, SObject>();
            for(String mapKey : tempMap.keySet()) {
                result.put(mapKey, (SObject)tempMap.get(mapKey));
            }
            return result;
        }
    }

    private class ConvertMapObjectIntoMapOfSObjectLists implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            Map<String, List<Object>> workingMap = (Map<String, List<Object>>)tempMap;
            
            Map<String, List<SObject>> result = new Map<String, List<SObject>>();
            for(String mapKey : workingMap.keySet()) {
                List<SObject> keyList = new List<SObject>();
                for(Object tmpObj : workingMap.get(mapKey)) {
                    keyList.add((SObject)tmpObj);
                }
                result.put(mapKey, keyList);
            }
            return result;
        }
    }
}