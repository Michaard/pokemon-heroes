import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { stringFormat, showToast } from 'c/pmhrUtils';
/* Apex actions */
import getNextAvailableForms from '@salesforce/apex/PMHR_EvolvePokemonController.getNextAvailableForms';
import setPokemonForm from '@salesforce/apex/PMHR_EvolvePokemonController.setPokemonForm';
/* SObject fields */
import FIELD_POKEMON_NAME from '@salesforce/schema/PMHR_Pokemon__c.Name';
/* Labels */
import PMHR_LabelSuccess from '@salesforce/label/c.PMHR_LabelSuccess';
import PMHR_LabelCancel from '@salesforce/label/c.PMHR_LabelCancel';
import PMHR_LabelError from '@salesforce/label/c.PMHR_LabelError';
import PMHR_SpinnerAltText from '@salesforce/label/c.PMHR_SpinnerAltText';
import PMHR_EvolveActionHeader from '@salesforce/label/c.PMHR_EvolveActionHeader';
import PMHR_EvolveActionNextFormUnavailableMessage from '@salesforce/label/c.PMHR_EvolveActionNextFormUnavailableMessage';
import PMHR_EvolveActionNextFormAssignedMessage from '@salesforce/label/c.PMHR_EvolveActionNextFormAssignedMessage';
import PMHR_EvolveActionNextFormChoiceMessage from '@salesforce/label/c.PMHR_EvolveActionNextFormChoiceMessage';

export default class pmhrEvolvePokemon extends LightningElement {
    @api recordId;

    displaySpinner;
    pokemonNextForms;
    label;

    _pokemonName;

    constructor() {
        super();
        this.displaySpinner = false;
        this.label = {
            PMHR_LabelCancel,
            PMHR_SpinnerAltText,
            PMHR_EvolveActionNextFormChoiceMessage
        };
    }

    @wire(getRecord, {
        recordId: "$recordId",
        fields: [FIELD_POKEMON_NAME]
    }) record({error, data}) {
        if (data) {
            this._initialize(data);
        }
    }

    get actionHeader() {
        return stringFormat(PMHR_EvolveActionHeader, this._pokemonName);
    }

    get noNextFormLabel() {
        return stringFormat(PMHR_EvolveActionNextFormUnavailableMessage, this._pokemonName);
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

    _initialize(pokemonData) {
        this._pokemonName = getFieldValue(pokemonData, FIELD_POKEMON_NAME);
        this._getNextAvailableForms();
    }

    _getNextAvailableForms() {
        this.displaySpinner = true;
        getNextAvailableForms({
            pokemonId: this.recordId
        }).then(result => {
            this.pokemonNextForms = result;
        }).catch(error => {
            showToast(PMHR_LabelError, JSON.stringify(error), 'error');
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
            showToast(PMHR_LabelSuccess, stringFormat(PMHR_EvolveActionNextFormAssignedMessage, this._pokemonName, nextForm.name), 'success');
        }).catch(error => {
            showToast(PMHR_LabelError, JSON.stringify(error), 'error');
        }).finally(() => {
            this.closeAction();
        });
    }
}