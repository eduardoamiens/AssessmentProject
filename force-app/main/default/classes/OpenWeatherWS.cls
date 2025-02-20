public with sharing class OpenWeatherWS {

    
    @AuraEnabled(cacheable=false)
    public static String getWeatherDetail(String latitude, String longitude) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        API_Config__mdt apiConfig = [SELECT APIKey__c FROM API_Config__mdt WHERE DeveloperName = 'OpenWeather' LIMIT 1];
        if (apiConfig == null || String.isEmpty(apiConfig.APIKey__c)) {
            throw new AuraHandledException('No se encontró la API Key en Custom Metadata.');
        }
        string endPoint = 'callout:openweathermap/data/2.5/weather?lat=' + latitude + '&lon=' + longitude + '&appid=' + apiConfig.APIKey__c;
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setTimeout(10000);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            system.debug('Error en body: ' + response.getBody());
            System.debug('Error en OpenWeatherAPI: ' + response.getStatus());
            return null;
        }
    }  

}