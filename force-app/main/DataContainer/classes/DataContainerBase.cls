public with sharing abstract class DataContainerBase {
    protected Map<Schema.SObjectType, Map<Id, SObject>> records = new Map<Schema.SObjectType, Map<Id, SObject>>();
  
    /**
     * Checks whether records of a certain type are stored.
     * 
     * @param objectType The Schema.SObjectType to check for.
     *
     * return true if there are records stored for the given type, else false
     */
    protected virtual Boolean hasObjectRecords(Schema.SObjectType objectType) {
      
      if(objectType == NULL) {return false;}
      
      Map<Id, SObject> mapForSObjectType = records.get(objectType);
       
      return mapForSObjectType != NULL ? mapForSObjectType.isEmpty() : false;
    }
  
    /**
     * Returns the list of records for an object type.
     * 
     * @param objectType The Schema.SObjectType to check for.
     */
    protected virtual List<SObject> getObjectRecords(Schema.SObjectType objectType) {
      if(objectType == NULL) {return NULL;} 
      
      return this.records.get(objectType)?.values();
    }
    
    /**
     * Return the record with a specified id.
     * @param recordId
     */
    protected virtual SObject getRecord(Id recordId) {
      if(recordId == NULL) {return NULL;}

      Schema.SObjectType objectTypeFromId = recordId.getSObjectType();
      
      return this.records.get(objectTypeFromId)?.get(recordId);
    }
  }