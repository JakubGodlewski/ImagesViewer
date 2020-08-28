global with sharing class DeleteImagesRecordsBatch implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Image');
    }

    global void execute(Database.BatchableContext bc, List<Image> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext bc){
        if(!Test.isRunningTest())
            Database.executeBatch(new ImportImagesRecordsBatch());
    }

    global void execute(System.SchedulableContext sc) {
        Database.executeBatch(new DeleteImagesRecordsBatch());
    }
}