public with sharing class MapUtility_MappingLogicFactory {

    public MapUtility_MappingLogicInterface getProduct(MAP_RETAIN_MODE retainingMode) {
        switch on retainingMode {
            when RETAIN_FIRST {
                return new MappingLogicSObjectRetainFirst();
            }
            when RETAIN_LAST {
                return new MappingLogicSObjectRetainLast();
            }
            when else {
                // only RETAIN_ALL is left
                return new MappingLogicSObjectRetainAll();
            }
        }
    }

    /**
     * this class contains the basic iteration logic for every object type
     */
    private abstract class ListInterationBase implements MapUtility_MappingLogicInterface {
        public Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet) {
            
            List<MapUtility_ValidKeyInterface> keyEvaluators = new List<MapUtility_ValidKeyInterface>();

            if(mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL)) {
                keyEvaluators.add(new MapUtility_ValidKeyImplementation.IgnoreKeyNull());
            }
            if(mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY)) {
                keyEvaluators.add(new MapUtility_ValidKeyImplementation.IncludeOnly(keySet));
            }

            Object result = this.createResultMap();
            for(Object tempSObject : objects) {
                Object key = valueReader.getValue(tempSObject);
                Boolean isAddItem = true;
                Iterator<MapUtility_ValidKeyInterface> evaluatorIterator = keyEvaluators.iterator();
                while (evaluatorIterator.hasNext() && isAddItem) {
                    MapUtility_ValidKeyInterface keyEvaluator = evaluatorIterator.next();
                    isAddItem &= keyEvaluator.isValidKey(key);
                }
                if(isAddItem) {
                    this.addItem(result, key, tempSObject);
                }
            }
            return result;
        }

        protected abstract Object createResultMap();
        protected abstract void addItem(Object resultMap, Object key, Object newItem);
    }

    /**
     * this class contains the logic for retaining all entries for a key
     */
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

    /**
     * this class contains the logic for retaining the first entry for a key
     */
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

    /**
     * this class contains the logic for retaining the last entry for a key
     */
    private class MappingLogicSObjectRetainLast extends ListInterationBase {
        protected override Object createResultMap() {
            return new Map<Object, Object>();
        }

        protected override void addItem(Object resultMap, Object key, Object newItem) {
            ((Map<Object, Object>)resultMap).put(key,newItem);
        }
    }
}
