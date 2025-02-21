global class OverdueOrdersScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        OverdueOrdersBatch batchJob = new OverdueOrdersBatch();
        Database.executeBatch(batchJob);
    }
}