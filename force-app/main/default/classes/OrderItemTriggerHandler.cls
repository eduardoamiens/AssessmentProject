public class OrderItemTriggerHandler extends TriggerHandler {
    
    public Map<Id, Order_Item__c> newOrderItemMap;
    public Map<Id, Order_Item__c> oldOrderItemMap;
    public List<Order_Item__c> newOrderItemList;
    
    public OrderItemTriggerHandler() {
        this.newOrderItemMap = (Map<Id, Order_Item__c>) Trigger.newMap;
        this.oldOrderItemMap = (Map<Id, Order_Item__c>) Trigger.oldMap;
        this.newOrderItemList = (List<Order_Item__c>) Trigger.new;
    }
    
    public override void afterUpdate() {
        UpdateOrderTotal updateOrderTotal = new UpdateOrderTotal(this.newOrderItemMap, this.oldOrderItemMap);
        updateOrderTotal.updateOrders();
    }

    public override void afterInsert() {
        UpdateOrderTotal updateOrderTotal = new UpdateOrderTotal(this.newOrderItemMap, this.oldOrderItemMap);
        updateOrderTotal.insertOrders();
    }

    public override void beforeInsert() {
        SaveOrderTotal saveOrderTotal = new SaveOrderTotal(this.newOrderItemList);
        saveOrderTotal.saveOrders();
    }

    public override void afterDelete() {
        UpdateOrderTotal updateOrderTotal = new UpdateOrderTotal(this.newOrderItemMap, this.oldOrderItemMap);
        updateOrderTotal.deleteOrders();
    }
    
}