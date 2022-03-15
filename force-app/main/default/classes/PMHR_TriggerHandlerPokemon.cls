public without sharing class PMHR_TriggerHandlerPokemon implements ITrigger {
    private Map<Id, Pokemon_Data__c> relatedPokemonData;

    public void bulkBefore() {
        if (Trigger.isInsert || Trigger.isUpdate) {
            Set<Id> relatedFormsIds = PMHR_Utilities.fetchSObjectListToIdSet(Trigger.new, Pokemon__c.Form__c, false);
            relatedFormsIds.addAll(PMHR_Utilities.fetchSObjectListToIdSet(Trigger.new, Pokemon__c.Caught_Form__c, false));
            relatedPokemonData = new Map<Id, Pokemon_Data__c>(PMHR_TriggerHandlerPokemon_Helper.getRelatedPokemonForms(relatedFormsIds));
        }
    }

    public void bulkAfter() {
    }

    public void beforeInsert(SObject so) {
        Pokemon__c pokemon = (Pokemon__c) so;
        PMHR_TriggerHandlerPokemon_Helper.copyCaughtFormToForm(pokemon);
        PMHR_TriggerHandlerPokemon_Helper.validateRegionSpecificVariant(pokemon, relatedPokemonData);
    }

    public void afterInsert(SObject so) {
    }

    public void beforeUpdate(SObject oldSo, SObject so) {
        Pokemon__c pokemon = (Pokemon__c) so;
        PMHR_TriggerHandlerPokemon_Helper.copyCaughtFormToForm(pokemon);
        PMHR_TriggerHandlerPokemon_Helper.validateRegionSpecificVariant(pokemon, relatedPokemonData);
    }

    public void afterUpdate(SObject oldSo, SObject so) {
    }

    public void afterDelete(SObject so) {
    }

    public void andFinally() {
    }
}