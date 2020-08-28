public with sharing class TestDataFactory {
    
    public List<Image> imagesList {get; private set;}

    public TestDataFactory createImagesList(Integer numOfImages) {
        if(this.imagesList == null) {
            this.imagesList = new List<Image>();
            for(Integer i=0; i<numOfImages; i++) {
                imagesList.add(
                    new Image(
                        Title = 'test title'+i,
                        Id__c = i,
                        AlbumId__c = i,
                        URL = 'http://testurl'+i+'.com',
                        ThumbNailURL__c = 'http://testurl'+i+'.com'
                ));
            }
            insert this.imagesList;
        }
        return this;
    }
}