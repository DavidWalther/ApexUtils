public with sharing class MapUtility_MappingLogicFactory {

    public MapUtility_MappingLogicInterface getProduct(MAP_RETAIN_MODE retainingMode) {
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
                throw new MapUtility_Exception('Retaining option is not implemented yet.');
            }
        }
    }

    private class MappingLogicSObjectRetainAll implements MapUtility_MappingLogicInterface {
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

    private class MappingLogicSObjectRetainFirst implements MapUtility_MappingLogicInterface {
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

    private class MappingLogicSObjectRetainLast implements MapUtility_MappingLogicInterface {
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
}
