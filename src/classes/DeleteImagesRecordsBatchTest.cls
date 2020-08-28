@isTest
public with sharing class DeleteImagesRecordsBatchTest {
    
    @TestSetup
    private static void makeData(){
        new TestDataFactory().createImagesList(200);
    }

    @isTest
    private static void testBatchExecuting() {
        System.assertEquals(200, [SELECT Count(Id) cnt FROM Image][0].get('cnt'));
		Test.startTest();
        	Database.executeBatch(new DeleteImagesRecordsBatch());
        Test.stopTest();
        System.assertEquals(0, [SELECT Count(Id) cnt FROM Image][0].get('cnt'));
    }

    @isTest
    private static void testBatchScheduling() {
        System.assertEquals(0, [SELECT Count(Id) cnt FROM CronJobDetail][0].get('cnt'));
        Test.startTest();
            String sch = '0 0 0 1 1 ? '+Date.today().addYears(1).year();
            String jobID = system.schedule('DeleteImagesRecordsBatch', sch, new DeleteImagesRecordsBatch());
        Test.stopTest();
        System.assertEquals(1, [SELECT Count(Id) cnt FROM CronJobDetail][0].get('cnt'));
    }
}