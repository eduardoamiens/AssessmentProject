public class UpdateOrderTotal {

    public Map<Id, Order_Item__c> newOrderItemMap;
    public Map<Id, Order_Item__c> oldOrderItemMap;

    public UpdateOrderTotal(Map<Id, Order_Item__c> newOrderItemMap, Map<Id, Order_Item__c> oldOrderItemMap) {
        this.newOrderItemMap = newOrderItemMap;
        this.oldOrderItemMap = oldOrderItemMap;
    }

    public void updateOrders() {
        Map<Id, Order__c> orderTotalCostMap = new Map<Id, Order__c>();

        
        Set<Id> orderIdsToUpdate = new Set<Id>();
        for (Id orderItemId : newOrderItemMap.keySet()) {
            Order_Item__c newItem = newOrderItemMap.get(orderItemId);
            Order_Item__c oldItem = oldOrderItemMap.containsKey(orderItemId) ? oldOrderItemMap.get(orderItemId) : null;

            if (oldItem == null || newItem.Sub_total__c != oldItem.Sub_total__c) {
                orderIdsToUpdate.add(newOrderItemMap.get(orderItemId).Order__c);
            }
        }

        if (orderIdsToUpdate.isEmpty()) {
            return;
        }

        for (Order_Item__c orderItem : [
            SELECT Id, Order__c, Sub_total__c 
            FROM Order_Item__c 
            WHERE Order__c IN :orderIdsToUpdate
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
    public void insertOrders() {
        Map<Id, Order__c> orderTotalCostMap = new Map<Id, Order__c>();

        
        Set<Id> orderIdsToUpdate = new Set<Id>();
        for (Id orderItemId : newOrderItemMap.keySet()) {
            Order_Item__c newItem = newOrderItemMap.get(orderItemId);
            orderIdsToUpdate.add(newOrderItemMap.get(orderItemId).Order__c);
        }

        for (Order_Item__c orderItem : [
            SELECT Id, Order__c, Sub_total__c 
            FROM Order_Item__c 
            WHERE Order__c IN :orderIdsToUpdate
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
    public void deleteOrders() {
        Map<Id, Order__c> orderTotalCostMap = new Map<Id, Order__c>();
        Set<Id> orderIdsToUpdate = new Set<Id>();
    
        for (Id orderItemId : oldOrderItemMap.keySet()) {
            Order_Item__c deletedItem = oldOrderItemMap.get(orderItemId);
            orderIdsToUpdate.add(deletedItem.Order__c);
        }
    
        Map<Id, Decimal> orderSubtotalMap = new Map<Id, Decimal>();
    
        for (AggregateResult ar : [
            SELECT Order__c Id, SUM(Sub_total__c) total
            FROM Order_Item__c
            WHERE Order__c IN :orderIdsToUpdate
            GROUP BY Order__c
        ]) {
            orderSubtotalMap.put((Id) ar.get('Id'), (Decimal) ar.get('total'));
        }
    
        for (Id orderId : orderIdsToUpdate) {
            Decimal newTotal = orderSubtotalMap.containsKey(orderId) ? orderSubtotalMap.get(orderId) : 0;
            orderTotalCostMap.put(orderId, new Order__c(Id = orderId, Total__c = newTotal));
        }
    
        if (!orderTotalCostMap.isEmpty()) {
            update orderTotalCostMap.values();
        }
    }
    
}