public with sharing class orderViewController {
    @AuraEnabled(cacheable=true)
    public static List<Order__c> getOrders(){
        return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, LastModifiedById, Customer__c, Customer__r.Last_Name__c, Status__c, Estimated_Delivery_Date__c, Total__c, Total_Value__c, Payment_Status__c, Payment_Method__c, Shipping_Address__c, Billing_Address__c, Tracking_Number__c, Carrier__c FROM Order__c];
    }
}