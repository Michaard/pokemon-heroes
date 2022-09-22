import { LightningElement, api, wire } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { PMHR_Utils } from 'c/pmhrUtils'
/* Labels */
import PMHR_Next_Available_Form_Header from '@salesforce/label/c.PMHR_Next_Available_Form_Header'
import PMHR_No_Next_Available_Form from '@salesforce/label/c.PMHR_No_Next_Available_Form'
import PMHR_Toast_Success_Next_Form_Assigned from '@salesforce/label/c.PMHR_Toast_Success_Next_Form_Assigned'
import PMHR_Label_Error from '@salesforce/label/c.PMHR_Label_Error'
import PMHR_Spinner_Alt_Text from '@salesforce/label/c.PMHR_Spinner_Alt_Text'
import PMHR_Choose_Next_Form from '@salesforce/label/c.PMHR_Choose_Next_Form'
/* Apex actions */
import getNextAvailableForms from '@salesforce/apex/PMHR_EvolvePokemonController.getNextAvailableForms'
import setPokemonForm from '@salesforce/apex/PMHR_EvolvePokemonController.setPokemonForm'

export default class PmhrEvolvePokemon extends LightningElement {
    @api recordId;
    displaySpinner;
    pokemonNextForms;
    label;
    _pokemonName;

    constructor() {
        super();
        this.displaySpinner = false;
        this.label = {
            PMHR_Spinner_Alt_Text,
            PMHR_Choose_Next_Form
        };
    }

    get actionHeader() {
        return PMHR_Utils.stringFormat(PMHR_Next_Available_Form_Header, this._pokemonName);
    }

    get noNextFormLabel() {
        return PMHR_Utils.stringFormat(PMHR_No_Next_Available_Form, this._pokemonName);
    }

    get isFinalForm() {
        return this.pokemonNextForms == null || this.pokemonNextForms.length == 0;
    }

    handleNextFormClick(event) {
        const selectedForm = event.detail;
        this._setPokemonForm(selectedForm);
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    @wire(getRecord, {
        recordId: "$recordId",
        fields: ["Pokemon__c.Name"]
    }) record({error, data}) {
        if (data) {
            this._initialize(data);
        }
    }

    _initialize(pokemonData) {
        this._pokemonName = pokemonData.fields.Name.value;
        this._getNextAvailableForms();
    }

    _getNextAvailableForms() {
        this.displaySpinner = true;
        getNextAvailableForms({
            pokemonId: this.recordId
        }).then(result => {
            this.pokemonNextForms = result;
        }).catch(error => {
            this._showToast(PMHR_Label_Error, JSON.stringify(error), 'error');
        }).finally(() => {
            this.displaySpinner = false;
        });
    }

    _setPokemonForm(nextForm) {
        this.displaySpinner = true;
        setPokemonForm({
            pokemonId: this.recordId,
            nextFormId: nextForm.id,
            variant: nextForm.variant
        }).then(() => {
            getRecordNotifyChange([{recordId: this.recordId}]);
            this._showToast(null, PMHR_Utils.stringFormat(PMHR_Toast_Success_Next_Form_Assigned, this._pokemonName, nextForm.name), 'success');
        }).catch(error => {
            this._showToast(PMHR_Label_Error, JSON.stringify(error), 'error');
        }).finally(() => {
            this.closeAction();
        });
    }

    _showToast(title, message, variant) {
        const toast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toast);
    }
}