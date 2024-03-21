import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { showToast } from 'c/pmhrUtils';
/* Apex actions */
import getFinalTeamInfo from '@salesforce/apex/PMHR_FinalTeamListController.getFinalTeamInfo';
/* SObject fields */
import FIELD_NUZLOCKE_ID from '@salesforce/schema/PMHR_Nuzlocke__c.Id';
/* Labels */
import PMHR_SpinnerAltText from '@salesforce/label/c.PMHR_SpinnerAltText';
import PMHR_LabelError from '@salesforce/label/c.PMHR_LabelError';

export default class pmhrNuzlockeFinalTeams extends LightningElement {
    @api recordId;

    label;
    displaySpinner;
    finalTeams;

    constructor() {
        super();
        this.label = {
            PMHR_SpinnerAltText
        };
        this.displaySpinner = true;
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [FIELD_NUZLOCKE_ID]
    }) record({error, data}) {
        if (data) {
            this._initialize();
        }
    }

    _initialize() {
        getFinalTeamInfo({
            nuzlockeId: this.recordId
        }).then(result => {
            this.finalTeams = result;
        }).catch(error => {
            showToast(PMHR_LabelError, error.message, 'error');
        }).finally(() => {
            this.displaySpinner = false;
        });
    }
}