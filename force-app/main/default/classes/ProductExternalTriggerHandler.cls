public class ProductExternalTriggerHandler extends TriggerHandler {
    
    public Map<Id, ProductExternal__c> newProductExternalMap;
    
    public ProductExternalTriggerHandler() {
        this.newProductExternalMap = (Map<Id, ProductExternal__c>) Trigger.newMap;
    }
    
    public override void afterUpdate() {
        UpdateOrderItems updateOI = new UpdateOrderItems(this.newProductExternalMap);
        updateOI.updateOrders();
    }
    
}