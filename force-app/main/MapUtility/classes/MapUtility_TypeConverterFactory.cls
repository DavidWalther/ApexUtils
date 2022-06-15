public with sharing virtual class MapUtility_TypeConverterFactory {
    public MapUtility_MappingMain.MapUtility_TypeConverterInterface getProduct(MAP_RETAIN_MODE retainingMode, Object objectsToMap) {
        switch on retainingMode {
            when RETAIN_FIRST {
                if(objectsToMap instanceOf List<SObject>) {
                    return new ConvertMapObjectIntoMapOfSObject();
                }
                if(objectsToMap instanceOf List<Object>) {
                    return new ConvertMapObjectIntoMapOfObject();
                }
            }
            when RETAIN_LAST {
                if(objectsToMap instanceOf List<SObject>) {
                    return new ConvertMapObjectIntoMapOfSObject();
                }
                if(objectsToMap instanceOf List<Object>) {
                    return new ConvertMapObjectIntoMapOfObject();
                }
            }
            when RETAIN_ALL {
                if(objectsToMap instanceOf List<SObject>) {
                    return new ConvertMapObjectIntoMapOfSObjectLists();
                }
                if(objectsToMap instanceOf List<Object>) {
                    return new ConvertMapObjectIntoMapOfObjectLists();
                }
            }
        }

        throw new MapUtility_Exception('Unknown parameters for mapping');
    }

    private class ConvertMapObjectIntoMapOfObject implements MapUtility_MappingMain.MapUtility_TypeConverterInterface {
        public Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap) {
            return tempMap;
        }
    }

    private class ConvertMapObjectIntoMapOfObjectLists implements MapUtility_MappingMain.MapUtility_TypeConverterInterface {
        public Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap) {
            return (Map<Object, List<Object>>)tempMap;
        }
    }

    private class ConvertMapObjectIntoMapOfSObject implements MapUtility_MappingMain.MapUtility_TypeConverterInterface {
        public Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap) {
            Map<Object, SObject> result = new Map<Object, SObject>();
            for(Object mapKey : tempMap.keySet()) {
                result.put(mapKey, (SObject)tempMap.get(mapKey));
            }
            return result;
        }
    }

    private class ConvertMapObjectIntoMapOfSObjectLists implements MapUtility_MappingMain.MapUtility_TypeConverterInterface {
        public Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap) {
            Map<Object, List<Object>> workingMap = (Map<Object, List<Object>>)tempMap;
            Map<Object, List<SObject>> result = new Map<Object, List<SObject>>();

            for(Object mapKey : workingMap.keySet()) {
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