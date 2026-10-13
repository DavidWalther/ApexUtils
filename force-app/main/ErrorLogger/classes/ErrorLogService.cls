public virtual class ErrorLogService {

    /**
     * LogReader is an interface that defines a contract for classes that can read information and populate an ErrorLogBuilder. This allows for a flexible and extensible design, where different implementations of LogReader can be created to extract information from various sources (e.g., exceptions, RestContext, etc.) and populate the error log accordingly.
     */
    public interface LogReader {
        /**
         * This method is responsible for reading information and populating the provided ErrorLogBuilder.
         */
        void execute(ErrorLogBuilder builder);
    }

    /**
     * ExceptionReader is an interface that extends LogReader. It is specifically designed for reading information from exceptions. By extending LogReader, it can be used interchangeably with other LogReader implementations when creating error logs, while also providing additional methods specific to exceptions.
     */
    public interface ExceptionReader extends LogReader {
        /**
         * Sets the exception to be read by this reader.
         */
        ExceptionReader setException(System.Exception exc);
    }

    /**
     * A Default implementation of the CategoryReader.
     * It allows setting a category for the error log record.
     */
    public virtual class CategoryReader implements LogReader {
        private String category;

        public LogReader setCategory(String category) {
            this.category = category;
            return this;
        }

        public virtual String getLogCategory() {
            return this.category;
        }

        public virtual void execute(ErrorLogBuilder builder) {
            builder.setExceptionCategory(getLogCategory());
        }
    }

    /**
     * A Default implementation of the ExceptionReader interface.
     * It extracts information from a System.Exception and populates the relevant fields in the ErrorLogBuilder. It also includes logic to prevent logging the same exception multiple times within the same transaction, by using a hash of the exception's type and stack trace.
     */
    public virtual class DefaultExceptionReader implements ExceptionReader {
        private System.Exception exc;

        public ExceptionReader setException(System.Exception exc) {
            this.exc = exc;
            return this;
        }

        public virtual Integer getExceptionHash() {
            String stringOfValuesToMatch = '';
            stringOfValuesToMatch += exc.getTypeName();
            stringOfValuesToMatch += exc.getStackTraceString();

            return stringOfValuesToMatch.hashCode();
        }

        public virtual String getTypeName() {
            return this.exc.getTypeName();
        }

        public virtual String getMessage() {
            return this.exc.getMessage();
        }

        public virtual String getStackTraceString() {
            return this.exc.getStackTraceString();
        }

        public virtual void execute(ErrorLogBuilder builder) {
            Integer exceptionHash = getExceptionHash();
            Boolean isExceptionAlreadyHandled = loggedExceptionHashes.contains(exceptionHash);
            if(isExceptionAlreadyHandled) {
                throw new DuplicateExceptionException();
            }
            loggedExceptionHashes.add(exceptionHash);

            builder
                .setExceptionType(getTypeName())
                .setExceptionMessage(getMessage())
                .setStacktraceString(getStackTraceString());
        }
    }

    /**
     * A Default implementation of the LogReader interface for reading information from the RestContext.
     * It extracts the request URI, request parameters, and request body from the RestContext and populates the relevant fields in the ErrorLogBuilder. It also includes checks to ensure that the RestContext and its properties are available before attempting to access them, to prevent null pointer exceptions.
     */
    public virtual class DefaultRestContextReader implements LogReader {
        public virtual String getRestRequestUri() {
            Boolean isRequestAvailable = System.RestContext.request != NULL;
            Boolean isRequestUriAvailable = isRequestAvailable && System.RestContext.request.requestURI != NULL;

            if(! isRequestUriAvailable) {
                return NULL;
            }

            return System.RestContext.request.requestURI;
        }

        public virtual String getRestRequestUriParameters () {
            Boolean isRequestAvailable = System.RestContext.request != NULL;
            Boolean isRequestUriAvailable = isRequestAvailable && System.RestContext.request.requestURI != NULL;

            if(! isRequestUriAvailable) {
                return NULL;
            }

           Map<String, String> urlParameters = System.RestContext.request.params;
           Boolean hasParameters = urlParameters != NULL && !urlParameters.isEmpty();
           if(! hasParameters) {
               return NULL;
           }

           return JSON.serializePretty(urlParameters);
        }

        public virtual String getRestRequestBody() {
            Boolean isRequestAvailable = System.RestContext.request != NULL;
            Boolean isRequestBodyAvailable = isRequestAvailable && System.RestContext.request.requestBody != NULL;

            if(! isRequestBodyAvailable) {
                return NULL;
            }

            return System.RestContext.request.requestBody.toString();
        }

        public virtual void execute(ErrorLogBuilder builder) {
            builder
                .setRequestUrl(getRestRequestUri())
                .setRequestUrlParameters(getRestRequestUriParameters())
                .setJsonRequest(getRestRequestBody());
        }
    }

    /**
     * This method creates an ErrorLog__c record based on the provided Exception.
     * @param exc The exception to log
     * @return An instance of ErrorLog__c with the relevant fields.
     */
    public static ErrorLog__c createErrorLog(System.Exception exc) {
        return createErrorLog(exc, null, null, null);
    }

    /**
     * This method creates an ErrorLog__c record based on the provided Exception and category.
     * @param exc The exception to log
     * @param exceptionCategory The category to assign to the log
     * @return An instance of ErrorLog__c with the relevant fields.
     */
    public static ErrorLog__c createErrorLog(System.Exception exc, String exceptionCategory) {
        return createErrorLog(exc, null, null, exceptionCategory);
    }

    /**
     * This method creates an ErrorLog__c record based on the provided Exception, ExceptionReader, RestContextReader, and category.
     * @param exc The exception to log
     * @param exceptionReader An implementation of ExceptionReader to extract information from the exception
     * @param restContextReader An implementation of LogReader to extract information from the RestContext
     * @param exceptionCategory The category to assign to the log
     * @return An instance of ErrorLog__c with the relevant fields.
     */
    public static ErrorLog__c createErrorLog(System.Exception exc, ExceptionReader exceptionReader, LogReader restContextReader, String exceptionCategory) {
        Set<LogReader> logReaders = new Set<LogReader>();
        if(exceptionCategory != NULL) {
            logReaders.add(new CategoryReader().setCategory(exceptionCategory));
        } else {
            logReaders.add(new CategoryReader().setCategory(''));
        }
        if(exceptionReader == null) {
            logReaders.add(new DefaultExceptionReader().setException(exc));
        } else {
            logReaders.add(exceptionReader.setException(exc));
        }
        if(restContextReader == null) {
            logReaders.add(new DefaultRestContextReader());
        } else {
            logReaders.add(restContextReader);
        }

        return createErrorLog(logReaders);
    }

    /**
     * This method creates an ErrorLog__c record based on the provided set of LogReaders. Each LogReader is executed to populate the fields of the ErrorLog__c record.
     * @param logReaders A set of LogReader implementations to extract information for the log
     * @return An instance of ErrorLog__c with the relevant fields.
     */
    public static ErrorLog__c createErrorLog(Set<LogReader> logReaders) {

        ErrorLogBuilder builder = new ErrorLogBuilder();

        try {
            for(LogReader logReader : logReaders) {
                logReader.execute(builder);
            }
        } catch(DuplicateExceptionException e) {
            return NULL;
        }

        return builder.build();
    }


    /**
     * This method is used in test classes to assert that no ErrorLog__c records have been created. If any records are found, it fails the test and provides details of the first log entry for debugging purposes.
     */
    @TestVisible
    private void assertNoErrorLogsCreated() {
        List<ErrorLog__c> occurredErrors = [SELECT ExceptionStacktraceString__c, ExceptionMessage__c FROM ErrorLog__c];
        if(!occurredErrors.isEmpty()) {
            System.debug('Number of LogEntries: ' + occurredErrors.size());
            ErrorLog__c logEntry = occurredErrors[0];
            System.debug('logEntry.ExceptionMessage__c');
            System.debug(logEntry.ExceptionMessage__c);
            System.debug('logEntry.ExceptionStacktraceString__c');
            System.debug(logEntry.ExceptionStacktraceString__c);
            Assert.Fail('Error encountered:\n\nMessage:\n' + logEntry.ExceptionMessage__c + '\n\nStackTrace\n' + logEntry.ExceptionStacktraceString__c);
        }
    }

    private class DuplicateExceptionException extends System.Exception {}

    public class ErrorLogBuilder {
        private ErrorLog__c errorLog;

        private ErrorLogBuilder() {
            this.errorLog = new ErrorLog__c();
        }

        public ErrorLogBuilder setExceptionType(String excType) {
            this.errorLog.ExceptionType__c = excType;
            return this;
        }

        public ErrorLogBuilder setExceptionCategory(String excCategory) {
            this.errorLog.ExceptionCategory__c = excCategory;
            return this;
        }

        public ErrorLogBuilder setExceptionMessage(String excMessage) {
            this.errorLog.ExceptionMessage__c = excMessage;
            return this;
        }

        public ErrorLogBuilder setStacktraceString(String stacktraceString) {
            this.errorLog.ExceptionStacktraceString__c = stacktraceString;
            return this;
        }

        public ErrorLogBuilder setRequestUrl(String requestUrl) {
            this.errorLog.RequestUrl__c = requestUrl;
            return this;
        }

        public ErrorLogBuilder setRequestUrlParameters(String requestUrlParameters) {
            this.errorLog.UrlParameters__c = requestUrlParameters;
            return this;
        }

        public ErrorLogBuilder setJsonRequest(String jsonRequest) {
            this.errorLog.JsonRequest__c = jsonRequest;
            return this;
        }

        public ErrorLogBuilder setMessage(String message) {
            this.errorLog.Message__c = message;
            return this;
        }

        public ErrorLogBuilder setMessageList(List<String> lines) {
            return setMessageList(lines, '\n');
        }

        public ErrorLogBuilder setMessageList(List<String> lines, String lineSeparator) {
            this.errorLog.MessageList__c = String.join(lines, lineSeparator);
            return this;
        }

        public ErrorLogBuilder setRecordId(String recordId) {
            this.errorLog.RecordId__c = recordId;
            return this;
        }

        public ErrorLogBuilder setFlowName(String flowName) {
            this.errorLog.FlowName__c = flowName;
            return this;
        }

        public ErrorLogBuilder setFlowFaultMessage(String faultMessage) {
            this.errorLog.FlowFaultMessage__c = faultMessage;
            return this;
        }

        public ErrorLog__c build() {
            return this.errorLog;
        }
    }

    /**
     * Logic to handle each Exception only once per transaction. This is to prevent multiple handling of the same exception, which can happen when multiple classes in the call stack use the ErrorLogService to log exceptions.
     */
    private static final Set<Integer> loggedExceptionHashes = new Set<Integer>();
}
