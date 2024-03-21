import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
/* SObject */
import SOBJECT_POKEMON from '@salesforce/schema/PMHR_Pokemon__c';
/* SObject fields */
import FIELD_POKEMON_IS_DECEASED from '@salesforce/schema/PMHR_Pokemon__c.IsDeceased__c';
import FIELD_POKEMON_DEATH_LEVEL from '@salesforce/schema/PMHR_Pokemon__c.DeathLevel__c';
import FIELD_POKEMON_CAUSE_OF_DEATH from '@salesforce/schema/PMHR_Pokemon__c.CauseOfDeath__c';
/* Labels */
import PMHR_LifeInfoSectionTitle from '@salesforce/label/c.PMHR_LifeInfoSectionTitle';
import PMHR_LifeInfoLabelLifeStatus from '@salesforce/label/c.PMHR_LifeInfoLabelLifeStatus';
import PMHR_LifeInfoLabelLifeStatusDead from '@salesforce/label/c.PMHR_LifeInfoLabelLifeStatusDead';
import PMHR_LifeInfoLabelLifeStatusAlive from '@salesforce/label/c.PMHR_LifeInfoLabelLifeStatusAlive';
/* Constants */
const CSS_CLASS_SLDS_SIZE_1_OF_2 = 'slds-size_1-of-2';

class PokemonData {
    constructor(isDead, deathLevel, causeOfDeath) {
        this.isDead = isDead;
        this.deathLevel = deathLevel;
        this.causeOfDeath = causeOfDeath;
    }
}

export default class pmhrPokemonLifeInformationCard extends LightningElement {
    @api recordId;

    displaySpinner;
    label;
    pokemonData;

    constructor() {
        super();
        this.label = {
            PMHR_LifeInfoSectionTitle,
            PMHR_LifeInfoLabelLifeStatus,
            PMHR_LifeInfoLabelLifeStatusDead,
            PMHR_LifeInfoLabelLifeStatusAlive
        };
        this.pokemonData = new PokemonData();
        this.displaySpinner = true;
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [FIELD_POKEMON_IS_DECEASED, FIELD_POKEMON_DEATH_LEVEL, FIELD_POKEMON_CAUSE_OF_DEATH]
    }) record({error, data}) {
        if (data) {
            this._initializePokemonData(data);
        }
    }

    @wire(getObjectInfo, {
        objectApiName: SOBJECT_POKEMON
    }) oppInfo({ data, error }) {
        if (data) {
            this._initializeFieldLabels(data);
        }
    }

    get lifeStatus() {
        if (this.pokemonData) {
            return this.pokemonData.isDead ? PMHR_LifeInfoLabelLifeStatusDead : PMHR_LifeInfoLabelLifeStatusAlive;
        }
    }

    _initializePokemonData(data) {
        this.pokemonData = new PokemonData(
            getFieldValue(data, FIELD_POKEMON_IS_DECEASED),
            getFieldValue(data, FIELD_POKEMON_DEATH_LEVEL),
            getFieldValue(data, FIELD_POKEMON_CAUSE_OF_DEATH)
        );

        let lifeStatusDiv = this.template.querySelector('[data-id="lifeStatusDiv"]');

        if (this.pokemonData.isDead) {
            lifeStatusDiv.classList.add(CSS_CLASS_SLDS_SIZE_1_OF_2);
        } else {
            lifeStatusDiv.classList.remove(CSS_CLASS_SLDS_SIZE_1_OF_2);
        }

        this.displaySpinner = false;
    }

    _initializeFieldLabels(data) {
        this.label.PMHR_FieldDeathLevel = data.fields[FIELD_POKEMON_DEATH_LEVEL.fieldApiName].label;
        this.label.PMHR_FieldDeathReason = data.fields[FIELD_POKEMON_CAUSE_OF_DEATH.fieldApiName].label;
    }
}