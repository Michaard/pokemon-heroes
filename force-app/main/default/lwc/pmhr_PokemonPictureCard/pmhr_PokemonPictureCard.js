import { LightningElement, api, wire } from 'lwc';
import Spinner_Alt_Text from '@salesforce/label/c.Spinner_Alt_Text';
import getPokemonPicture from '@salesforce/apex/PMHR_PokemonPictureController.getPokemonPicture';
import { getRecord } from 'lightning/uiRecordApi';
import POKEMON_ID_FIELD from '@salesforce/schema/Pokemon__c.Id';

const pictureDeadCssClass = 'picture-dead';

export default class Pmhr_PokemonPictureCard extends LightningElement {
    @api recordId;
    displaySpinner;
    labels;

    @wire(getRecord, {recordId: '$recordId', fields: [POKEMON_ID_FIELD]}) record({error, data}){
        if (data) {
            this.getPokemonPicture();
        }
    }

    constructor() {
        super();
        this.labels = {
            Spinner_Alt_Text
        };
        this.displaySpinner = false;
        this.pokemonData = {};
    }

    getPokemonPicture() {
        this.displaySpinner = true;
        getPokemonPicture({pokemonId: this.recordId})
        .then(result => {
            this.pokemonData = result;
            let pokemonDataPicture = this.template.querySelector('[data-id="pokemonDataPicture"]');
            if (result.isDead) {
                pokemonDataPicture.classList.add(pictureDeadCssClass);
            } else {
                pokemonDataPicture.classList.remove(pictureDeadCssClass);
            }
            this.displaySpinner = false;
        })
        .catch(error => {
            console.log(error);
            this.displaySpinner = false;
        })
    }

}