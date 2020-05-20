@IsTest
private class PMHR_PokemonPictureController_Test {
    private static final String STANDARD_PICTURE_URL = 'www.test.com.pl';
    private static final String ADDITIONAL_PICTURE_URL = 'www.test.additional.com.pl';

    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .setPictureUrl(STANDARD_PICTURE_URL)
                .save();
        Pokemon_Data__c additionalForm = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setPictureUrl(ADDITIONAL_PICTURE_URL)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .save();
        Pokemon__c pokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(pokemonData.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
    }

    static testMethod void shouldGetPokemonFormUrl() {
        //given
        Pokemon__c pokemon = [SELECT Id, Form__c, Region_Specific_Variant__c, Form__r.Picture_Url__c, Form__r.Type__c FROM Pokemon__c LIMIT 1];

        //when
        PMHR_PokemonPictureController.PokemonPicture pictureData = PMHR_PokemonPictureController.getPokemonPicture(pokemon.Id);

        //then
        System.assertEquals(pokemon.Form__r.Picture_Url__c, pictureData.pictureUrl);
        System.assertEquals(pokemon.Form__r.Type__c, pictureData.pokemonType);
    }

    static testMethod void shouldGetPokemonAdditinalVariantUrl() {
        //given
        Pokemon__c pokemon = [SELECT Id, Form__c, Region_Specific_Variant__c, Form__r.Picture_Url__c, Form__r.Type__c FROM Pokemon__c LIMIT 1];
        pokemon = new PMHR_PokemonBuilder(pokemon)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        //when
        PMHR_PokemonPictureController.PokemonPicture pictureData = PMHR_PokemonPictureController.getPokemonPicture(pokemon.Id);

        //then
        System.assertNotEquals(pokemon.Form__r.Picture_Url__c, pictureData.pictureUrl);
        System.assertNotEquals(pokemon.Form__r.Type__c, pictureData.pokemonType);
        System.assertEquals(ADDITIONAL_PICTURE_URL, pictureData.pictureUrl);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, pictureData.pokemonType);
    }
}