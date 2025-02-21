@isTest
private class orderViewControllerTest {
    
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
    static void testGetOrders() {
        Test.startTest();
        List<Order__c> orders = orderViewController.getOrders();
        Test.stopTest();

        System.assert(orders.size() > 0, 'Se esperaba al menos una orden');

        Order__c firstOrder = orders[0];
        System.assertNotEquals(null, firstOrder.Id, 'El ID de la orden no debe ser null');
        System.assertNotEquals(null, firstOrder.Customer__c, 'El campo Customer__c no debe ser null');
        System.assertEquals('Pending', firstOrder.Status__c, 'El estado debería ser Pending');
    }
}
