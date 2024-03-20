@IsTest
private class PMHR_PokemonBuilder_Test {
    static testMethod void shouldBuildPokemon() {
        //given
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        PMHR_PokemonData__c form = new PMHR_PokemonFormBuilder()
                .save();
        PMHR_PokemonData__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        String name = 'Barry';
        String catchLocation = 'Route 1';
        String deathCause = 'Accident';
        Integer deathLevel = 5;

        //when
        PMHR_Pokemon__c pokemon = new PMHR_PokemonBuilder()
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
        System.assertEquals(form.Id, pokemon.CaughtForm__c);
        System.assertEquals(name, pokemon.Name);
        System.assertEquals(form.Id, pokemon.Form__c);
        System.assertEquals(PMHR_Utilities.GENDER_MALE, pokemon.Gender__c);
        System.assertEquals(catchLocation, pokemon.Location__c);
        System.assertEquals(PMHR_PokemonBuilder.CATCH_METHOD_EVENT, pokemon.CatchMethod__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, pokemon.RegionalVariant__c);
        System.assert(pokemon.IsDeceased__c);
        System.assertEquals(deathCause, pokemon.CauseOfDeath__c);
        System.assertEquals(deathLevel, Integer.valueOf(pokemon.DeathLevel__c));
    }
}