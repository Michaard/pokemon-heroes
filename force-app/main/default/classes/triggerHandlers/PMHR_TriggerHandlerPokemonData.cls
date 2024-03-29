public without sharing class PMHR_TriggerHandlerPokemonData implements ITrigger {
    private Map<Id, PMHR_PokemonData__c> existingPokemonForms;
    private Set<String> existingPokedexNumbers;
    private List<PMHR_PokemonData__c> additionalVariantsToDelete;

    public void bulkBefore() {
        if (!Trigger.isDelete) {
            Set<Id> pokemonDataIds = PMHR_TriggerHandlerPokemonData_Helper.getPokemonDataIds(Trigger.new, PMHR_PokemonData__c.VariantOf__c);
            Set<String> pokemonDataPokedexNumbers = PMHR_TriggerHandlerPokemonData_Helper.getPokemonPokedexNumbers(Trigger.new);
            existingPokemonForms = new Map<Id, PMHR_PokemonData__c>(PMHR_TriggerHandlerPokemonData_Helper.getExistingPokemonData(pokemonDataIds, pokemonDataPokedexNumbers));
        }
        if (Trigger.isInsert) {
            existingPokedexNumbers = PMHR_TriggerHandlerPokemonData_Helper.getPokemonPokedexNumbers(existingPokemonForms.values());
        }
    }

    public void bulkAfter() {
        if (Trigger.isDelete) {
            additionalVariantsToDelete = PMHR_TriggerHandlerPokemonData_Helper.getExistingPokemonAdditionalVariants(new Set<Id> {null});
        }
    }

    public void beforeInsert(SObject so) {
        PMHR_PokemonData__c pokemonData = (PMHR_PokemonData__c) so;
        if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_FORM)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicatePokedexNumber(pokemonData, existingPokedexNumbers);
        } else if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicateRegionSpecificVariant(pokemonData, existingPokemonForms);
            PMHR_TriggerHandlerPokemonData_Helper.copyVariantNameToForm(pokemonData);
        }
    }

    public void afterInsert(SObject so) {}

    public void beforeUpdate(SObject oldSo, SObject so) {
        PMHR_PokemonData__c pokemonData = (PMHR_PokemonData__c) so;
        if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicateRegionSpecificVariant(pokemonData, existingPokemonForms);
            PMHR_TriggerHandlerPokemonData_Helper.copyVariantNameToForm(pokemonData);
        }
    }

    public void afterUpdate(SObject oldSo, SObject so) {}

    public void afterDelete(SObject so) {}

    public void andFinally() {
        if (Trigger.isDelete) {
            if (additionalVariantsToDelete != null && !additionalVariantsToDelete.isEmpty()) {
                delete additionalVariantsToDelete;
            }
        }
    }
}