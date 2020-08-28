@isTest
public with sharing class ImagesRecordsHTTPCalloutTest {
    
    @isTest
    private static void testResponse() {
        List<Image> imagesList;
        Test.setMock(HttpCalloutMock.class, new ImagesRecordsHTTPResponseMock());
        Test.startTest();
        imagesList = new ImagesRecordsHTTPCallout().imagesList;
        Test.stopTest();
        System.assertEquals(3, imagesList.size());
    } 
}