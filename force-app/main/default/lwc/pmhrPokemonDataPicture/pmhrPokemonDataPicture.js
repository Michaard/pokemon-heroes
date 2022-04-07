import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi'
import Spinner_Alt_Text from '@salesforce/label/c.Spinner_Alt_Text';
import PMHR_Section_Title_Pokemon_Picture from '@salesforce/label/c.PMHR_Section_Title_Pokemon_Picture'
import { PMHR_Utils } from 'c/pmhrUtils'

const POKEMON_DATA_FIELDS = ['Pokemon_Data__c.Name', 'Pokemon_Data__c.Picture_Url__c', 'Pokemon_Data__c.Type__c'];

class PokemonData {
    constructor(name, pictureUrl, type) {
        this.name = name;
        this.pictureUrl = pictureUrl;
        this.type = type;
    }
}

export default class PMHR_PokemonDataPicture extends LightningElement {
    @api recordId;
    pokemonData;
    displaySpinner;
    labels;

    constructor() {
        super();
        this.labels = {
            Spinner_Alt_Text,
            PMHR_Section_Title_Pokemon_Picture
        };
        this.displaySpinner = false;
        this.pokemonData = {};
    }

    @wire(getRecord, {recordId: '$recordId', fields: POKEMON_DATA_FIELDS}) record({error, data}){
        if (data) {
            this.initPokemonData(data);
        }
    }

    get mainCardTitle() {
        return PMHR_Utils.stringFormat(this.labels.PMHR_Section_Title_Pokemon_Picture, this.pokemonData.name);
    }

    initPokemonData(data) {
        this.displaySpinner = true;
        this.pokemonData = new PokemonData(data.fields.Name.value, data.fields.Picture_Url__c.value, data.fields.Type__c.value);
        this.displaySpinner = false;
    }
}