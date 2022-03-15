public without sharing class PMHR_TriggerHandlerPokemonData implements iTrigger {
    private Map<Id, Pokemon_Data__c> existingPokemonForms;
    private Set<String> existingPokedexNumbers;
    private List<Pokemon_Data__c> additionalVariantsToDelete;
    private List<String> testStringList;

    public void bulkBefore() {
        if (!Trigger.isDelete) {
            Set<Id> pokemonDataIds = PMHR_TriggerHandlerPokemonData_Helper.getPokemonDataIds(Trigger.new, Pokemon_Data__c.Variant_Of__c);
            Set<String> pokemonDataPokedexNumbers = PMHR_TriggerHandlerPokemonData_Helper.getPokemonPokedexNumbers(Trigger.new);
            existingPokemonForms = new Map<Id, Pokemon_Data__c>(PMHR_TriggerHandlerPokemonData_Helper.getExistingPokemonData(pokemonDataIds, pokemonDataPokedexNumbers));
        }
        if (Trigger.isInsert) {
            existingPokedexNumbers = PMHR_TriggerHandlerPokemonData_Helper.getPokemonPokedexNumbers(existingPokemonForms.values());
        }
    }

    public void bulkAfter() {
        testStringList = new List<String>();
        if (Trigger.isDelete) {
            additionalVariantsToDelete = PMHR_TriggerHandlerPokemonData_Helper.getExistingPokemonAdditionalVariants(new Set<Id> {null});
        }
    }

    public void beforeInsert(SObject so) {
        Pokemon_Data__c pokemonData = (Pokemon_Data__c) so;
        if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_FORM)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicatePokedexNumber(pokemonData, existingPokedexNumbers);
        } else if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicateRegionSpecificVariant(pokemonData, existingPokemonForms);
            PMHR_TriggerHandlerPokemonData_Helper.copyVariantNameToForm(pokemonData);
        }
    }

    public void afterInsert(SObject so) {
        testStringList.add('afterInsert ' + so.get('Name'));
    }

    public void beforeUpdate(SObject oldSo, SObject so) {
        Pokemon_Data__c pokemonData = (Pokemon_Data__c) so;
        if (pokemonData.RecordTypeId == PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)) {
            PMHR_TriggerHandlerPokemonData_Helper.validateDuplicateRegionSpecificVariant(pokemonData, existingPokemonForms);
            PMHR_TriggerHandlerPokemonData_Helper.copyVariantNameToForm(pokemonData);
        }
    }

    public void afterUpdate(SObject oldSo, SObject so) {
        testStringList.add('afterUpdate ' + so.get('Name'));
    }

    public void afterDelete(SObject so) {
        testStringList.add('afterDelete ' + so.get('Name'));
    }

    public void andFinally() {
        System.debug('testStringList >> ' + testStringList);
        if (Trigger.isDelete) {
            if (additionalVariantsToDelete != null && !additionalVariantsToDelete.isEmpty()) {
                delete additionalVariantsToDelete;
            }
        }
    }
}