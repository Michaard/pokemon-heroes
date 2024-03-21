import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { showToast } from 'c/pmhrUtils';
/* Apex actions */
import getPokemonPicture from '@salesforce/apex/PMHR_PokemonPictureController.getPokemonPicture';
/* SObject fields */
import FIELD_POKEMON_Id from '@salesforce/schema/PMHR_Pokemon__c.Id';
/* Labels */
import PMHR_SpinnerAltText from '@salesforce/label/c.PMHR_SpinnerAltText';
import PMHR_LabelError from '@salesforce/label/c.PMHR_LabelError';
/* Constants */
const CSS_CLASS_PICTURE_DEAD = 'picture-dead';

export default class pmhrPokemonPictureCard extends LightningElement {
    @api recordId;
    labels;
    displaySpinner;
    pokemonData;

    constructor() {
        super();
        this.label = {
            PMHR_SpinnerAltText
        };
        this.displaySpinner = true;
        this.pokemonData = {};
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [FIELD_POKEMON_Id]
    }) record({error, data}) {
        if (data) {
            this._initialize();
        }
    }

    _initialize() {
        getPokemonPicture({
            pokemonId: this.recordId
        }).then(result => {
            this.pokemonData = result;
            let pokemonDataPicture = this.template.querySelector('[data-id="pokemonDataPicture"]');
            if (result.isDead) {
                pokemonDataPicture.classList.add(CSS_CLASS_PICTURE_DEAD);
            } else {
                pokemonDataPicture.classList.remove(CSS_CLASS_PICTURE_DEAD);
            }
        }).catch(error => {
            showToast(PMHR_LabelError, error.message, 'error');
        }).finally(() => {
            this.displaySpinner = false;
        });
    }
}