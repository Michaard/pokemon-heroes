import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
/* Apex methods */
import getFinalTeams from '@salesforce/apex/PMHR_FinalTeamListController.getFinalTeamInfo';
/* Labels */
import PMHR_Spinner_Alt_Text from '@salesforce/label/c.PMHR_Spinner_Alt_Text'

export default class PMHR_NuzlockeFinalTeams extends LightningElement {
    @api recordId;
    displaySpinner;
    finalTeams;
    isFinalTeamsListEmpty;
    labels;

    constructor() {
        super();
        this.displaySpinner = false;
        this.isFinalTeamsListEmpty = true;
        this.labels = {
            PMHR_Spinner_Alt_Text
        };
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: ["PMHR_Nuzlocke__c.Id"]
    }) record({error, data}) {
        if (data) {
            this.initialize();
        }
    }

    initialize() {
        this.displaySpinner = true;
        getFinalTeams({nuzlockeId: this.recordId})
        .then(result => {
            this.finalTeams = result;
            if (this.finalTeams.length != 0) {
                this.isFinalTeamsListEmpty = false;
            }
            this.displaySpinner = false;
        }).catch(error => {
            console.log(error);
            this.displaySpinner = false;
        })
    }
}