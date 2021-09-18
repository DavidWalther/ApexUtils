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
      if(objectType == NULL) {
        return false;
      } else {
        return this.records.containsKey(objectType) && this.records.get(objectType) != NULL && !this.records.get(objectType).isEmpty();    
      }
    }
  
    /**
     * Returns the list of records for an object type.
     * 
     * @param objectType The Schema.SObjectType to check for.
     */
    protected virtual List<SObject> getObjectRecords(Schema.SObjectType objectType) {
      if(this.hasObjectRecords(objectType)) {
        return this.records.get(objectType);
      } else {
        return new List<SObject>();
      }
    }
    
    /**
     * Return the record with a specified id.
     * @param recordId
     */
    protected virtual SObject getRecord(Id recordId) {
      if(recordId == NULL) {
        return NULL;
      }
      Schema.SObjectType objectTypeFromId = recordId.getSObjectType();
      
      if(this.hasObjectRecords(objectTypeFromId)) {
        return this.records.get(objectTypeFromId).get(recordId);
      } else {
        return NULL;
      }
    }
  }