@isTest
private class ErrorLogServiceTest {

    @isTest
    static void testCreateErrorLogWithoutRestContext() {
        // Arrange
        ErrorLog__c log;
        System.Exception testException;

        // Act
        try {
            List<Account> nonExistingList;
            Account failure = nonExistingList.get(0); // Will result in a NullPointerException
        } catch(System.Exception exc) {
            testException = exc;
            log = ErrorLogService.createErrorLog(testException);
        }

        // Assert
        System.assertEquals(testException.getTypeName(), log.ExceptionType__c, 'Exception type should match');
        System.assertEquals(testException.getMessage(), log.ExceptionMessage__c, 'Exception message should match');
        System.assertEquals(testException.getStackTraceString(), log.ExceptionStacktraceString__c, 'Stacktrace should match');
        System.assertEquals('', log.ExceptionCategory__c, 'Category should be empty if not provided');
        Assert.isNull(log.RequestUrl__c, 'Request URL should be null when not in Rest context');
        Assert.isNull(log.JsonRequest__c, 'JSON request should be null when not in Rest context');
    }

    @isTest
    static void testCreateErrorLogWithRestContext() {
        // Arrange
        final String dummyJsonBody = '{"key":"value"}';
        final String dummyEndPoint = '/services/apexrest/test/endpoint';
        ErrorLog__c log;
        System.Exception testException;

        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        req.requestURI = dummyEndPoint; //Request URL
        req.requestBody = Blob.valueOf(dummyJsonBody);
        req.httpMethod = 'POST';
        System.RestContext.request = req;

        RestResponse res = new RestResponse();
        System.RestContext.response= res;

        // Act
        try {
            List<Account> nonExistingList;
            Account failure = nonExistingList.get(0); // Will result in a NullPointerException
        } catch(System.Exception exc) {
            testException = exc;
            log = ErrorLogService.createErrorLog(testException, 'API'); // Assign Category 'API'
        }

        // Assert
        System.assertEquals(testException.getTypeName(), log.ExceptionType__c, 'Exception type should match');
        System.assertEquals(testException.getMessage(), log.ExceptionMessage__c, 'Exception message should match');
        System.assertEquals(testException.getStackTraceString(), log.ExceptionStacktraceString__c, 'Stacktrace should match');
        System.assertEquals('API', log.ExceptionCategory__c, 'Category should match');
        System.assertEquals(dummyEndPoint, log.RequestUrl__c, 'Request URL should match mock URL');
        System.assertEquals(dummyJsonBody, log.JsonRequest__c, 'JSON request should match mock request');
    }

    @isTest
    static void testHandlingMultipleTimesIsPrevented() {
        // Arrange
        ErrorLog__c innerLog;
        ErrorLog__c outerLog;
        System.Exception innerTestException;
        System.Exception outerTestException;

        // Act
        try {

            try {
                List<Account> nonExistingList;
                Account failure = nonExistingList.get(0); // Will result in a NullPointerException
            } catch(System.Exception exc) {
                innerTestException = exc;
                innerLog = ErrorLogService.createErrorLog(innerTestException); // creates a log-record based on the exception
                throw innerTestException;
            }
        } catch(System.Exception exc) {
            outerTestException = exc;
            outerLog = ErrorLogService.createErrorLog(outerTestException); // the same exception was already created a log for => returns NULL
        }

        // Assert
        Assert.areEqual(innerTestException.getStackTraceString(), innerLog.ExceptionStacktraceString__c, 'Stacktrace should match');
        Assert.areEqual(outerTestException.getStackTraceString(), innerTestException.getStackTraceString(), 'Stacktraces of inner exception and outer exception must match');
        Assert.isNull(outerLog, 'No new log must be created. A log already was created');
    }

    @isTest
    static void PreProcessorCanRemoveAttributesFromRestBody() {
        // Arrange
        Map<String, String> dummyContent = new Map<String, String> {
            'key1' => 'value1',
            'key2' => 'value2',
            'dummy' => 'Imagine a Blob value to big to be stored in a Salesforce field'
        };

        final String dummyJsonBody = JSON.serialize(dummyContent);
        final String dummyEndPoint = '/services/apexrest/test/endpoint';

        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        req.requestURI = dummyEndPoint; //Request URL
        req.requestBody = Blob.valueOf(dummyJsonBody);
        req.httpMethod = 'POST';
        System.RestContext.request = req;

        RestResponse res = new RestResponse();
        System.RestContext.response= res;

        // Act
        System.Exception testException;

        Test.startTest();
        try {
            List<Account> nonExistingList;
            Account failure = nonExistingList.get(0); // Will result in a NullPointerException
        } catch(System.Exception exc) {
            ErrorLog__c log;
            testException = exc;
            log = ErrorLogService.createErrorLog(testException, new ErrorLogService.DefaultExceptionReader(), new DummyRestContextRemoveReader(), 'API'); // Assign Category 'API'
            insert log;
        }

        Test.stopTest();
        // Assert

        // query the inserted log to get the JSON body
        ErrorLog__c log = [SELECT JsonRequest__c FROM ErrorLog__c LIMIT 1];

        // Assert the Json body can be deserialized into a Map
        Map<String, Object> logContent = (Map<String, Object>) JSON.deserializeUntyped(log.JsonRequest__c);
        Assert.areEqual(dummyContent.get('key1'), logContent.get('key1'), 'The key1 value should match');

        // Assert the dummy attribute is not present in the JSON body
        Assert.isFalse(logContent.containsKey('dummy'), 'The dummy attribute should not be present in the JSON body');
    }

    /**
     * This is a dummy RestContextReader that removes the 'dummy' attribute from the request body.
     * This behavior can be used to remove sensitive data or to reduce the size of the request body to ensure it can be stored in a Salesforce field.
     */
    private class DummyRestContextRemoveReader extends ErrorLogService.DefaultRestContextReader {
        public override String getRestRequestBody() {
            String requestBodyString = RestContext.request != NULL ? RestContext.request.requestBody.toString() : NULL;
            if(requestBodyString != NULL) {
                Map<String, Object> deserializedRequestBody = (Map<String, Object>) JSON.deserializeUntyped(requestBodyString);
                deserializedRequestBody.remove('dummy');
                return JSON.serialize(deserializedRequestBody);
            }
            return NULL;
        }
    }

    @isTest
    static void PreProcessorCanModifyAttributesInRestBody() {
        // Arrange
        Map<String, String> dummyContent = new Map<String, String> {
            'key1' => 'value1',
            'key2' => 'value2',
            'dummy' => 'Imagine a Blob value to big to be stored in a Salesforce field'
        };

        final String dummyJsonBody = JSON.serialize(dummyContent);
        final String dummyEndPoint = '/services/apexrest/test/endpoint';

        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        req.requestURI = dummyEndPoint; //Request URL
        req.requestBody = Blob.valueOf(dummyJsonBody);
        req.params.put('key3', 'value3');
        req.httpMethod = 'POST';
        System.RestContext.request = req;

        RestResponse res = new RestResponse();
        System.RestContext.response= res;

        // Act
        System.Exception testException;

        Test.startTest();
        try {
            List<Account> nonExistingList;
            Account failure = nonExistingList.get(0); // Will result in a NullPointerException
        } catch(System.Exception exc) {
            ErrorLog__c log;
            testException = exc;
            log = errorLogService.createErrorLog(testException, new ErrorLogService.DefaultExceptionReader(), new DummyRestContextModifyReader(), 'API'); // Assign Category 'API'
            insert log;
        }

        Test.stopTest();
        // Assert

        // query the inserted log to get the JSON body
        ErrorLog__c log = [SELECT UrlParameters__c, JsonRequest__c FROM ErrorLog__c LIMIT 1];

        // Assert the Json body can be deserialized into a Map
        Map<String, Object> logContent = (Map<String, Object>) JSON.deserializeUntyped(log.JsonRequest__c);
        Assert.areEqual(dummyContent.get('key1'), logContent.get('key1'), 'The key1 value should match');

        Assert.isTrue(log.UrlParameters__c.contains('key3'), 'The URL parameters should be logged in the UrlParameters__c field');

        // Assert the dummy attribute is not present in the JSON body
        Assert.isTrue(logContent.containsKey('dummy'), 'The dummy attribute should be present in the JSON body');
        Assert.areEqual(logContent.get('dummy'), dummyValue_Smaller, 'The dummy attribute should be modified');
    }

    final static String dummyValue_Smaller = 'Smaller value';

    /**
     * This is a dummy RestContextReader that modifies the request body by changing the value of an attribute.
     * This behvior can be used to remove sensitive data or to reduce the size of the request body to ensure it can be stored in a Salesforce field.
     */
    private class DummyRestContextModifyReader extends ErrorLogService.DefaultRestContextReader {
        public override String getRestRequestBody() {
            String requestBodyString = RestContext.request != NULL ? RestContext.request.requestBody.toString() : NULL;
            if(requestBodyString != NULL) {
                Map<String, Object> deserializedRequestBody = (Map<String, Object>) JSON.deserializeUntyped(requestBodyString);
                deserializedRequestBody.put('dummy', dummyValue_Smaller);
                return JSON.serialize(deserializedRequestBody);
            }
            return NULL;
        }
    }
}
