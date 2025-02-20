trigger ProductExternalTrigger on ProductExternal__c (after update) {
	new ProductExternalTriggerHandler().run();
}