@isTest
private class OrderItemTriggerTest {
    
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
    static void testOrderItemTrigger() {
        
        Order__c testOrder = [SELECT Id, Total__c FROM Order__c LIMIT 1];

        
        List<Order_Item__c> orderItems = [SELECT Id, Order__c, Sub_total__c FROM Order_Item__c WHERE Order__c = :testOrder.Id];
        
        
        orderItems[0].Item_count__c = 3;
        
        Test.startTest();
        update orderItems;
        Test.stopTest();
        
        
        Order__c updatedOrder = [SELECT Id, Total__c FROM Order__c WHERE Id = :testOrder.Id];
        
        System.assertEquals(439.8, updatedOrder.Total__c, 'El Total__c de la orden no se actualizó correctamente');
    }

    @isTest
    static void testOrderItemTrigger_NoChange() {
        
        List<Order_Item__c> orderItems = [SELECT Id, Order__c, Sub_total__c FROM Order_Item__c LIMIT 1];
        
        Test.startTest();
        update orderItems;  
        Test.stopTest();
        
        
        System.assertEquals(1, [SELECT COUNT() FROM Order__c], 'No debería haber cambios en la orden');
    }
}
