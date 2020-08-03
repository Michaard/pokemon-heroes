@IsTest
private class PMHR_TriggerHandlerPokemonData_Test {
    static testMethod void shouldCopyVariantNameToForm() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .setForm('Test Data')
                .setFamily('Test Data')
                .setFamilyStage(1)
                .setPokedexNumber('000')
                .save();

        //when
        Test.startTest();
        Pokemon_Data__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .setVariantOf(pokemonData.Id)
                .save();
        Test.stopTest();

        //then
        additionalVariant = PMHR_PokemonDataQueryService.getAdditionalVariantById(additionalVariant.Id);
        System.assertEquals(additionalVariant.Name, additionalVariant.Variant_Name__c);
        System.assert(additionalVariant.Variant_Name__c.contains(pokemonData.Name));
        System.assert(additionalVariant.Variant_Name__c.contains(PMHR_Utilities.REGION_VARIANT_ALOLAN));
    }

    static testMethod void shouldNotCopyVariantNameToForm() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .setForm('Test Data')
                .setFamily('Test Data')
                .setFamilyStage(1)
                .setPokedexNumber('000')
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        //then
        pokemonData = PMHR_PokemonDataQueryService.getPokemonFormById(pokemonData.Id);
        System.assert(!pokemonData.Name.contains(PMHR_Utilities.REGION_VARIANT_ALOLAN));
    }

    static testMethod void shouldNotCreatePokemonFormDuplicatePokedexNumber() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        Boolean errorOccured = false;

        //when
        Test.startTest();
        try {
            new PMHR_PokemonFormBuilder()
                    .save();
        } catch (Exception ex) {
            errorOccured = true;
        }
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT Count() FROM Pokemon_Data__c]);
        System.assert(errorOccured);
    }

    static testMethod void shouldNotUpdatePokemonFormNotEditablePokedexNumber() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        Boolean errorOccured = false;

        //when
        Test.startTest();
        try {
            pokemonData = new PMHR_PokemonFormBuilder(pokemonData)
                    .setPokedexNumber('002')
                    .save();
        } catch (Exception ex) {
            errorOccured = true;
        }
        Test.stopTest();

        //then
        Pokemon_Data__c updatedPokemonData = PMHR_PokemonDataQueryService.getPokemonFormById(pokemonData.Id);
        System.assertNotEquals(pokemonData.Pokedex_Number__c, updatedPokemonData.Pokedex_Number__c);
        System.assert(errorOccured);
    }

    static testMethod void shouldNotCreatePokemonAdditionalVariantDuplicateVariant() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .save();
        Boolean errorOccured = false;

        //when
        Test.startTest();
        try {
            new PMHR_PokemonAdditionalVariantBuilder()
                    .setVariantOf(pokemonData.Id)
                    .save();
        } catch (Exception ex) {
            errorOccured = true;
        }
        Test.stopTest();

        //then
        System.assertEquals(2, [SELECT Count() FROM Pokemon_Data__c]);
        System.assert(errorOccured);
    }

    static testMethod void shouldNotUpdatePokemonAdditionalVariantDuplicateVariant() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        Pokemon_Data__c additionalVariantAlolan = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .build();
        Pokemon_Data__c additionalVariantGalarian = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_GALARIAN)
                .build();
        insert new List<Pokemon_Data__c>{additionalVariantAlolan, additionalVariantGalarian};
        Boolean errorOccured = false;

        //when
        Test.startTest();
        try {
            additionalVariantGalarian = new PMHR_PokemonAdditionalVariantBuilder(additionalVariantGalarian)
                    .setVariantOf(pokemonData.Id)
                    .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                    .save();
        } catch (Exception ex) {
            errorOccured = true;
        }
        Test.stopTest();

        //then
        additionalVariantGalarian = PMHR_PokemonDataQueryService.getAdditionalVariantById(additionalVariantGalarian.Id);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_GALARIAN, additionalVariantGalarian.Region_Specific_Variant__c);
        System.assert(errorOccured);
    }

    static testMethod void shouldDeleteAdditionalVariants() {
        //given
        Pokemon_Data__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        Pokemon_Data__c additionalVariantAlolan = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .build();
        Pokemon_Data__c additionalVariantGalarian = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(pokemonData.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_GALARIAN)
                .build();
        insert new List<Pokemon_Data__c>{additionalVariantAlolan, additionalVariantGalarian};

        //when
        Test.startTest();
        delete pokemonData;
        Test.stopTest();

        //then
        System.assertEquals(0, [SELECT Count() FROM Pokemon_Data__c]);
    }
}