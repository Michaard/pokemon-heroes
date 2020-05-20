public class PMHR_TriggerHandlerPokemon_Helper {
    public static List<Pokemon_Data__c> getRelatedPokemonForms(Set<Id> pokemonDataIds) {
        return PMHR_PokemonDataQueryService.getPokemonFormsByIds(pokemonDataIds);
    }

    public static void copyCaughtFormToForm(Pokemon__c pokemon) {
        if (pokemon.Form__c == null) {
            pokemon = new PMHR_PokemonBuilder(pokemon)
                    .setForm(pokemon.Caught_Form__c)
                    .build();
        }
    }

    public static void validateRegionSpecificVariant(Pokemon__c pokemon, Map<Id, Pokemon_Data__c> relatedPokemonForms) {
        Pokemon_Data__c relatedForm = relatedPokemonForms.get(pokemon.Form__c);
        if (!isRegionSpecificVariantAvailable(relatedForm.Additional_Variants__r, pokemon.Region_Specific_Variant__c)) {
            pokemon.Region_Specific_Variant__c.addError(String.format(System.Label.PMHR_Error_Forbidden_Form_Variant, new List<String>{pokemon.Region_Specific_Variant__c}));
        }
    }

    private static Boolean isRegionSpecificVariantAvailable(List<Pokemon_Data__c> additionalForms, String regionSpecificVariant) {
        if (regionSpecificVariant == PMHR_Utilities.REGION_VARIANT_STANDARD) {
            return true;
        }
        for (Pokemon_Data__c additionalForm : additionalForms) {
            if (additionalForm.Region_Specific_Variant__c == regionSpecificVariant) {
                return true;
            }
        }
        return false;
    }
}