@IsTest
private class PMHR_PokemonPictureController_Test {
    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        Pokemon_Data__c pokemonData = new PMHR_PokemonDataBuilder()
                .setPictureUrl('www.test.com.pl')
                .save();
        Pokemon__c pokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(pokemonData.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
    }

    static testMethod void shouldGetPokemonDataUrl() {
        //given
        Pokemon__c pokemon = [SELECT Id, Form__r.Picture_Url__c, Form__r.Type__c FROM Pokemon__c LIMIT 1];

        //when
        PMHR_PokemonPictureController.PokemonPicture pictureData = PMHR_PokemonPictureController.getPokemonPicture(pokemon.Id);

        //then
        System.assertEquals(pokemon.Form__r.Picture_Url__c, pictureData.pictureUrl);
        System.assertEquals(pokemon.Form__r.Type__c, pictureData.pokemonType);
    }
}