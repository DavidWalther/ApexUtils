public with sharing class ApexContext {

//--------------------------------------
// Singleton implementation 
//--------------------------------------

    private static ApexContext instance = NULL;
    
    private ApexContext() {}

    public static ApexContext getInstance() {
        if(ApexContext.instance == NULL) {
            ApexContext.instance =  new ApexContext();
        }
        return ApexContext.instance;
    }

//--------------------------------------    
// DML - Operations
//--------------------------------------

    private List<SObject> objectsToInsert = new List<SObject>();
    private List<SObject> objectsToUpdate = new List<SObject>();
    private List<SObject> objectsToDelete = new List<SObject>();
    private List<SObject> objectsToUndelete = new List<SObject>();

    public void addObjectToInsert(SObject record) {
        this.runInsertGuardians(record);

        //Business logic
        this.objectsToInsert.add(record);
    }

    public void addObjectToUpdate(SObject record) {
        this.runUpdateGuardians(record);

        //Business logic
        this.objectsToUpdate.add(record);
    }

    public void addObjectToDelete(SObject record) {
        this.runDeleteGuardians(record);

        //Business logic
        this.objectsToDelete.add(record);
    }

    public void addObjectToUndelete(SObject record) {
        this.runUndeleteGuardians(record);

        //Business logic
        this.objectsToUndelete.add(record);
    }

    private void runInsertGuardians(SObject record) {
        if(record == NULL) {
            throw new System.InvalidParameterValueException('record', 'NULL');
        }
    }

    private void runUpdateGuardians(SObject record) {
        if(record == NULL) {
            throw new  System.InvalidParameterValueException('record', 'NULL');
        }
    }
    private void runDeleteGuardians(SObject record) {
        if(record == NULL) {
            throw new System.InvalidParameterValueException('record', 'NULL');
        }
    }

    private void runUndeleteGuardians(SObject record) {
        if(record == NULL) {
            throw new System.InvalidParameterValueException('record', 'NULL');
        }
    }

    public void commitToDatabase() {
        try {   
            if(!this.objectsToInsert.isEmpty()) {
                insert this.objectsToInsert;
            }
            if(!this.objectsToUpdate.isEmpty()) {
                update this.objectsToUpdate;
            }
            if(!this.objectsToDelete.isEmpty()) {
                delete this.objectsToDelete;
            }
            if(!this.objectsToUndelete.isEmpty()) {
                undelete this.objectsToUndelete;
            }      
        } catch(System.Exception exc) {
            throw exc;
        }
    }

//--------------------------------------    
// Data storage
//--------------------------------------

    private Map<String, Object> dataStorage = new Map<String, Object>();

    public void put(String key, Object value) {
        this.dataStorage.put(key, value);
    }

    public Object get(String key) {
        return this.dataStorage.get(key);
    }
}