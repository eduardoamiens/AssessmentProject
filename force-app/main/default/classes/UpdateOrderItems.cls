public class UpdateOrderItems {
    
    public Map<Id, ProductExternal__c> newProductExternalMap;
    
    public UpdateOrderItems(Map<Id, ProductExternal__c> newProductExternalMap){
        this.newProductExternalMap = newProductExternalMap;
    }
    public void updateOrders(){
        
        List<Order_Item__c> orderItemList = new List<Order_Item__c>();
        for(Order_Item__c Order_Item : [SELECT Id, Price__c, Order__c,Product_External__c FROM Order_Item__c WHERE Product_External__c IN :THIS.newProductExternalMap.keyset()]){
            Order_Item.Price__c = THIS.newProductExternalMap.get(Order_Item.Product_External__c).Price__c;
            Order_Item.Price_changed__c = true;
            orderItemList.add(Order_Item);
        }
        update orderItemList;
    }

}