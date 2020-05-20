@IsTest
private class PMHR_PokemonBuilder_Test {
    static testMethod void shouldBuildPokemon() {
        //given
        Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        Pokemon_Data__c form = new PMHR_PokemonFormBuilder()
                .save();
        Pokemon_Data__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        String name = 'Barry';
        String catchLocation = 'Route 1';
        String deathCause = 'Accident';
        Integer deathLevel = 5;

        //when
        Pokemon__c pokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(form.Id)
                .setName(name)
                .setForm(form.Id)
                .setGender(PMHR_Utilities.GENDER_MALE)
                .setCatchLocation(catchLocation)
                .setCatchMethod(PMHR_PokemonBuilder.CATCH_METHOD_EVENT)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        pokemon = new PMHR_PokemonBuilder(pokemon)
                .setDeath(true)
                .setDeathCause(deathCause)
                .setDeathLevel(deathLevel)
                .save();

        //then
        pokemon = PMHR_PokemonQueryService.getPokemonById(pokemon.Id);
        System.assertEquals(nuzlocke.Id, pokemon.Nuzlocke__c);
        System.assertEquals(form.Id, pokemon.Caught_Form__c);
        System.assertEquals(name, pokemon.Name);
        System.assertEquals(form.Id, pokemon.Form__c);
        System.assertEquals(PMHR_Utilities.GENDER_MALE, pokemon.Gender__c);
        System.assertEquals(catchLocation, pokemon.Location__c);
        System.assertEquals(PMHR_PokemonBuilder.CATCH_METHOD_EVENT, pokemon.Catch_Method__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, pokemon.Region_Specific_Variant__c);
        System.assert(pokemon.Death__c);
        System.assertEquals(deathCause, pokemon.Cause_of_Death__c);
        System.assertEquals(deathLevel, Integer.valueOf(pokemon.Death_Level__c));
    }
}