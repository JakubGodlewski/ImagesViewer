import { LightningElement} from 'lwc';
import getImages from '@salesforce/apex/ImagesViewerController.getImages';
import sendFilteredList from '@salesforce/apex/ImagesViewerController.sendFilteredList';
import labelEmail from '@salesforce/label/c.Image_Viewer_Email';
import labelErrorEmailMsg from '@salesforce/label/c.Image_Viewer_Error_Email_Toast_Message';
import labelErrorLoadingMsg from '@salesforce/label/c.Image_Viewer_Error_Loading_Toast_Message';
import labelErrorTitle from '@salesforce/label/c.Image_Viewer_Error_Toast_Title';
import labelFilteredImages from '@salesforce/label/c.Image_Viewer_Filtered_Images';
import labelNextPage from '@salesforce/label/c.Image_Viewer_Next_Page';
import labelPrevPage from '@salesforce/label/c.Image_Viewer_Prev_Page';
import labelSend from '@salesforce/label/c.Image_Viewer_Send';
import labelSuccessMsg from '@salesforce/label/c.Image_Viewer_Success_Toast_Message';
import labelSuccessTitle from '@salesforce/label/c.Image_Viewer_Success_Toast_Title';
import labelTitle from '@salesforce/label/c.Image_Viewer_Title';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const IMAGES_ON_PAGE = 100;

export default class ImagesViewerComponent extends LightningElement {

    labels = {labelEmail, labelFilteredImages, labelNextPage, labelPrevPage, labelSend, labelTitle}

    textValue = null;
    emailValue = null;

    pageNumber = 0;
    totalPageNum;

    imagesList = [];    
    imagesFilteredList = [];
    imagesDisplayedList = [];

    get lastPage() {
        return this.pageNumber >= this.totalPageNum;
    }

    get firstPage() {
        return this.pageNumber <= 0;
    }

    connectedCallback() {
        this.loadImages();
    }
    
	loadImages() {
		getImages()
			.then(result => {
                this.imagesList = result;
                this.imagesFilteredList = this.imagesList;
                this.setImagesDisplayedList();
                this.setTotalPageNum();
            })
            .catch(error => {this.displayToast(false, labelErrorLoadingMsg + ' '+error.body.message)});
    }

    setImagesDisplayedList() {
        this.imagesDisplayedList = 
                    this.imagesFilteredList
                    .slice(
                        this.pageNumber*IMAGES_ON_PAGE, 
                        (this.pageNumber +1)*IMAGES_ON_PAGE
                    )
    }
    
    setTotalPageNum() {
        this.totalPageNum = Math.ceil(this.imagesFilteredList.length / IMAGES_ON_PAGE) -1;
    }

    changeText(value){
        this.textValue = value.target.value;
        this.pageNumber = 0;
        this.imagesFilteredList = this.imagesList.filter(item => {
            return item.Title.includes(this.textValue);
        })
        this.setTotalPageNum();
        this.setImagesDisplayedList();
    }

    changeEmail(value){
        this.emailValue = value.target.value;
    }

    sendFilteredImages(){
        sendFilteredList({email:this.emailValue, filteredList: JSON.stringify(this.imagesFilteredList)})
        .then(() => {this.displayToast(true, labelSuccessMsg)})
        .catch(error => {this.displayToast(false, labelErrorEmailMsg + ' '+error.body.message)});
    }

    prevPage(){
        this.pageNumber--;
        this.setImagesDisplayedList();
    }

    nextPage(){
        this.pageNumber++;
        this.setImagesDisplayedList();
    }

    displayToast(isSuccess, message) {
        const evt = new ShowToastEvent({
            title: isSuccess?labelSuccessTitle:labelErrorTitle,
            message: message,
            variant: isSuccess?'success':'error'
        });
        this.dispatchEvent(evt);
    }
}