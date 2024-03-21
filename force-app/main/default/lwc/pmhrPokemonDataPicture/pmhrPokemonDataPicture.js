import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'
import { PMHR_Utils, stringFormat } from 'c/pmhrUtils';
/* SObject fields */
import FIELD_POKEMON_DATA_NAME from '@salesforce/schema/PMHR_PokemonData__c.Name';
import FIELD_POKEMON_DATA_PICTURE_URL from '@salesforce/schema/PMHR_PokemonData__c.PictureUrl__c';
import FIELD_POKEMON_DATA_TYPE from '@salesforce/schema/PMHR_PokemonData__c.Type__c';
/* Labels */
import PMHR_SpinnerAltText from '@salesforce/label/c.PMHR_SpinnerAltText';
import PMHR_Section_Title_Pokemon_Picture from '@salesforce/label/c.PMHR_Section_Title_Pokemon_Picture';

class PokemonData {
    constructor(name, pictureUrl, type) {
        this.name = name;
        this.pictureUrl = pictureUrl;
        this.type = type;
    }
}

export default class pmhrPokemonDataPicture extends LightningElement {
    @api recordId;

    displaySpinner;
    label;
    pokemonData;

    constructor() {
        super();
        this.label = {
            PMHR_SpinnerAltText
        };
        this.displaySpinner = true;
        this.pokemonData = new PokemonData();
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [FIELD_POKEMON_DATA_NAME, FIELD_POKEMON_DATA_PICTURE_URL, FIELD_POKEMON_DATA_TYPE]
    }) record({error, data}) {
        if (data) {
            this._initialize(data);
            this.displaySpinner = false;
        }
    }

    get mainCardTitle() {
        return stringFormat(PMHR_Section_Title_Pokemon_Picture, this.pokemonData.name);
    }

    _initialize(data) {
        this.pokemonData = new PokemonData(
            getFieldValue(data, FIELD_POKEMON_DATA_NAME),
            getFieldValue(data, FIELD_POKEMON_DATA_PICTURE_URL),
            getFieldValue(data, FIELD_POKEMON_DATA_TYPE)
        );
    }
}