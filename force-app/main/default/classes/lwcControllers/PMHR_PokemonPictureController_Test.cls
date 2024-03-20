@IsTest
private class PMHR_PokemonPictureController_Test {
    private static final String STANDARD_PICTURE_URL = 'www.test.com.pl';
    private static final String ADDITIONAL_PICTURE_URL = 'www.test.additional.com.pl';

    @TestSetup static void setup() {
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        PMHR_PokemonData__c pokemonData = new PMHR_PokemonFormBuilder()
                .setPictureUrl(STANDARD_PICTURE_URL)
                .save();
        PMHR_PokemonData__c additionalForm = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setPictureUrl(ADDITIONAL_PICTURE_URL)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .save();
        PMHR_Pokemon__c pokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(pokemonData.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
    }

    static testMethod void shouldGetPokemonFormUrl() {
        //given
        PMHR_Pokemon__c pokemon = [SELECT Id, Form__c, RegionalVariant__c, Form__r.PictureUrl__c, Form__r.Type__c FROM PMHR_Pokemon__c LIMIT 1];

        //when
        PMHR_PokemonPictureController.PokemonPicture pictureData = PMHR_PokemonPictureController.getPokemonPicture(pokemon.Id);

        //then
        System.assertEquals(pokemon.Form__r.PictureUrl__c, pictureData.pictureUrl);
        System.assertEquals(pokemon.Form__r.Type__c, pictureData.pokemonType);
    }

    static testMethod void shouldGetPokemonAdditinalVariantUrl() {
        //given
        PMHR_Pokemon__c pokemon = [SELECT Id, Form__c, RegionalVariant__c, Form__r.PictureUrl__c, Form__r.Type__c FROM PMHR_Pokemon__c LIMIT 1];
        pokemon = new PMHR_PokemonBuilder(pokemon)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        //when
        PMHR_PokemonPictureController.PokemonPicture pictureData = PMHR_PokemonPictureController.getPokemonPicture(pokemon.Id);

        //then
        System.assertNotEquals(pokemon.Form__r.PictureUrl__c, pictureData.pictureUrl);
        System.assertNotEquals(pokemon.Form__r.Type__c, pictureData.pokemonType);
        System.assertEquals(ADDITIONAL_PICTURE_URL, pictureData.pictureUrl);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, pictureData.pokemonType);
    }
}