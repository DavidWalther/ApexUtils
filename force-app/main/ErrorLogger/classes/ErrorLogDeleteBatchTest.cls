@isTest
private class ErrorLogDeleteBatchTest {

    @isTest
    static void testErrorLogBatchDeletion() {

        // 1. Create records that are too young to be deleted
        ErrorLog__c youngLog = new ErrorLog__c(ExceptionType__c='TestException', JsonRequest__c='{}',
                            ExceptionMessage__c='Test', ExceptionStacktraceString__c='Test',
                            RequestUrl__c='http://test.com', KeepLog__c=false);

        // 2. Create records that are old enough to be deleted but are meant to be kept
        ErrorLog__c oldButKeptLog = new ErrorLog__c(ExceptionType__c='OldButKept', JsonRequest__c='{}',
                            ExceptionMessage__c='Old But Kept', ExceptionStacktraceString__c='Test',
                            RequestUrl__c='http://test.com', KeepLog__c=true);

        // 3. Create records that are old enough and meant to be deleted
        ErrorLog__c oldLog = new ErrorLog__c(ExceptionType__c='OldAndDelete', JsonRequest__c='{}',
            ExceptionMessage__c='Old and Delete', ExceptionStacktraceString__c='Test',
            RequestUrl__c='http://test.com', KeepLog__c=false);

        insert new List<ErrorLog__c>{youngLog, oldButKeptLog, oldLog};

        // Adjusting their created date using Test.setCreatedDate
        DateTime thirtyOneDaysAgo = DateTime.now().addDays(-31);
        Test.setCreatedDate(oldButKeptLog.Id, thirtyOneDaysAgo);
        Test.setCreatedDate(oldLog.Id, thirtyOneDaysAgo);

        // Now execute the batch
        Test.startTest();

        ErrorLogDeleteBatch.executeBatchJob();

        Test.stopTest();

        // Asserts
        ErrorLog__c youngLog_Check = [SELECT Id, KeepLog__c FROM ErrorLog__c WHERE Id = :youngLog.Id];
        ErrorLog__c oldButKeptLogTest_Check = [SELECT Id, KeepLog__c FROM ErrorLog__c WHERE Id = :oldButKeptLog.Id];

        System.assertNotEquals(null, youngLog_Check, 'Young logs should not be deleted');
        System.assertNotEquals(null, oldButKeptLogTest_Check, 'Old logs meant to be kept should not be deleted');

        // New assertion for deletion of old logs
        List<ErrorLog__c> oldLogCheck = [SELECT Id FROM ErrorLog__c WHERE Id = :oldLog.Id];
        Assert.isTrue(oldLogCheck.isEmpty(), 'The old logs meant to be deleted should have been deleted.');
    }


    @isTest
    static void jobCanBeScheduled() {
        Test.startTest();

        String cronExpression = '0 0 1 * * ?'; // Runs daily at 1 AM
        ErrorLogDeleteBatch schedulableJob = new ErrorLogDeleteBatch();
        System.schedule('Error Log Deletion Job', cronExpression, schedulableJob);

        Test.stopTest();
    }
}