public with sharing class MapUtility_MappingLogicFactory {

    public MapUtility_MappingMain.MapUtility_MappingLogicInterface getProduct(MAP_RETAIN_MODE retainingMode) {
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
    private abstract class ListInterationBase implements MapUtility_MappingMain.MapUtility_MappingLogicInterface {
        protected abstract Object createResultMap();
        protected abstract void addItem(Object resultMap, Object key, Object newItem);
        
        public Object execute(List<Object> objects, IValueReader valueReader, List<MapUtility_MappingMain.IncludeItemKeyInMapInterface> keyEvaluators, List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters) {
            Object result = this.createResultMap();
            for(Object tempSObject : objects) {
                if(!this.isIncludeItem(itemFilters, tempSObject)) {
                    continue;
                }
                Object key = valueReader.getValue(tempSObject);
                Boolean isAddItem = this.isIncludeItemKey(keyEvaluators, key);

                if(isAddItem) {
                    this.addItem(result, key, tempSObject);
                }
            }
            return result;
        }

        private Boolean isIncludeItem(List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters, Object item) {
            Boolean isIncludeItem = true;
            Iterator<MapUtility_MappingMain.IncludeItemInMapInterface> evaluatorIterator = itemFilters.iterator();
            while (evaluatorIterator.hasNext() && isIncludeItem) {
                MapUtility_MappingMain.IncludeItemInMapInterface itemEvaluator = evaluatorIterator.next();
                isIncludeItem &= itemEvaluator.isIncludeItem(item);
            }
            return isIncludeItem;
        }

        private Boolean isIncludeItemKey(List<MapUtility_MappingMain.IncludeItemKeyInMapInterface> keyEvaluators, Object key) {
            Boolean isIncludeItemKey = true;
            Iterator<MapUtility_MappingMain.IncludeItemKeyInMapInterface> evaluatorIterator = keyEvaluators.iterator();
            while (evaluatorIterator.hasNext() && isIncludeItemKey) {
                MapUtility_MappingMain.IncludeItemKeyInMapInterface keyEvaluator = evaluatorIterator.next();
                isIncludeItemKey &= keyEvaluator.isIncludeItemKey(key);
            }
            return isIncludeItemKey;
        }
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
