public class PMHR_TriggerHandlerPokemon_Helper {
    public static List<PMHR_PokemonData__c> getRelatedPokemonForms(Set<Id> pokemonDataIds) {
        return PMHR_PokemonDataQueryService.getPokemonFormsByIds(pokemonDataIds);
    }

    public static void copyCaughtFormToForm(PMHR_Pokemon__c pokemon) {
        if (pokemon.Form__c == null) {
            pokemon = new PMHR_PokemonBuilder(pokemon)
                    .setForm(pokemon.CaughtForm__c)
                    .build();
        }
    }

    public static void validateRegionSpecificVariant(PMHR_Pokemon__c pokemon, Map<Id, PMHR_PokemonData__c> relatedPokemonForms) {
        PMHR_PokemonData__c relatedForm = relatedPokemonForms.get(pokemon.Form__c);
        if (!isRegionSpecificVariantAvailable(relatedForm.Variants__r, pokemon.RegionalVariant__c)) {
            pokemon.RegionalVariant__c.addError(String.format(System.Label.PMHR_Error_Forbidden_Form_Variant, new List<String>{pokemon.RegionalVariant__c}));
        }
    }

    private static Boolean isRegionSpecificVariantAvailable(List<PMHR_PokemonData__c> additionalForms, String regionSpecificVariant) {
        if (regionSpecificVariant == PMHR_Utilities.REGION_VARIANT_STANDARD) {
            return true;
        }
        for (PMHR_PokemonData__c additionalForm : additionalForms) {
            if (additionalForm.RegionalVariant__c == regionSpecificVariant) {
                return true;
            }
        }
        return false;
    }
}