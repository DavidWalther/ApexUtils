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

    private class MappingLogicSObjectRetainFirst extends ListInterationBase {
        protected override Object createResultMap() {
            return new Map<Object, Object>();
        }

        protected override void addItem(Object resultMap, Object key, Object newItem) {
            if(!((Map<Object, Object>)resultMap).containsKey(key)) {
                ((Map<Object, Object>)resultMap).put(key,newItem);
            }
        }
    }

    private class MappingLogicSObjectRetainLast extends ListInterationBase {
        protected override Object createResultMap() {
            return new Map<Object, Object>();
        }

        protected override void addItem(Object resultMap, Object key, Object newItem) {
            ((Map<Object, Object>)resultMap).put(key,newItem);
        }
    }
}
