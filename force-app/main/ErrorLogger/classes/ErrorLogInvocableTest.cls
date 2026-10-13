@isTest
private class ErrorLogInvocableTest {

    @isTest
    static void testWithAllParameters() {
        // Arrange
        ErrorLogInvocable.InvocableRequest request = new ErrorLogInvocable.InvocableRequest();
        request.message = 'Something went wrong';
        request.messageList = new List<String>{ 'Step 1 failed', 'Step 2 skipped', 'Step 3 not reached' };
        request.recordId = '001000000000001';

        // Act
        Test.startTest();
        ErrorLogInvocable.createErrorLogs(new List<ErrorLogInvocable.InvocableRequest>{ request });
        Test.stopTest();

        // Assert
        ErrorLog__c log = [SELECT FlowFaultMessage__c, MessageList__c, RecordId__c FROM ErrorLog__c LIMIT 1];
        Assert.areEqual('Something went wrong', log.FlowFaultMessage__c, 'Message should match');
        Assert.areEqual('Step 1 failed\nStep 2 skipped\nStep 3 not reached', log.MessageList__c, 'MessageList should be joined with newline');
        Assert.areEqual('001000000000001', log.RecordId__c, 'RecordId should match');
    }

    @isTest
    static void testWithOnlyMessage() {
        // Arrange
        ErrorLogInvocable.InvocableRequest request = new ErrorLogInvocable.InvocableRequest();
        request.message = 'Only a message';

        // Act
        Test.startTest();
        ErrorLogInvocable.createErrorLogs(new List<ErrorLogInvocable.InvocableRequest>{ request });
        Test.stopTest();

        // Assert
        ErrorLog__c log = [SELECT FlowFaultMessage__c, MessageList__c, RecordId__c FROM ErrorLog__c LIMIT 1];
        Assert.areEqual('Only a message', log.FlowFaultMessage__c, 'Message should match');
        Assert.isNull(log.MessageList__c, 'MessageList should be null when not provided');
        Assert.isNull(log.RecordId__c, 'RecordId should be null when not provided');
    }

    @isTest
    static void testMessageListNewlineJoin() {
        // Arrange
        ErrorLogInvocable.InvocableRequest request = new ErrorLogInvocable.InvocableRequest();
        request.messageList = new List<String>{ 'Line 1', 'Line 2' };

        // Act
        Test.startTest();
        ErrorLogInvocable.createErrorLogs(new List<ErrorLogInvocable.InvocableRequest>{ request });
        Test.stopTest();

        // Assert
        ErrorLog__c log = [SELECT MessageList__c FROM ErrorLog__c LIMIT 1];
        Assert.areEqual('Line 1\nLine 2', log.MessageList__c, 'MessageList should be joined with newline separator');
    }
}
