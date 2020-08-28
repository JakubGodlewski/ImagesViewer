@isTest
public with sharing class ImportImagesRecordsBatchTest {
    @isTest
    private static void testBatchExecuting() {
        System.assertEquals(0, [SELECT Count(Id) cnt FROM Image][0].get('cnt'));
        Test.setMock(HttpCalloutMock.class, new ImagesRecordsHTTPResponseMock());
        Test.startTest();
        	Database.executeBatch(new ImportImagesRecordsBatch());
        Test.stopTest();
        System.assertEquals(3, [SELECT Count(Id) cnt FROM Image][0].get('cnt'));
    }
}