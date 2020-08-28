@isTest
global with sharing class ImagesRecordsHTTPResponseMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {

        System.assertEquals('https://jsonplaceholder.typicode.com/photos', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"albumId": 1,"id": 1,"title": "accusamus beatae ad facilis cum similique qui sunt","url": "https://via.placeholder.com/600/92c952","thumbnailUrl": "https://via.placeholder.com/150/92c952"},'+
        '{"albumId": 1,"id": 2,"title": "reprehenderit est deserunt velit ipsam","url": "https://via.placeholder.com/600/771796","thumbnailUrl": "https://via.placeholder.com/150/771796"},'+
        '{"albumId": 1,"id": 3,"title": "officia porro iure quia iusto qui ipsa ut modi","url": "https://via.placeholder.com/600/24f355","thumbnailUrl": "https://via.placeholder.com/150/24f355"}]');
        res.setStatusCode(200);
        return res;
    }
}