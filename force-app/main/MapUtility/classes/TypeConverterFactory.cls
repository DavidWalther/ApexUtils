public with sharing virtual class TypeConverterFactory {
    public ITypeConverter getProduct(MAP_RETAIN_MODE retainingMode, Object objectsToMap) {
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

    private class ConvertMapObjectIntoMapOfObject implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            return tempMap;
        }
    }

    private class ConvertMapObjectIntoMapOfObjectLists implements ITypeConverter {
        public Map<String, Object> convertMappingResult(Map<String, Object> tempMap) {
            return (Map<String, List<Object>>)tempMap;
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