public with sharing class ImagesViewerController {
    @AuraEnabled(cacheable = true)
    public static List<Image> getImages() {
        return [SELECT Id, Title, Id__c, ThumbnailUrl__c FROM Image];
    }

    @AuraEnabled
    public static void sendFilteredList(String email, String filteredList) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {email}; 
        mail.setToAddresses(toAddresses);   
        mail.setSubject(System.Label.Image_Viewer_Mail_Subject);
        List<Image> imagesList = (List<Image>)JSON.deserializeStrict(filteredList, List<Image>.class);
        String plainTextBody = System.Label.Image_Viewer_Mail_Header +' \n';
        Integer index = 0;
        for(Image i :imagesList) {
            index++;
            plainTextBody+='\n'+System.Label.Image_Viewer_Mail_No+' ' +index+':';
            plainTextBody+='\n'+System.Label.Image_Viewer_Mail_Title+' '+i.Title;
            plainTextBody+='\n'+System.Label.Image_Viewer_Mail_Id+' '+i.Id__c;
            plainTextBody+='\n'+System.Label.Image_Viewer_Mail_URL+' '+i.ThumbnailUrl__c  +'\n';
        }
        mail.setPlainTextBody(plainTextBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}