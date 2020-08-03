public with sharing class PMHR_TriggerHandlerPokemonData_Helper {

    public static Set<Id> getPokemonDataIds(List<Pokemon_Data__c> pokemonData, SObjectField field) {
        return PMHR_Utilities.fetchSObjectListToIdSet(pokemonData, field, false);
    }

    public static Set<String> getPokemonPokedexNumbers(List<Pokemon_Data__c> pokemonData) {
        return PMHR_Utilities.fetchSObjectListToStringSet(pokemonData, Pokemon_Data__c.Pokedex_Number__c, false);
    }

    public static List<Pokemon_Data__c> getExistingPokemonData(Set<Id> pokemonDataIds, Set<String> pokedexNumbers) {
        return PMHR_PokemonDataQueryService.getPokemonFormByIdsOrPokedexNumbers(pokemonDataIds, pokedexNumbers);
    }

    public static List<Pokemon_Data__c> getExistingPokemonAdditionalVariants(Set<Id> pokemonDataIds) {
        return PMHR_PokemonDataQueryService.getAdditionalVariantByFormIds(pokemonDataIds);
    }

    public static void validateDuplicatePokedexNumber(Pokemon_Data__c pokemonForm, Set<String> existingPokedexNumbers) {
        if (String.isNotBlank(pokemonForm.Pokedex_Number__c) && existingPokedexNumbers.contains(pokemonForm.Pokedex_Number__c)) {
            pokemonForm.Pokedex_Number__c.addError(System.Label.PMHR_Duplicate_Value_Error);
        }
    }

    public static void validateDuplicateRegionSpecificVariant(Pokemon_Data__c additionalVariant, Map<Id, Pokemon_Data__c> existingPokemonForms) {
        if (String.isNotBlank(additionalVariant.Region_Specific_Variant__c)) {
            Pokemon_Data__c pokemonForm = existingPokemonForms.get(additionalVariant.Variant_Of__c);
            for (Pokemon_Data__c existingAdditionalVariant : pokemonForm.Additional_Variants__r) {
                if (existingAdditionalVariant.Region_Specific_Variant__c == additionalVariant.Region_Specific_Variant__c
                        && existingAdditionalVariant.Id != additionalVariant.Id) {
                    additionalVariant.Region_Specific_Variant__c.addError(System.Label.PMHR_Duplicate_Value_Error);
                }
            }
        }
    }

    public static void copyVariantNameToForm(Pokemon_Data__c additionalVariant) {
        additionalVariant = new PMHR_PokemonAdditionalVariantBuilder(additionalVariant)
                .setForm(additionalVariant.Variant_Name__c)
                .build();
    }
}