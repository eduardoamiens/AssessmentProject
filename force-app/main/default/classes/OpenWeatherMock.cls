@isTest
global class OpenWeatherMock {

    global class OpenWeatherMockSuccess implements HttpCalloutMock {
        global HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"main": {"temp": 22.5, "pressure": 1012, "humidity": 60}}');
            response.setStatusCode(200);
            return response;
        }
    }

    global class OpenWeatherMockError implements HttpCalloutMock {
        global HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"cod": 401, "message": "Invalid API Key"}');
            response.setStatusCode(401);
            return response;
        }
    }
}