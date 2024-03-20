public class PMHR_PokemonPictureController {
    @AuraEnabled
    public static PokemonPicture getPokemonPicture(Id pokemonId) {
        PMHR_Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
        PMHR_PokemonData__c pokemonForm = PMHR_PokemonDataQueryService.getPokemonFormById(pokemon.Form__c);
        return new PokemonPicture(pokemonForm, pokemon.IsDeceased__c, pokemon.RegionalVariant__c);
    }

    @TestVisible
    private Class PokemonPicture {
        @AuraEnabled public String pictureUrl { get; private set; }
        @AuraEnabled public String pokemonType { get; private set; }
        @AuraEnabled public Boolean isDead { get; private set; }

        public PokemonPicture (PMHR_PokemonData__c pokemonForm, Boolean isDead, String regionSpecificVariant) {
            this.isDead = isDead;
            if (regionSpecificVariant == PMHR_Utilities.REGION_VARIANT_STANDARD) {
                this.pictureUrl = pokemonForm.PictureUrl__c;
                this.pokemonType = pokemonForm.Type__c;
            } else {
                this.setFieldsFromAdditionalVariant(pokemonForm.Variants__r, regionSpecificVariant);
            }
        }

        private void setFieldsFromAdditionalVariant(List<PMHR_PokemonData__c> additionalVariants, String regionSpecificVariant) {
            for (PMHR_PokemonData__c additionalForm : additionalVariants) {
                if (additionalForm.RegionalVariant__c == regionSpecificVariant) {
                    this.pictureUrl = additionalForm.PictureUrl__c;
                    this.pokemonType = additionalForm.Type__c;
                    return;
                }
            }
        }
    }
}