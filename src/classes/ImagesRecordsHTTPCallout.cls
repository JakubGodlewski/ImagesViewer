public with sharing class ImagesRecordsHTTPCallout {

    public List<Image> imagesList {get;set;}

    public ImagesRecordsHTTPCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/photos');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Object> results;
        if (response.getStatusCode() == 200) {
            imagesList = new List<Image>();
            List<ImagesRecordsHTTPCallout.ImageWrapper> objectsList = 
                (List<ImagesRecordsHTTPCallout.ImageWrapper>)JSON.deserializeStrict(response.getBody(), 
                List<ImagesRecordsHTTPCallout.ImageWrapper>.class);
            for(ImageWrapper imwrp :objectsList)
                imagesList.add(imwrp.getImageRecord());
        }
        else 
            System.debug(response.getStatusCode() + ' ' + response.getStatus());
    }

    class ImageWrapper {
        public Integer albumId {get;set;}
        public Integer id {get;set;}
        public String title {get;set;}
        public String url {get;set;}
        public String thumbnailUrl {get;set;}
    
        public Image getImageRecord() {
            return new Image(
                AlbumId__c =this.albumId,
                Id__c =this.id,
                Title =this.title,
                Url=this.url,
                ThumbnailUrl__c=this.thumbnailUrl
            );
        }
    }
}