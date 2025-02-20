public with sharing class recordDetailController {
    @AuraEnabled(cacheable=true)
    public static List<Order_Item__c> getOrderItems(String orderId){
        return [SELECT Id, Name, Order__c, Product_External__c, Item_count__c, Price_changed__c, Product_price__c, Last_price__c FROM Order_Item__c WHERE Order__c = :orderId];
    }
}