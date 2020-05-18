@IsTest
private class PMHR_PokemonDataBuilder_Test {
    static testMethod void shouldBuildPokemonData() {
        //given
        String form = 'Bulbasaur';
        String pokedexNumber = '001';
        Integer familyStage = 1;
        String pictureUrl = 'https://test.picture.com';

        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();

        //when
        Pokemon_Data__c pokemonData = new PMHR_PokemonDataBuilder()
                .setPokedexNumber(pokedexNumber)
                .setForm(form)
                .setFamily(form)
                .setFamilyStage(familyStage)
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_NORMAL)
                .setSecondaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setPictureUrl(pictureUrl)
                .setRegionSpecificVariants(regionSpecificVariants)
                .save();

        //then
        pokemonData = PMHR_PokemonDataQueryService.getPokemonDataById(pokemonData.Id);
        System.assertEquals(form, pokemonData.Name);
        System.assertEquals(pokedexNumber, pokemonData.Pokedex_Number__c);
        System.assertEquals(form, pokemonData.Family__c);
        System.assertEquals(familyStage, Integer.valueOf(pokemonData.Family_Stage__c));
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_NORMAL, pokemonData.Primary_Type__c);
        System.assertEquals(PMHR_PokemonDataBuilder.TYPE_DARK, pokemonData.Secondary_Type__c);
        System.assertEquals(pictureUrl, pokemonData.Picture_Url__c);
        System.assertEquals(pictureUrl, pokemonData.Picture_Url__c);
        for (String variant : regionSpecificVariants) {
            System.assert(pokemonData.Region_Specific_Variants__c.contains(variant));
        }
    }

    static testMethod void shouldThrowExceptionNullRegionVariants() {
        //given
        Boolean errorOccurred = false;

        //when
        try {
            Pokemon_Data__c pokemonData = new PMHR_PokemonDataBuilder()
                    .setRegionSpecificVariants(null)
                    .build();
        } catch (PMHR_PokemonDataBuilder.NullRegionSpecificVariantsException ex) {
            errorOccurred = true;
        }

        //then
        System.assert(errorOccurred);
    }
}