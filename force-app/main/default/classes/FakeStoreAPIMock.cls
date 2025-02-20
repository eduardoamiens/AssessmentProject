@isTest
global class FakeStoreAPIMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('[{'
            +'"id": 1,'
            +'"title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",'
            +'"price": 109.95,'
            +'"description": "Your perfect pack for everyday use and walks in the forest.",'
            +'"category": "men\'s clothing",'
            +'"image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",'
            +'"rating": {'
              +'  "rate": 3.9,'
              +'  "count": 120'
            +'}'
        +'}]');

        return res;
    }
}