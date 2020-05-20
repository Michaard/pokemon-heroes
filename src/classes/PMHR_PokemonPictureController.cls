public class PMHR_PokemonPictureController {
    @AuraEnabled
    public static PokemonPicture getPokemonPicture(Id pokemonId) {
        Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
        Pokemon_Data__c pokemonForm = PMHR_PokemonDataQueryService.getPokemonFormById(pokemon.Form__c);
        return new PokemonPicture(pokemonForm, pokemon.Region_Specific_Variant__c);
    }

    @TestVisible
    private Class PokemonPicture {
        @AuraEnabled public String pictureUrl { get; private set; }
        @AuraEnabled public String pokemonType { get; private set; }

        public PokemonPicture (Pokemon_Data__c pokemonForm, String regionSpecificVariant) {
            if (regionSpecificVariant == PMHR_Utilities.REGION_VARIANT_STANDARD) {
                this.pictureUrl = pokemonForm.Picture_Url__c;
                this.pokemonType = pokemonForm.Type__c;
            } else {
                this.setFieldsFromAdditionalVariant(pokemonForm.Additional_Variants__r, regionSpecificVariant);
            }
        }

        private void setFieldsFromAdditionalVariant(List<Pokemon_Data__c> additionalVariants, String regionSpecificVariant) {
            for (Pokemon_Data__c additionalForm : additionalVariants) {
                if (additionalForm.Region_Specific_Variant__c == regionSpecificVariant) {
                    this.pictureUrl = additionalForm.Picture_Url__c;
                    this.pokemonType = additionalForm.Type__c;
                    return;
                }
            }
        }
    }
}