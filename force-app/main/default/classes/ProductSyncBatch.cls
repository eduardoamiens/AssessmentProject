global class ProductSyncBatch implements Database.Batchable<String>, Database.AllowsCallouts {
    
    global Iterable<String> start(Database.BatchableContext BC) {
        return new List<String> { 'FetchProducts' };
    }

    global void execute(Database.BatchableContext BC, List<String> scope) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:fakestoreapi/products');
        request.setMethod('GET');
        request.setTimeout(10000);
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            system.debug('getStatusCode() ' + response.getStatusCode());
            system.debug('response.getBody() ' + response.getBody());
            List<ProductWrapper> products = (List<ProductWrapper>) JSON.deserialize(response.getBody(), List<ProductWrapper>.class);
            upsertProducts(products);
        } else {
            System.debug('Error al obtener productos: ' + response.getStatus());
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('🔹 Sincronización de productos finalizada.');
    }

    private void upsertProducts(List<ProductWrapper> products) {
        List<ProductExternal__c> productRecords = new List<ProductExternal__c>();

        for (ProductWrapper product : products) {
            ProductExternal__c p = new ProductExternal__c();
            p.External_Id__c = String.valueOf(product.id);
            if (product.title != null && product.title.length() > 80) {
                p.Name = product.title.substring(0, 80);
            } else {
                p.Name = product.title;
            }
            p.Description__c = product.description;
            p.Price__c = product.price;
            p.Category__c = product.category;
            p.Image__c = product.image;
            p.Rating__c = product.rating.rate;
            p.Count__c = product.rating.count;
            productRecords.add(p);
        }

        upsert productRecords External_Id__c; 
    }

    public class ProductWrapper {
        public Integer id;
        public String title;
        public String description;
        public Decimal price;
        public String category;
        public String image;
        public RatingWrapper rating;
    }

    public class RatingWrapper {
        public Decimal rate;
        public Integer count;
    }
}