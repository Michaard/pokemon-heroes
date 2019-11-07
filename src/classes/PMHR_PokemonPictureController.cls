public class PMHR_PokemonPictureController {
    @AuraEnabled
    public static PokemonPicture getPokemonPicture(Id pokemonId) {
        Pokemon__c pokemon = getPokemonData(pokemonId);
        PokemonPicture result;
        if (pokemon.Variant__c == PMHR_Utilities.REGION_VARIANT_ALOLAN) {
            result = new PokemonPicture(pokemon.Form__r.Alolan_Picture_Url__c, pokemon.Form__r.Alolan_Type__c);
        } else if (pokemon.Variant__c == PMHR_Utilities.REGION_VARIANT_GALARIAN) {
            result = new PokemonPicture(pokemon.Form__r.Galarian_Picture_Url__c, pokemon.Form__r.Galarian_Type__c);
        } else {
            result = new PokemonPicture(pokemon.Form__r.Picture_Url__c, pokemon.Form__r.Type__c);
        }

        return result;
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

        public PokemonPicture (String pictureUrl, String pokemonType) {
            this.pictureUrl = pictureUrl;
            this.pokemonType = pokemonType;
        }
    }
}