global class ProductSyncScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ProductSyncBatch());
    }
}