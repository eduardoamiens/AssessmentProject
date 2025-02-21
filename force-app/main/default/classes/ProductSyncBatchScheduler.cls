global class ProductSyncBatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProductSyncBatch batchJob = new ProductSyncBatch();
        Database.executeBatch(batchJob);
    }
}