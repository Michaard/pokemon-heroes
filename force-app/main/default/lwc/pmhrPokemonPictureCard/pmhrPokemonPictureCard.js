import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getPokemonPicture from '@salesforce/apex/PMHR_PokemonPictureController.getPokemonPicture';
import PMHR_Spinner_Alt_Text from '@salesforce/label/c.PMHR_Spinner_Alt_Text';

const POKEMON_FIELDS = ['PMHR_Pokemon__c.Id'];
const CSS_CLASS_PICTURE_DEAD = 'picture-dead';

export default class PMHR_PokemonPictureCard extends LightningElement {
    @api recordId;
    labels;
    displaySpinner;
    pokemonData;

    constructor() {
        super();
        this.labels = {
            PMHR_Spinner_Alt_Text
        };
        this.displaySpinner = false;
        this.pokemonData = {};
    }

    @wire(getRecord, {recordId: '$recordId', fields: POKEMON_FIELDS}) record({error, data}){
        if (data) {
            this.initialize();
        }
    }

    initialize() {
        this.displaySpinner = true;
        getPokemonPicture({pokemonId: this.recordId})
        .then(result => {
            this.pokemonData = result;
            let pokemonDataPicture = this.template.querySelector('[data-id="pokemonDataPicture"]');
            if (result.isDead) {
                pokemonDataPicture.classList.add(CSS_CLASS_PICTURE_DEAD);
            } else {
                pokemonDataPicture.classList.remove(CSS_CLASS_PICTURE_DEAD);
            }
            this.displaySpinner = false;
        }).catch(error => {
            console.log(error);
            this.displaySpinner = false;
        })
    }
}