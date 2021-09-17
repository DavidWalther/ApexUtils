public with sharing class QueryCounter {
    @TestVisible
    private Map<System.Type, Map<String, Integer>> counter;
    
    public QueryCounter() {
        this.counter = new Map<System.Type, Map<String, Integer>>();
    }

    public void add(System.Type selectorClass, String methodName) {
        Map<String, Integer> storedQueriesForClass = counter.get(selectorClass);
        if(storedQueriesForClass == NULL) {
            storedQueriesForClass = new Map<String, Integer>();
            counter.put(selectorClass, storedQueriesForClass);
        }
        Integer storedQueriesForMethod = storedQueriesForClass.get(methodName);
        if(storedQueriesForMethod == NULL) {
            storedQueriesForMethod = 0;
        }
        storedQueriesForClass.put(methodName, storedQueriesForMethod + 1);
    }

    public override String toString() {
        return JSON.serialize(this.counter);
    }

    public String printPretty() {
        return JSON.serializePretty(this.counter);
    }
}
