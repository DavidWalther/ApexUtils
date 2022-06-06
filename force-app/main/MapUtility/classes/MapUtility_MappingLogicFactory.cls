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

    private abstract class ListInterationBase implements MapUtility_MappingLogicInterface {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            Object result = this.createResultMap();
            for(Object tempSObject : objects) {
                Object key = valueReader.getValue(tempSObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(key)) {continue;}
                
                this.addItem(result, key, tempSObject);
            }
            return result;
        }

        protected abstract Object createResultMap();
        protected abstract void addItem(Object resultMap, Object key, Object newItem);
    }

    private class MappingLogicSObjectRetainAll extends ListInterationBase{

        protected override Object createResultMap() {
            return new Map<Object, List<Object>>();
        }

        protected override void addItem(Object resultMap, Object key, Object newItem) {
            List<Object> alreadyMappedObjects = ((Map<Object, List<Object>>)resultMap).get(key);
            if(alreadyMappedObjects == NULL) {
                alreadyMappedObjects = new List<Object>();
                ((Map<Object, Object>)resultMap).put(key, alreadyMappedObjects);
            }
            alreadyMappedObjects.add(newItem);
        }
    }

    private class MappingLogicSObjectRetainFirst implements MapUtility_MappingLogicInterface {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            Map<Object, Object> result = new Map<Object, Object>();
            for(Object tempObject : objects) {
                Object key = valueReader.getValue(tempObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(key)) {continue;}
                // only insert into map if key does not exist yet
                if(!result.containsKey(key)) {
                    result.put(key, tempObject);
                }
            }
            return result;
        }
    }

    private class MappingLogicSObjectRetainLast implements MapUtility_MappingLogicInterface {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            Map<Object, Object> result = new Map<Object, Object>();
            for(Object tempSObject : objects) {
                Object key = valueReader.getValue(tempSObject);
                if(isKeyIgnoreNull && key == NULL) {continue;}
                if(isKeyIncludeOnly && !keySet.contains(key)) {continue;}
                // insert into map no matter whether in object exist yet or not
                result.put(key, tempSObject);
            }
            return result;
        }
    }
}
