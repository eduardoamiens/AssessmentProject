trigger OrderItemTrigger on Order_Item__c (after update) {
	new OrderItemTriggerHandler().run();
}