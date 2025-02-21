global class OverdueOrdersBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, Estimated_Delivery_Date__c, Overdue__c
            FROM Order__c
            WHERE Estimated_Delivery_Date__c < TODAY 
            AND (Status__c != 'Delivered' AND Status__c != 'Canceled')
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Order__c> orderList) {
        for (Order__c order : orderList) {
            order.Overdue__c = true; 
            order.Status__c = 'Overdue';
        }
        update orderList;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('🔹 Batch Process Completed: Overdue Orders Updated.');
    }
}
