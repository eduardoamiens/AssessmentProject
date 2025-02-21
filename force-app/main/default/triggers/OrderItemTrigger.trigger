trigger OrderItemTrigger on Order_Item__c (after update, after insert, before insert) {
	new OrderItemTriggerHandler().run();
}