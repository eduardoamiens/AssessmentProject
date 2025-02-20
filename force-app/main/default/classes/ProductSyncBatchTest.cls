@isTest
private class ProductSyncBatchTest {
    @isTest
    static void testProductSyncBatch() {
        Test.setMock(HttpCalloutMock.class, new FakeStoreAPIMock());

        Test.startTest();
        Database.executeBatch(new ProductSyncBatch());
        Test.stopTest();

        List<ProductExternal__c> products = [SELECT External_Id__c, Name, Price__c, Rating__c FROM ProductExternal__c];
        
        System.assertEquals(1, products.size(), 'Debe crearse un producto');
        System.assertEquals('Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops', products[0].Name, 'El nombre debe coincidir');
        System.assertEquals(109.95, products[0].Price__c, 'El precio debe coincidir');
        System.assertEquals(3.9, products[0].Rating__c, 'El rating debe coincidir');
    }
}