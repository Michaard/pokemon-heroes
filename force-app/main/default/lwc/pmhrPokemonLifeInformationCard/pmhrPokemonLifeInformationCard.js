import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import PMHR_Section_Title_Death_Info from '@salesforce/label/c.PMHR_Section_Title_Death_Info';
import PMHR_Field_Life_Status from '@salesforce/label/c.PMHR_Field_Life_Status';
import PMHR_Field_Death_Level from '@salesforce/label/c.PMHR_Field_Death_Level';
import PMHR_Field_Death_Reason from '@salesforce/label/c.PMHR_Field_Death_Reason';
import PMHR_Death_Status_Dead from '@salesforce/label/c.PMHR_Death_Status_Dead';
import PMHR_Death_Status_Alive from '@salesforce/label/c.PMHR_Death_Status_Alive';

const POKEMON_FIELDS = ['Pokemon__c.Death__c', 'Pokemon__c.Death_Level__c', 'Pokemon__c.Cause_of_Death__c'];
const CSS_CLASS_SLDS_SIZE_1_OF_2 = 'slds-size_1-of-2';

class PokemonData {
    constructor(isDead, deathLevel, causeOfDeath) {
        this.isDead = isDead;
        this.deathLevel = deathLevel;
        this.causeOfDeath = causeOfDeath;
    }
}

export default class PMHR_PokemonLifeInformationCard extends LightningElement {
    @api recordId;
    displaySpinner;
    labels;
    pokemonData;

    @wire(getRecord, {recordId: '$recordId', fields: POKEMON_FIELDS}) record({error, data}){
        if (data) {
            this.initPokemonData(data);
        }
    }

    constructor() {
        super();
        this.labels = {
            PMHR_Section_Title_Death_Info,
            PMHR_Field_Life_Status,
            PMHR_Field_Death_Level,
            PMHR_Field_Death_Reason,
            PMHR_Death_Status_Dead,
            PMHR_Death_Status_Alive
        };
        this.pokemonData = new PokemonData();
    }

    get lifeStatus() {
        if (this.pokemonData) {
            if (this.pokemonData.isDead) {
                return this.labels.PMHR_Death_Status_Dead;
            } else {
                return this.labels.PMHR_Death_Status_Alive;
            }
        }
    }

    initPokemonData(data) {
        this.displaySpinner = true;
        this.pokemonData = new PokemonData(data.fields.Death__c.value, data.fields.Death_Level__c.value, data.fields.Cause_of_Death__c.value);
        let lifeStatusDiv = this.template.querySelector('[data-id="lifeStatusDiv"]');
        if (this.pokemonData.isDead) {
            lifeStatusDiv.classList.add(CSS_CLASS_SLDS_SIZE_1_OF_2);
        } else {
            lifeStatusDiv.classList.remove(CSS_CLASS_SLDS_SIZE_1_OF_2);
        }
        this.displaySpinner = false;
    }
}