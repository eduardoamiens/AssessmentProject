public class OrderItemTriggerHandler extends TriggerHandler {
    
    public Map<Id, Order_Item__c> newOrderItemMap;
    public Map<Id, Order_Item__c> oldOrderItemMap;
    
    public OrderItemTriggerHandler() {
        this.newOrderItemMap = (Map<Id, Order_Item__c>) Trigger.newMap;
        this.oldOrderItemMap = (Map<Id, Order_Item__c>) Trigger.oldMap;
    }
    
    public override void afterUpdate() {
        UpdateOrderTotal updateOrderTotal = new UpdateOrderTotal(this.newOrderItemMap, this.oldOrderItemMap);
        updateOrderTotal.updateOrders();
    }
    
}