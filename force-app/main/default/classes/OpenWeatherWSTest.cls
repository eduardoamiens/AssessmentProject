@isTest
private class OpenWeatherWSTest {


    @isTest
    static void testGetWeatherDetail_Success() {
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMock.OpenWeatherMockSuccess());

        Test.startTest();
        String response = OpenWeatherWS.getWeatherDetail('19.43', '-99.13');
        Test.stopTest();

        System.assertNotEquals(null, response, 'La respuesta no debe ser null.');
        System.assert(response.contains('"temp"'), 'La respuesta debe contener datos de temperatura.');
    }



    @isTest
    static void testGetWeatherDetail_APIError() {
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMock.OpenWeatherMockError());

        Test.startTest();
        String response = OpenWeatherWS.getWeatherDetail('19.43', '-99.13');
        Test.stopTest();

        System.assertEquals(null, response, 'Debe devolver null si la API falla.');
    }

}