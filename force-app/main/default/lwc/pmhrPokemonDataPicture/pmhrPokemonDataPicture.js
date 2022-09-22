import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi'
import PMHR_Spinner_Alt_Text from '@salesforce/label/c.PMHR_Spinner_Alt_Text';
import PMHR_Section_Title_Pokemon_Picture from '@salesforce/label/c.PMHR_Section_Title_Pokemon_Picture'
import { PMHR_Utils } from 'c/pmhrUtils'

class PokemonData {
    constructor(name, pictureUrl, type) {
        this.name = name;
        this.pictureUrl = pictureUrl;
        this.type = type;
    }
}

export default class PMHR_PokemonDataPicture extends LightningElement {
    @api recordId;
    displaySpinner;
    labels;
    pokemonData;

    constructor() {
        super();
        this.labels = {
            PMHR_Spinner_Alt_Text,
            PMHR_Section_Title_Pokemon_Picture
        };
        this.displaySpinner = false;
        this.pokemonData = {};
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: ['Pokemon_Data__c.Name', 'Pokemon_Data__c.Picture_Url__c', 'Pokemon_Data__c.Type__c']
    }) record({error, data}) {
        if (data) {
            this._initialize(data);
        }
    }

    get mainCardTitle() {
        return PMHR_Utils.stringFormat(this.labels.PMHR_Section_Title_Pokemon_Picture, this.pokemonData.name);
    }

    _initialize(data) {
        this.displaySpinner = true;
        this.pokemonData = new PokemonData(data.fields.Name.value, data.fields.Picture_Url__c.value, data.fields.Type__c.value);
        this.displaySpinner = false;
    }
}