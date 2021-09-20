public class Utilities {
    //----------------------------
    // public properties
    //----------------------------
    public static ISObjectUtilities sObjectsUtilities {get {return new SObjectUtilities();} private set;}

    //----------------------------
    // public utility interfaces for quick overview of what can be accessed via properties
    //----------------------------

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

    // TODO: add option for exclude keys.
    // TODO: what about including and excluding at the same time? extra parameter for secound set of keys or structured parameter?
    public enum MAP_OPTIONS {KEY_IGNORE_NULL, KEY_INCLUDE_ONLY}

    public interface IValueReader {
        String getValue(SObject objectToGetValueFrom);
    }

    public interface ISObjectUtilities {
        Set<String> getStringValues(List<SObject> sObjects, SObjectField field);
        Map<String, SObject> mapSObjectListByFieldValues(List<SObject> sObjects, SObjectField field);

        /**
         * @param sObjects A list of SObjects to create a map for.
         * @param valueReader An instance of IValueReader. It is used to read the mapping key for each entry in 'sObjects'.
         * @param retainingMode the retaining mode to use RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL
         * @param mapOptions A Set of options to configure the map creation. Possible values are: KEY_IGNORE_NULL, KEY_INCLUDE_ONLY
         * @param keySet A Set of keys to exlude or to retain. The keys are compared via String.valueOf
         *
         * @return A Map of all entries in sObjects mapped by the key returned by valueReader.getValue. The Structure of the values depend on the reaining option.
         */
        Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet);
        // -- overloads --
        // keySet: {}
        Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions);
        // mapOptions: {}, keySet: {}
        Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode);
        // retainingMode: RETAIN_ALL, mapOptions: {}, keySet: {}
        Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader);
    }

    //----------------------------
    // actual implementation
    //----------------------------

    /**
     * This class contains utilities for the general SObject type.
     *
     * Note:
     * This class is intended to be stateless. If the necessity of storing data comes up,
     * store it in a static variable.
     */
    private class SObjectUtilities implements ISObjectUtilities {
        public Set<String> getStringValues(List<SObject> sObjects, SObjectField field) {
            // TODO: use mapSObjectListByFieldValues.keyset()
            return Utilities.getStringValues(sObjects, field);
        }

        public Map<String, SObject> mapSObjectListByFieldValues(List<SObject> sObjects, SObjectField field) {
            return (Map<String, SObject>)this.mapSObjectListByValueReaderResults(sObjects, new FieldValueReader(field), MAP_RETAIN_MODE.RETAIN_LAST);
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, MAP_RETAIN_MODE.RETAIN_ALL, new Set<MAP_OPTIONS>(), new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, retainingMode, new Set<MAP_OPTIONS>(), new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions) {
            return this.mapSObjectListByValueReaderResults(sObjects, valueReader, retainingMode, mapOptions, new Set<String>());
        }

        public Map<String, Object> mapSObjectListByValueReaderResults(List<SObject> sObjects, IValueReader valueReader, MAP_RETAIN_MODE retainingMode, Set<MAP_OPTIONS> mapOptions, Set<String> keySet) {

            //----------------------------
            // Guardians
            //----------------------------

            if(SObjects == NULL) throw new SObjectUtilities_Exception('The list of objects to map must not be NULL.');
            if(valueReader == NULL) throw new SObjectUtilities_Exception('An Instance of Utilities.IValueReader must be provided.');
            if(retainingMode == NULL) throw new SObjectUtilities_Exception('The retaining mode must be provided.');
            if(mapOptions == NULL) throw new SObjectUtilities_Exception('A set of mapOptions must be provided');
            if(keySet == NULL) throw new SObjectUtilities_Exception('A set of keys to in-/exclude must be provided');

            //----------------------------
            // Business logic
            //----------------------------

            Boolean isKeyIgnoreNull = mapOptions.contains(MAP_OPTIONS.KEY_IGNORE_NULL);
            Boolean isKeyIncludeOnly = mapOptions.contains(MAP_OPTIONS.KEY_INCLUDE_ONLY);

            // Instead of checking the retainOption in every iteration we check only once
            switch on retainingMode {
                when RETAIN_FIRST {
                    Map<String, SObject> result = new Map<String, SObject>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        // only insert into map if key does not exist yet
                        if(!result.containsKey(key)) {
                            result.put(key, tempSObject);
                        }
                    }
                    return result;
                }
                when RETAIN_LAST {
                    Map<String, SObject> result = new Map<String, SObject>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        // insert into map no matter whether in object exist yet or not
                        result.put(key, tempSObject);
                    }
                    return result;
                }
                when RETAIN_ALL {
                    Map<String, List<SObject>> result = new Map<String, List<SObject>>();
                    for(SObject tempSObject : sObjects) {
                        String key = valueReader.getValue(tempSObject);
                        if(isKeyIgnoreNull && key == NULL) {continue;}
                        if(isKeyIncludeOnly && !keySet.contains(String.valueOf(key))) {continue;}
                        List<SObject> alreadyMappedObjects = result.get(key);
                        // check whether the List for the key already exists or not
                        if(alreadyMappedObjects == NULL) {
                            alreadyMappedObjects = new List<SObject>();
                            result.put(key, alreadyMappedObjects);
                        }
                        alreadyMappedObjects.add(tempSObject);
                    }
                    return result;
                }
                when else {
                    throw new SObjectUtilities_Exception('Retaining option is not implemented yet.');
                }
            }
        }
    }

    public class SObjectUtilities_Exception extends System.Exception{}

    public virtual class FieldValueReader implements IValueReader {
        private SObjectField field;
        public FieldValueReader(SObjectField field) {
            this.field = field;
        }
        public String getValue(SObject objectToGetValueFrom) {
            return String.valueOf(objectToGetValueFrom.get(String.valueOf(field)));
        }
    }

    //----------------------------
    // statics
    //----------------------------

    private static VI_Service_ErrorLog errorService = new VI_Service_ErrorLog();
    private static Map<String,Id> queueNameToIdMap = new Map<String,Id>();
    private static final String base64Chars = '' +
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
            'abcdefghijklmnopqrstuvwxyz' +
            '0123456789+/';

    public static Id getRecordTypeId(String sObjectName, String developerName) {
        return Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();
    }

    public static String getRecordTypeName(String sObjectName, Id recordTypeId) {
        return Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
    }

    public static Map<String, Id> getRecordTypeIdMap(String sObjectName){

        // String (DeveloperName) , Id (RecordTypeId)
        Map<String, Id> recordTypeIdMap = new Map<String,Id>();
        List<Schema.RecordTypeInfo> recordTypeInfoList = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfos();

        if (recordTypeInfoList != null && !recordTypeInfoList.isEmpty()){
            for (Schema.RecordTypeInfo recordTypeInfo: recordTypeInfoList) {
                recordTypeIdMap.put(recordTypeInfo.getDeveloperName(), recordTypeInfo.getRecordTypeId());
            }
        }
        return recordTypeIdMap;
    }

    public static Map<Id, String> getRecordTypeNameMap(String sObjectName){

        // String (DeveloperName) , Id (RecordTypeId)
        Map<Id, String> recordTypeNameMap = new Map<Id, String>();
        List<Schema.RecordTypeInfo> recordTypeInfoList = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfos();

        if (recordTypeInfoList != null && !recordTypeInfoList.isEmpty()){
            for (Schema.RecordTypeInfo recordTypeInfo: recordTypeInfoList) {
                recordTypeNameMap.put(recordTypeInfo.getRecordTypeId(), recordTypeInfo.getDeveloperName());
            }
        }
        return recordTypeNameMap;
    }

    public static Group getGroupId(String groupType, String groupDeveloperName) {
        return [
            SELECT
                Id,
                Name
            FROM
                Group
            WHERE
            Type = :groupType
            AND
            DeveloperName = :groupDeveloperName
            LIMIT 1
        ];
    }

    public static Map<String,Id> getQueueNameIdMap() {

        // Returns a map of all existing queues as a map of DeveloperName --> Id
        Map<String, Id> queueNameIdMap = new Map<String, Id>();

        List<Group> queues = [
                SELECT
                        Id,
                        DeveloperName
                FROM
                        Group
                WHERE
                        Type = 'Queue'
        ];

        for (Group queue : queues) {
            queueNameIdMap.put(queue.DeveloperName, queue.Id);
        }

        return queueNameIdMap;
    }

    public static List<GroupMember> getGroupMembers(Id groupId) {
        List<GroupMember> groupMembers = new List<GroupMember>([
            SELECT
                UserOrGroupId,
                GroupId
            FROM
                GroupMember
            WHERE
                GroupId =: groupId
        ]);
        return groupMembers;
    }

    public static List<String> splitClean(String stringToSplit, String regex) {
        // 1. split
        List<String> splitParts = stringToSplit.split(regex);

        // 2. trim
        List<String> trimmedParts = new List<String>();
        for (String part : splitParts) {
            trimmedParts.add(part.trim());
        }

        // 3. remove empty
        List<String> result = new List<String>();
        for (String part : trimmedParts) {
            if (String.isNotBlank(part)) {
                result.add(part);
            }
        }

        // return it like a real pro!
        return result;
    }

    public static Map<String,OrgWideAddressConfiguration__c> getMapOfOrgWideAddresses () {

        return OrgWideAddressConfiguration__c.getAll();
    }

    public static String getQueueIdBySalesOffice (String salesOrg, String salesOffice) {

        if (Test.isRunningTest()) salesOffice = salesOffice+'_Test';

        if (queueNameToIdMap.isEmpty()) {
            List<Group> queues = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue'];
            for (Group queue : queues) {
                if (queue.DeveloperName == 'BackOffice_'+salesOrg+'_'+salesOffice) {
                    queueNameToIdMap.put(queue.DeveloperName,queue.Id);
                }
            }
        }
        if (!queueNameToIdMap.isEmpty() && queueNameToIdMap.containsKey('BackOffice_'+salesOrg+'_'+salesOffice)) {
            return queueNameToIdMap.get('BackOffice_'+salesOrg+'_'+salesOffice);
        }
        return null;
    }

    public static void wait(Integer millisec) {
        if (millisec == null || millisec < 0) {
            millisec = 0;
        }
        final Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < millisec) {
            //sleep for parameter x millisecs
            finishTime = DateTime.now().getTime();
        }
    }

    public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        return guid;
    }

    public static String getSessionIdFromVFPage() {

        String sessionId = '';
        String content = '';

        try {
            if (!Test.isRunningTest()) {
                content = Page.GetSessionId.getContent().toString();
            } else {
                content = '{"sessionId": "sessionId"}';
            }

            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(content);

            if (root.containsKey('sessionId')) {
                sessionId = (String) root.get('sessionId');
            }
        } catch(Exception ex){
            System.debug('Error getSessionIdFromVFPage: ' + ex);
        }

        return sessionId;
    }

    /*
	*	Method allows to get all the Id from related parent objects.
	*/
	public static Set<Id> getRelatedParentField (List<sObject> theNewValues, Map<Id, sObject> theOldValues, String theFieldName)
	{
		Set<Id> aResult = new Set<Id>();
		for (sObject aChild: (theNewValues == null ? theOldValues.values() : theNewValues))
		{
			String aValue = (String) aChild.get(theFieldName);
			if (aValue != null)
			{
				aResult.add(aValue);
			}
			sObject anOldChild = theOldValues == null ? null : theOldValues.get(aChild.Id);
			aValue = anOldChild == null ? null : (String) anOldChild.get(theFieldName);
			if(anOldChild != null)
			{
				if (aValue != null)
				{
					aResult.add(aValue);
				}
			}
		}
		return aResult;
	}

    /*
	*	@description Get Id set of modified object by defined list of fields and certain record types.
	*/
	public static Set<sObject> getModifiedObjects (Set<String> fieldsList, List<sObject> newList, Map<Id, sObject> oldMap, Set<Id> recordTypes)
	{
        if(newList == null)
        {
            return new Set<sObject>();
        }
		Set<sObject> result = new Set<sObject>();
		for (sObject obj: newList)
		{
			if (oldMap == null)
	        {
				if(	recordTypes != null && !recordTypes.isEmpty() &&
					recordTypes.contains((Id)obj.get('RecordTypeId')))
				{
					result.add(obj);
                }
			}
			else
			{
                sObject oldObj = oldMap.get(obj.Id);
				for (String aField: fieldsList)
				{
					if(recordTypes != null && !recordTypes.isEmpty())
					{
						if (recordTypes.contains((Id)obj.get('RecordTypeId')) && obj.get(aField) != oldObj.get(aField))
						{
							result.add(obj);
						}
					}
					else if (obj.get(aField) != oldObj.get(aField))
					{
						result.add(obj);
					}
				}
			}
		}
		return result;
    }

    /**
     * @return true if function is only running in user context (no technical trigger context)
     */
    public static Boolean isNotAsynchronousExecution(){
        return !System.isBatch() && !System.isQueueable() && !System.isFuture();
    }

    public static Map<String, List<PicklistEntryWrapper>> loadPicklistValuesByRecordTypeName(String objectName, String recordTypeName) {

        String sessionId = getSessionIdFromVFPage();

        Map<String, List<PicklistEntryWrapper>> pickListMap = new Map<String, List<PicklistEntryWrapper>>();

        if (objectName == null || recordTypeName == null) {
            return pickListMap;
        }

        try{

            //request User Interface API
            String recordTypeId = Utilities.getRecordTypeId(objectName, recordTypeName);
            String endpoint = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v48.0/ui-api/object-info/' + objectName + '/picklist-values/' + recordTypeId;
            String body = '';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('Authorization', 'Bearer ' + sessionId);
            req.setMethod('GET');

            Http h = new Http();
            HttpResponse res = h.send(req);
            body = res.getBody();
            if(res.getStatusCode() == 200){

                //Parse JSON response
                Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(body);

                if(root.containsKey('picklistFieldValues')){
                    Map<String,Object>  picklistFields = (Map<String,Object>)root.get('picklistFieldValues');

                    for(String picklistField : picklistFields.keySet()){
                        Map<String,Object> picklistFieldRoot = (Map<String,Object>) picklistFields.get(picklistField);
                        Map<Integer,String> controllerValueMap = null;
                        String picklistDefaultValue = null;

                        if (picklistFieldRoot.containsKey('defaultValue')){
                            Object defaultValue = picklistFieldRoot.get('defaultValue');

                            if (defaultValue != null) {
                                picklistDefaultValue = (String)((Map<String,Object>)defaultValue).get('value');
                            }

                        }

                        if (picklistFieldRoot.containsKey('controllerValues')){
                            Map<String,Object> controllerValues = (Map<String,Object>)picklistFieldRoot.get('controllerValues');

                            if (controllerValues != null && !controllerValues.isEmpty()) {
                                controllerValueMap = new Map<Integer,String>();

                                for (String controllerValue : controllerValues.keySet()) {
                                    controllerValueMap.put((Integer)controllerValues.get(controllerValue), controllerValue);
                                }
                            }

                        }

                        if(picklistFieldRoot.containsKey('values')){

                            List<PicklistEntryWrapper> peList = new List<PicklistEntryWrapper>();
                            List<Object> picklistVals = (List<Object>)picklistFieldRoot.get('values');

                            for(Object picklistVal : picklistVals){
                                Map<String,Object> picklistValMap = (Map<String,Object>) picklistVal;
                                List<String> controllerVals = new List<String>();
                                String value = (String) picklistValMap.get('value');
                                String label = (String) picklistValMap.get('label');

                                //check if exists a controller field then set controllerValues attribute
                                List<Object> vaildForList = (List<Object>)picklistValMap.get('validFor');
                                if (vaildForList != null && !vaildForList.isEmpty()) {
                                    for (Object vaildFor : vaildForList) {
                                        Integer vaildForCode = Integer.valueOf(vaildFor);
                                        if (controllerValueMap.containsKey(vaildForCode)) {
                                            controllerVals.add(controllerValueMap.get(vaildForCode));
                                        }
                                    }
                                }


                                peList.add(new PicklistEntryWrapper(value, label.unescapeHtml4(), (picklistDefaultValue != null && picklistDefaultValue == value ? true : false), controllerVals));
                            }

                            if (!peList.isEmpty()) {
                                pickListMap.put(picklistField, peList);
                            }
                        }
                    }
                }
            } else {
                System.debug('Error loadPicklistValuesByRecordTypeName: ' + res.getStatusCode() + ' - ' + body);
            }
        } catch(Exception ex){
            System.debug('Error loadPicklistValuesByRecordTypeName: ' + ex);
        }

        return pickListMap;
    }

    /*
    Converts SAP dates like '20201106' into a Date.
    Dates like '99991231' are infinity dates.
    Dates like '00000000' are zero dates.
    */
    public static Date getDateFromSAPString(String sapDate) {
        if (sapDate == '0') {
            sapDate = '00000000';
        }
        if (String.isBlank(sapDate) || sapDate.length() != 8) {
            return null;
        }

        Integer year = Integer.valueOf(sapDate.substring(0, 4));
        Integer month = Integer.valueOf(sapDate.substring(4, 6));
        Integer day = Integer.valueOf(sapDate.substring(6, 8));
        if (year == 0) {
            final Date zeroDate = Date.newInstance(1900, 01, 01);
            return zeroDate;
        } else if (year > 4000) {
            final Date infinityDate = Date.newInstance(4000, 12, 31);
            return infinityDate;
        } else {
            return Date.newInstance(year,month,day);
        }
    }

    public static Date getDateFromSAPInteger(Integer sapDate) {
        return getDateFromSAPString(String.valueOf(sapDate));
    }

    public static String getSAPStringFromDate(Date tempDate)
    {
        return Datetime.newInstance(tempDate, Time.newInstance(0,0,0,0)).format('yyyyMMdd');
    }

    public static String getLanguageKeyByUserIsoLanguage(final String isoLanguage, final boolean toUpperCase) {
        if(String.isBlank(isoLanguage)) {
            return null;
        }
        List<String> localeInformation = isoLanguage.split('_');
        if(!localeInformation.isEmpty()) {
            return toUpperCase ? localeInformation.get(0).toUpperCase() : localeInformation.get(0);
        }
        return null;
    }

    /**
    * @description  builds Set<String>
    * @param:       List<SObject> sObject lists
    * @param:       SObjectField field
    * @return:      Set<String> build from input list of SObjects for specified field
    */
    public static Set<String> getStringValues(List<SObject> sObjects, SObjectField field) {
        Set<String> result = new Set<String>();
        for (SObject sobj : sObjects) {
            result.add((String) sobj.get(field));
        }
        result.remove(null);
        return result;
    }

    /**
    * @description  checks if aby of the fields were modified between old and new sObject
    * @param:       SObject oldSobject to compare
    * @param:       SObject newSobject to compare
    * @param:       Set<SObjectField> fields to compare values
    * @return:      Boolean return true if at least one of the fields was modified between old and new sObject
    */
    public static Boolean hasSObjectChanged(SObject oldSobject, SObject newSobject, Set<SObjectField> fields) {
        Boolean wasAtLeastOneFieldModified = false;
        for (SObjectField field : fields) {
            if (oldSobject?.get(field) != newSobject?.get(field)) {
                wasAtLeastOneFieldModified = true;
                break;
            }
        }
        return wasAtLeastOneFieldModified;
    }

    public class PicklistEntryWrapper {

        @AuraEnabled
        public String value {get;set;}

        @AuraEnabled
        public String label {get;set;}

        @AuraEnabled
        public Boolean isDefault {get;set;}

        @AuraEnabled
        public List<String> controllerValues {get;set;}

        public PicklistEntryWrapper(String value, String label, Boolean isDefault, List<String> controllerValues) {
            this.value = value;
            this.label = label;
            this.isDefault = isDefault;
            this.controllerValues = controllerValues;
        }

        public PicklistEntryWrapper(String value, String label, Boolean isDefault) {
            this.value = value;
            this.label = label;
            this.isDefault = isDefault;
            this.controllerValues = new List<String>();
        }
    }

    public static String getCurrentAppName() {
        UserAppInfo userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
        AppDefinition appDefinition = [SELECT DurableId, DeveloperName FROM AppDefinition Where DurableId = :userAppInfo.AppDefinitionId LIMIT 1];
        return appDefinition.DeveloperName;
    }

    // Convert decimal to binary representation (alas, Apex has no native method :-(
    //    eg. 4 => '100', 19 => '10011', etc.
    // Method: Divide by 2 repeatedly until 0. At each step note the remainder (0 or 1).
    // These, in reverse order, are the binary.
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }

    // Convert a base64 token into a binary/bits representation
    // e.g. 'gAAA' => '100000000000000000000'
    public static String base64ToBits(String base64String) {
        if (String.isEmpty(base64String)) return '';

        String returnBits = '';

        for (Integer i = 0; i < base64String.length(); i++) {
            String thisChar = base64String.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            returnBits += bits;
        }

        return returnBits;
    }

    public static String getCountryByIsoLocale(final String isoLocale) {
        if(String.isBlank(isoLocale)) {
            return null;
        }
        List<String> countryCode = isoLocale.split('_');
        if(countryCode.size() > 1) {
            return countryCode.get(1);
        }
        return null;
    }

    public static Map<String,Profile> profileByDeveloperNameMap = new Map<String,Profile>();

    public static Profile getProfileByName(String profileName) {

        if (profileByDeveloperNameMap.isEmpty()) {
            List<Profile> profiles = [SELECT Id, Name FROM Profile];
            for (Profile profile : profiles) {
                profileByDeveloperNameMap.put(profile.Name,profile);
                if (profile.Name == 'System Administrator') profileByDeveloperNameMap.put('Systemadministrator',profile);
                if (profile.Name == 'Systemadministrator') profileByDeveloperNameMap.put('System Administrator',profile);
            }
        }
        return profileByDeveloperNameMap.get(profileName);
    }

    public static List<string> getFields(String selectedObject){
        List<String> reqFields = new List<String>();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(selectedObject);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> mapOfField = r.fields.getMap();

        for(String fieldName : mapOfField.keySet()) {
            Schema.SObjectField field = mapOfField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            reqFields.add(field.getDescribe().getName());
        }

        return reqFields;
    }

    public static List<String> getChangedFields(SObject newObject, SObject oldObject){
        List<String> differentFields = new List<String>();
        List<String> fieldsList = getFields(newObject.getSObjectType().getDescribe().getName());

        for (String aField: fieldsList)
        {
           if(newObject.get(aField) != oldObject.get(aField)){
               differentFields.add(aField);
            }
        }

        return differentFields;
    }

    public static String getFieldLabel(String sObjectType, String fieldName) {
        Map <String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(sObjectType);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> mapOfField = r.fields.getMap();

        return mapOfField.get(fieldName).getDescribe().getLabel();
    }

    public static void removeValueFromList(List<String> inputList, String valueToRemove){
        if(inputList.contains(valueToRemove)){
            inputList.remove(inputList.indexOf(valueToRemove));
        }
    }
}