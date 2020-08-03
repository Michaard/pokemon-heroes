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
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
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
        System.assertEquals(pokedexNumber, pokemonData.Pokedex_Number__c);
        System.assertEquals(form, pokemonData.Family__c);
        System.assertEquals(familyStage, Integer.valueOf(pokemonData.Family_Stage__c));
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_NORMAL, pokemonData.Primary_Type__c);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, pokemonData.Secondary_Type__c);
        System.assertEquals(pictureUrl, pokemonData.Picture_Url__c);
        System.assertEquals(pictureUrl, pokemonData.Picture_Url__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_STANDARD, pokemonData.Evolves_from_Variant__c);
    }

    static testMethod void shouldBuildPokemonAdditionalVariant() {
        //given
        String pictureUrl = 'https://test.picture.com';
        Pokemon_Data__c pokemonForm = new PMHR_PokemonFormBuilder()
                .save();

        //when
        Pokemon_Data__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonForm.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setPictureUrl(pictureUrl)
                .save();

        //then
        additionalVariant = PMHR_PokemonDataQueryService.getAdditionalVariantById(additionalVariant.Id);
        System.assertEquals(pokemonForm.Id, additionalVariant.Variant_Of__c);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, additionalVariant.Region_Specific_Variant__c);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, additionalVariant.Primary_Type__c);
        System.assertEquals(additionalVariant.Variant_Name__c, additionalVariant.Name);
        System.assert(additionalVariant.Name.contains(pokemonForm.Name));
        System.assert(additionalVariant.Name.contains(PMHR_Utilities.REGION_VARIANT_ALOLAN));
    }
}