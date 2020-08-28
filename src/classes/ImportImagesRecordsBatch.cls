global with sharing class ImportImagesRecordsBatch implements Database.Batchable<Image>, Database.AllowsCallouts{
    global Iterable<Image> start(Database.BatchableContext bc) {
        return new ImagesRecordsHTTPCallout().imagesList;
    }

    global void execute(Database.BatchableContext bc, List<Image> scope){
        insert scope;
    }

    global void finish(Database.BatchableContext bc){}
}