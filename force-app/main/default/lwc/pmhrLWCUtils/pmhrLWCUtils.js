import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'
import USER_NAME_FIELD from '@salesforce/schema/User.FirstName'

export default class PmhrLWCUtils extends LightningElement {
    userData;
    userError;
    @wire(getRecord, {recordId: USER_ID, fields: [USER_NAME_FIELD]}) user({error, data}) {
        this.userError = error;
        this.userData = data;
    }

    get isLoading() {
        return this.isUserDataLoaded();
    }

    get userName() {
        if (this.userData) {
            return this.userData.fields.FirstName.value;
        }
    }

    get hasErrors() {
        return this.userError;
    }

    isUserDataLoaded() {
        return !(this.userData || this.userError);
    }

    handleButtonClick() {
        console.log("button clicked");
        this.userData = undefined;
        this.userError = undefined;
    }
}