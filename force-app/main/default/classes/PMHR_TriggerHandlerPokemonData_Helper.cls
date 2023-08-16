public with sharing class PMHR_TriggerHandlerPokemonData_Helper {

    public static Set<Id> getPokemonDataIds(List<PMHR_PokemonData__c> pokemonData, SObjectField field) {
        return PMHR_Utilities.fetchSObjectListToIdSet(pokemonData, field, false);
    }

    public static Set<String> getPokemonPokedexNumbers(List<PMHR_PokemonData__c> pokemonData) {
        return PMHR_Utilities.fetchSObjectListToStringSet(pokemonData, PMHR_PokemonData__c.PokedexNumber__c, false);
    }

    public static List<PMHR_PokemonData__c> getExistingPokemonData(Set<Id> pokemonDataIds, Set<String> pokedexNumbers) {
        return PMHR_PokemonDataQueryService.getPokemonFormByIdsOrPokedexNumbers(pokemonDataIds, pokedexNumbers);
    }

    public static List<PMHR_PokemonData__c> getExistingPokemonAdditionalVariants(Set<Id> pokemonDataIds) {
        return PMHR_PokemonDataQueryService.getAdditionalVariantByFormIds(pokemonDataIds);
    }

    public static void validateDuplicatePokedexNumber(PMHR_PokemonData__c pokemonForm, Set<String> existingPokedexNumbers) {
        if (String.isNotBlank(pokemonForm.PokedexNumber__c) && existingPokedexNumbers.contains(pokemonForm.PokedexNumber__c)) {
            pokemonForm.PokedexNumber__c.addError(System.Label.PMHR_Duplicate_Value_Error);
        }
    }

    public static void validateDuplicateRegionSpecificVariant(PMHR_PokemonData__c additionalVariant, Map<Id, PMHR_PokemonData__c> existingPokemonForms) {
        if (String.isNotBlank(additionalVariant.RegionalVariant__c)) {
            PMHR_PokemonData__c pokemonForm = existingPokemonForms.get(additionalVariant.VariantOf__c);
            for (PMHR_PokemonData__c existingAdditionalVariant : pokemonForm.Variants__r) {
                if (existingAdditionalVariant.RegionalVariant__c == additionalVariant.RegionalVariant__c
                        && existingAdditionalVariant.Id != additionalVariant.Id) {
                    additionalVariant.RegionalVariant__c.addError(System.Label.PMHR_Duplicate_Value_Error);
                }
            }
        }
    }

    public static void copyVariantNameToForm(PMHR_PokemonData__c additionalVariant) {
        additionalVariant = new PMHR_PokemonAdditionalVariantBuilder(additionalVariant)
                .setForm(additionalVariant.VariantName__c)
                .build();
    }
}