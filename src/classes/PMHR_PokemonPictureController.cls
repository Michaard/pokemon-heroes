public class PMHR_PokemonPictureController {
    @AuraEnabled
    public static PokemonPicture getPokemonPicture(Id pokemonId) {
        Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
        return new PokemonPicture(pokemon);
    }

    @TestVisible
    private Class PokemonPicture {
        @AuraEnabled public String pictureUrl { get; private set; }
        @AuraEnabled public String pokemonType { get; private set; }

        public PokemonPicture (Pokemon__c pokemon) {
            PMHR_PokemonPictureVariantsConfig config = PMHR_PokemonPictureVariantsConfig.getInstance();
            this.pictureUrl = (String)pokemon.Form__r.get(config.getPictureFieldApiName(pokemon.Region_Specific_Variant__c));
            this.pokemonType = (String)pokemon.Form__r.get(config.getTypeFieldApiName(pokemon.Region_Specific_Variant__c));
        }
    }
}