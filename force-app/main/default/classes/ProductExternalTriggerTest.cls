@isTest
private class ProductExternalTriggerTest {
    
    @testSetup
    static void setupTestData() {
        Test.setMock(HttpCalloutMock.class, new FakeStoreAPIMock());

        Test.startTest();
        Database.executeBatch(new ProductSyncBatch());
        Test.stopTest();

        List<ProductExternal__c> products = [SELECT External_Id__c, Name, Price__c, Rating__c FROM ProductExternal__c];
        

        Customer__c Customer = new Customer__c(Email__c = 'eduardo.test@correo.com', Last_Name__c = 'lastNameTest', Phone__c = '1234567890', 
        First_Name__c = 'firstNameTest', Company_Name__c = 'companyNameTest', Billing_Address__c = 'addressTest, cityTest, stateTest, zipTest, countryTest');
        insert Customer;
        
        Order__c testOrder = new Order__c(Billing_Address__c = 'addressTest, cityTest, stateTest, zipTest, countryTest', Carrier__c = 'DHL', Customer__c = Customer.Id,
        Estimated_Delivery_Date__c = Date.today().addDays(2), Payment_Method__c = 'Card', Payment_Status__c = 'Paid', Status__c = 'Pending', Tracking_Number__c = '1234567890');
        insert testOrder;


        Order_Item__c orderItem1 = new Order_Item__c(
            Order__c = testOrder.Id,
            Product_External__c = products[0].Id,
            Item_count__c = 1
        );
        
        Order_Item__c orderItem2 = new Order_Item__c(
            Order__c = testOrder.Id,
            Product_External__c = products[0].Id,
            Item_count__c = 1
        );

        insert new List<Order_Item__c>{ orderItem1, orderItem2 };
    }

    @isTest
    static void testProductExternalTrigger() {
        Order__c testOrder = [SELECT Id, Total__c FROM Order__c LIMIT 1];
        ProductExternal__c testProduct = [SELECT Id, Price__c FROM ProductExternal__c LIMIT 1];

        testProduct.Price__c = 600;
        
        Test.startTest();
        update testProduct;
        Test.stopTest();

        Order_Item__c updatedOrderItem = [SELECT Id, Product_price__c FROM Order_Item__c WHERE Product_External__c = :testProduct.Id LIMIT 1];
        System.assertEquals(600, updatedOrderItem.Product_price__c, 'El precio del Order Item debería haberse actualizado');

        Order__c updatedOrder = [SELECT Id, Total__c FROM Order__c WHERE Id = :testOrder.Id];
        system.debug('updatedOrder.Total__c ' + updatedOrder.Total__c);
        System.assertEquals(1200, updatedOrder.Total__c, 'El Total__c de la orden debería reflejar el nuevo precio del producto');
    }

    @isTest
    static void testProductExternalTrigger_NoChange() {
        ProductExternal__c testProduct = [SELECT Id, Price__c FROM ProductExternal__c LIMIT 1];

        Test.startTest();
        update testProduct;
        Test.stopTest();

        Order__c testOrder = [SELECT Id, Total__c FROM Order__c LIMIT 1];
        system.debug('testOrder.Total__c ' + testOrder.Total__c);
        System.assertEquals(219.9, testOrder.Total__c, 'No debería haber cambios en la orden si el precio no cambió');
    }
}
