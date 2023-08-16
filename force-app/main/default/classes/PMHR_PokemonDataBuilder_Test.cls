@IsTest
private class PMHR_PokemonDataBuilder_Test {
    static testMethod void shouldBuildPokemonForm() {
        //given
        String form = 'Bulbasaur';
        String pokedexNumber = '001';
        Integer familyStage = 1;
        String pictureUrl = 'https://test.picture.com';

        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();

        //when
        PMHR_PokemonData__c pokemonData = new PMHR_PokemonFormBuilder()
                .setPokedexNumber(pokedexNumber)
                .setForm(form)
                .setFamily(form)
                .setFamilyStage(familyStage)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_NORMAL)
                .setSecondaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setPictureUrl(pictureUrl)
                .setEvolvesFromVariant(PMHR_Utilities.REGION_VARIANT_STANDARD)
                .save();

        //then
        pokemonData = PMHR_PokemonDataQueryService.getPokemonFormById(pokemonData.Id);
        System.assertEquals(form, pokemonData.Name);
        System.assertEquals(pokedexNumber, pokemonData.PokedexNumber__c);
        System.assertEquals(form, pokemonData.Family__c);
        System.assertEquals(familyStage, Integer.valueOf(pokemonData.FamilyStage__c));
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_NORMAL, pokemonData.PrimaryType__c);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, pokemonData.SecondaryType__c);
        System.assertEquals(pictureUrl, pokemonData.PictureUrl__c);
        System.assertEquals(pictureUrl, pokemonData.PictureUrl__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_STANDARD, pokemonData.EvolvesFromVariant__c);
    }

    static testMethod void shouldBuildPokemonAdditionalVariant() {
        //given
        String pictureUrl = 'https://test.picture.com';
        PMHR_PokemonData__c pokemonForm = new PMHR_PokemonFormBuilder()
                .save();

        //when
        PMHR_PokemonData__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonForm.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setPictureUrl(pictureUrl)
                .save();

        //then
        additionalVariant = PMHR_PokemonDataQueryService.getAdditionalVariantById(additionalVariant.Id);
        System.assertEquals(pokemonForm.Id, additionalVariant.VariantOf__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, additionalVariant.RegionalVariant__c);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, additionalVariant.PrimaryType__c);
        System.assertEquals(additionalVariant.VariantName__c, additionalVariant.Name);
        System.assert(additionalVariant.Name.contains(pokemonForm.Name));
        System.assert(additionalVariant.Name.contains(PMHR_Utilities.REGION_VARIANT_ALOLAN));
    }
}