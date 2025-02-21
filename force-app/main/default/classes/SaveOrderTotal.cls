public with sharing class SaveOrderTotal {
    public List<Order_Item__c> newOrderItemList;
    
    public SaveOrderTotal(List<Order_Item__c> newOrderItemList){
        this.newOrderItemList = newOrderItemList;
    }
    public void saveOrders(){
        set<Id> productExternalIds = new set<Id>();
        for(Order_Item__c Order_Item : newOrderItemList){
            productExternalIds.add(Order_Item.Product_External__c);
        }
        for(ProductExternal__c productExternal : [SELECT Id, Price__c FROM ProductExternal__c WHERE Id IN :productExternalIds]){
            for(Order_Item__c Order_Item : newOrderItemList){
                if(Order_Item.Product_External__c == productExternal.Id){
                    Order_Item.Price__c = productExternal.Price__c;
                }
            }
        }
    }
}