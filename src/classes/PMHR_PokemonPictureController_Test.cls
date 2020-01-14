@IsTest
private class PMHR_PokemonPictureController_Test {
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Hero', 'Kanto');
        insert hero;
        Nuzlocke__c nuzlocke = PMHR_TestDataFactory.createNuzlockeObject('Nuzlocke', Date.today(), hero.Id);
        insert nuzlocke;
        Pokemon_Data__c pokemonData = PMHR_TestDataFactory.createPokemonDataObject('001', 'Test', 'Normal', 'Test', 1);
        pokemonData.Picture_Url__c = 'www.test.com.pl';
        insert pokemonData;
        Pokemon__c pokemon = PMHR_TestDataFactory.createPokemonObject('Testing', PMHR_Utilities.GENDER_MALE, pokemonData.Id, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, nuzlocke.Id);
        insert pokemon;
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