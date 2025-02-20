public class UpdateOrderTotal {

    public Map<Id, Order_Item__c> newOrderItemMap;
    public Map<Id, Order_Item__c> oldOrderItemMap;

    // Constructor que recibe los valores nuevos y antiguos
    public UpdateOrderTotal(Map<Id, Order_Item__c> newOrderItemMap, Map<Id, Order_Item__c> oldOrderItemMap) {
        this.newOrderItemMap = newOrderItemMap;
        this.oldOrderItemMap = oldOrderItemMap;
    }

    public void updateOrders() {
        Map<Id, Order__c> orderTotalCostMap = new Map<Id, Order__c>();

        
        Set<Id> orderItemIdsToUpdate = new Set<Id>();
        for (Id orderItemId : newOrderItemMap.keySet()) {
            Order_Item__c newItem = newOrderItemMap.get(orderItemId);
            Order_Item__c oldItem = oldOrderItemMap.get(orderItemId);

            if (oldItem == null || newItem.Sub_total__c != oldItem.Sub_total__c) {
                orderItemIdsToUpdate.add(orderItemId);
            }
        }

        if (orderItemIdsToUpdate.isEmpty()) {
            return;
        }

        for (Order_Item__c orderItem : [
            SELECT Id, Order__c, Sub_total__c 
            FROM Order_Item__c 
            WHERE Id IN :orderItemIdsToUpdate
        ]) {
            if (orderTotalCostMap.containsKey(orderItem.Order__c)) {
                Order__c order = orderTotalCostMap.get(orderItem.Order__c);
                order.Total__c += orderItem.Sub_total__c;
                orderTotalCostMap.put(orderItem.Order__c, order);
            } else {
                Order__c order = new Order__c(Id = orderItem.Order__c, Total__c = orderItem.Sub_total__c);
                orderTotalCostMap.put(orderItem.Order__c, order);
            }
        }

        if (!orderTotalCostMap.isEmpty()) {
            update orderTotalCostMap.values();
        }
    }
}