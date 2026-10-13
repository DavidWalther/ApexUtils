public class ErrorLogDeleteBatch implements Database.Batchable<sObject>, Schedulable {

    public static final Integer DAYS_TO_KEEP = 30; // this can be changed later to be read from a Custommetadata Type

    private Integer daysToKeep;

    // Static method to enqueue a job for execution
    public static void executeBatchJob() {
        ErrorLogDeleteBatch batch = new ErrorLogDeleteBatch().setDaysToKeep(DAYS_TO_KEEP);
        Database.executeBatch(batch);
    }

    public ErrorLogDeleteBatch setDaysToKeep(Integer daysToKeep) {
        this.daysToKeep = daysToKeep;
        return this;
    }

    // Start method
    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date thresholdDate = Date.today().addDays(-daysToKeep);
        return Database.getQueryLocator([
            SELECT Id
            FROM ErrorLog__c
            WHERE CreatedDate <= :thresholdDate AND KeepLog__c = false
        ]);
    }

    // Execute method
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        // Delete the old logs
        if(!scope.isEmpty()) {
            delete scope;
        }
    }

    // Finish method
    public void finish(Database.BatchableContext bc) {
        // You can send a notification or do post-processing here if needed
    }

    // Implementation of Schedulable's execute method
    public void execute(SchedulableContext sc) {
        executeBatchJob();
    }
}