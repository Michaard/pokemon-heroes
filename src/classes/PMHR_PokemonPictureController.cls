public class PMHR_PokemonPictureController {
    @AuraEnabled
    public static PokemonPicture getPokemonPicture(Id pokemonId) {
        Pokemon__c pokemon = getPokemonData(pokemonId);
        return new PokemonPicture(pokemon);
    }

    private static Pokemon__c getPokemonData(Id pokemonId) {
        return [
                SELECT Id, Variant__c,
                        Form__r.Picture_Url__c, Form__r.Type__c,
                        Form__r.Alolan_Picture_Url__c, Form__r.Alolan_Type__c,
                        Form__r.Galarian_Picture_Url__c, Form__r.Galarian_Type__c
                FROM Pokemon__c
                WHERE Id = :pokemonId
                LIMIT 1];
    }

    private Class PokemonPicture {
        @AuraEnabled public String pictureUrl { get; private set; }
        @AuraEnabled public String pokemonType { get; private set; }

        public PokemonPicture (Pokemon__c pokemon) {
            PMHR_PokemonPictureVariantsConfig config = PMHR_PokemonPictureVariantsConfig.getInstance();
            this.pictureUrl = (String)pokemon.Form__r.get(config.getPictureFieldApiName(pokemon.Variant__c));
            this.pokemonType = (String)pokemon.Form__r.get(config.getTypeFieldApiName(pokemon.Variant__c));
        }
    }
}