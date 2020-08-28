@isTest
public with sharing class ImagesViewerControllerTest {
    
    @TestSetup
    private static void makeData(){
        new TestDataFactory().createImagesList(200);
    }
    
    @isTest
    private static void testGetImages() {
        List<Image> imagesList;
        Test.startTest();
            imagesList = ImagesViewerController.getImages();
        Test.stopTest();
        System.assertEquals(200, imagesList.size());
    }

    @isTest
    private static void testSendFilteredList() {
        String testEmail = 'test@test.com';
        System.assertEquals(0, [SELECT Count(Id) cnt FROM EmailMessage][0].get('cnt'));
        Test.startTest();
            String imagesList = JSON.serialize(ImagesViewerController.getImages());
            ImagesViewerController.sendFilteredList(testEmail, imagesList);
        Test.stopTest();
        System.assertEquals(1, [SELECT Count(Id) cnt FROM EmailMessage][0].get('cnt'));
    }
}