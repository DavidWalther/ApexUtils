public class ErrorLogInvocable {

    @InvocableMethod(label='Create Error Log' description='Creates an ErrorLog__c record from Flow parameters')
    public static List<ErrorLog__c> createErrorLogs(List<InvocableRequest> requests) {
        List<ErrorLog__c> logsToInsert = new List<ErrorLog__c>();

        for(InvocableRequest request : requests) {
            Set<ErrorLogService.LogReader> logReaders = new Set<ErrorLogService.LogReader>();
            logReaders.add(new InvocableLogReader(request));

            ErrorLog__c log = ErrorLogService.createErrorLog(logReaders);
            if(log != null) {
                logsToInsert.add(log);
            }
        }

        if(logsToInsert.isEmpty()) { return new List<ErrorLog__c>(); }
	
	insert logsToInsert;

	return logsToInsert;
    }

    public class InvocableRequest {
        @InvocableVariable(label='Flow Name' description='The name of the Flow where the error occurred')
        public String flowName;

        @InvocableVariable(label='Message' description='A simple error message')
        public String message;

        @InvocableVariable(label='Message List' description='A list of messages to log')
        public List<String> messageList;

        @InvocableVariable(label='Record ID' description='The ID of the related record')
        public String recordId;

        @InvocableVariable(label='Exception Category' description='The category of the exception to log' defaultValue='FLOW')
        public String exceptionCategory;
    }

    private class InvocableLogReader implements ErrorLogService.LogReader {
        private InvocableRequest request;

        public InvocableLogReader(InvocableRequest request) {
            this.request = request;
        }

        public void execute(ErrorLogService.ErrorLogBuilder builder) {
            if(request.flowName != null) {
                builder.setFlowName(request.flowName);
            }
            if(request.message != null) {
                builder.setFlowFaultMessage(request.message);
            }
            if(request.messageList != null && !request.messageList.isEmpty()) {
                builder.setMessageList(request.messageList);
            }
            if(request.recordId != null) {
                builder.setRecordId(request.recordId);
            }
            if(request.exceptionCategory != null) {
                builder.setExceptionCategory(request.exceptionCategory);
            }
        }
    }
}
