public with sharing virtual class GenericRecordBuilder {
    public virtual class GenericRecordBuilder_Exception extends System.Exception{}

    private SObjectType sobjectType;
    private Map<Schema.SObjectField, Object> storedPrimitives = new Map<Schema.SObjectField, Object>();
    private Map<Schema.SObjectField, SObject> storedLookups = new Map<Schema.SObjectField, SObject>();
    private Map<Schema.ChildRelationship, List<SObject>> storedRelatedLists = new Map<Schema.ChildRelationship, List<SObject>>();

    public GenericRecordBuilder(SObjectType sobjectType) {
        if(sobjectType == NULL) throw new GenericRecordBuilder_Exception();
        this.sobjectType = sobjectType;
    }

    public GenericRecordBuilder setPrimitive(SObjectField fieldToken, Object value)
    {
        if(value instanceof SObject) throw new GenericRecordBuilder_Exception();
        this.storedPrimitives.put(fieldToken, value);
        return this;
    }

    public Object getPrimitive(SObjectField fieldToken)
    {
        return this.storedPrimitives.get(fieldToken);
    }

    public GenericRecordBuilder setLookup(SObjectField fieldToken, SObject value)
    {
        if(value == NULL)
        {
            this.storedPrimitives.put(fieldToken, NULL);
            this.storedLookups.remove(fieldToken);
        }
        else
        {
            this.storedPrimitives.put(fieldToken, value.Id);
            this.storedLookups.put(fieldToken, value);
        }
        return this;
    }

    public SObject getLookup(SObjectField fieldToken)
    {
        return this.storedLookups.get(fieldToken);
    }

    public GenericRecordBuilder addRelatedRecord(Schema.ChildRelationship listType, SObject relatedRecord)
    {
        List<SObject> records = storedRelatedLists.get(listType);
        if(records == NULL)
        {
            records = new List<SObject>();
            storedRelatedLists.put(listType,records);
        }
        records.add(relatedRecord);
        return this;
    }

    public List<SObject> getRelatedRecords(Schema.ChildRelationship listType)
    {
        return this.storedRelatedLists.get(listType);
    }

    /**
     * Note: Deepclone breaks referncial integrity of parents and child records.
     */
    public SObject getDeepClonedRecord()
    {
        SObject record = sobjectType.newSObject();

        Map<String, Object> recordMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(record));

        for(Schema.SObjectField fieldToken : this.storedPrimitives.keySet())
        {
            Schema.DescribeFieldResult dfr = fieldToken.getDescribe();
            String apiName = dfr.getName();
            recordMap.put(apiName, this.storedPrimitives.get(fieldToken));
        }

        for(Schema.SObjectField fieldToken : this.storedLookups.keySet())
        {
            Schema.DescribeFieldResult dfr = fieldToken.getDescribe();
            String apiReferenceName = dfr.getName();
            if(dfr.isCustom())
                apiReferenceName = apiReferenceName.replace('__c', '__r');
            else
                apiReferenceName = apiReferenceName.replace('Id', '');

            recordMap.put(dfr.getName(), this.storedPrimitives.get(fieldToken));

            recordMap.put(apiReferenceName, JSON.deserializeUntyped(JSON.serialize(this.storedLookups.get(fieldToken))));
        }

        for(Schema.ChildRelationship listType : storedRelatedLists.keySet())
        {
            List<SObject> childRecords = storedRelatedLists.get(listType);

            ChildRelationShip listClass = new ChildRelationShip();
            listClass.totalSize = childRecords.size();
            listClass.records.addAll(childRecords);

            String getRelationshipName = listType.getRelationshipName();
            recordMap.put(getRelationshipName, listClass);
        }

        Type t = Type.forName(this.sobjectType.getDescribe().getName());

        SObject result = (SObject)JSON.deserializeStrict(JSON.serialize(recordMap), t);
        return result;
    }

    private class ChildRelationShip
    {
        public Integer totalSize;
        public Boolean done = true;
        public List<SObject> records = new List<SObject>();
    }
}
