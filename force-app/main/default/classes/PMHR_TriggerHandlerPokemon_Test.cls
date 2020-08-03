@IsTest
private class PMHR_TriggerHandlerPokemon_Test {
    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();

        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<Pokemon_Data__c> pokemonData = new List<Pokemon_Data__c>();
        for (Integer i = 1; i < 3; i++) {
            pokemonData.add(new PMHR_PokemonFormBuilder()
                    .setPokedexNumber('00' + i)
                    .setForm('Testor v' + i)
                    .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_NORMAL)
                    .setFamily('Testor')
                    .setFamilyStage(i)
                    .build()
            );
        }
        pokemonData.add(new PMHR_PokemonFormBuilder()
                .setPokedexNumber('003')
                .setForm('Alestor')
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setFamily('Alestor')
                .setFamilyStage(1)
                .build());
        insert pokemonData;
    }

    static testMethod void shouldCopyCaughtFormToFormOnInsert() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(form.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        newPokemon = [SELECT Caught_Form__c, Form__c FROM Pokemon__c LIMIT 1];
        System.assertEquals(newPokemon.Caught_Form__c, newPokemon.Form__c);
    }

    static testMethod void shouldNotCopyCaughtFormToFormOnInsert_formProvided() {
        //given
        List<Pokemon_Data__c> forms = [SELECT Id, Family_Stage__c FROM Pokemon_Data__c WHERE Family__c = 'Testor' LIMIT 2];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        Pokemon_Data__c firstStageForm;
        Pokemon_Data__c secondStageForm;

        for (Pokemon_Data__c form : forms) {
            if (form.Family_Stage__c == 1) {
                firstStageForm = form;
            } else {
                secondStageForm = form;
            }
        }

        //when
        Test.startTest();
        Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(firstStageForm.Id)
                .setForm(secondStageForm.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        newPokemon = [SELECT Caught_Form__c, Form__c FROM Pokemon__c LIMIT 1];
        System.assertNotEquals(newPokemon.Caught_Form__c, newPokemon.Form__c);
        System.assertEquals(newPokemon.Caught_Form__c, firstStageForm.Id);
        System.assertEquals(newPokemon.Form__c, secondStageForm.Id);
    }

    static testMethod void shouldNotInsertPokemon_nuzlockeFinished() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                .save();

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .setCaughtForm(form.Id)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
        System.assertEquals(0, [SELECT Count() FROM Pokemon__c]);
    }

    static testMethod void shouldInsertPokemon_allowedVariant() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Pokemon_Data__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        //when
        Test.startTest();
        Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT Count() FROM Pokemon__c]);
    }

    static testMethod void shouldNotInsertPokemon_forbiddenVariant() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .setCaughtForm(form.Id)
                    .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
        System.assertEquals(0, [SELECT Count() FROM Pokemon__c]);
    }

    static testMethod void shouldUpdatePokemon_allowedVariant() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Pokemon_Data__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(form.Id)
                .save();

        //when
        Test.startTest();
        newPokemon = new PMHR_PokemonBuilder(newPokemon)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        Test.stopTest();

        //then
        newPokemon = PMHR_PokemonQueryService.getPokemonById(newPokemon.Id);
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, newPokemon.Region_Specific_Variant__c);
    }

    static testMethod void shouldNotUpdatePokemon_forbiddenVariant() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(form.Id)
                .save();

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            newPokemon = new PMHR_PokemonBuilder(newPokemon)
                    .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        newPokemon = PMHR_PokemonQueryService.getPokemonById(newPokemon.Id);
        System.assertNotEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, newPokemon.Region_Specific_Variant__c);
    }
}