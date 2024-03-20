@IsTest
private class PMHR_TriggerHandlerPokemon_Test {
    @TestSetup static void setup() {
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();

        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<PMHR_PokemonData__c> pokemonData = new List<PMHR_PokemonData__c>();
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
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(form.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        newPokemon = [SELECT CaughtForm__c, Form__c FROM PMHR_Pokemon__c LIMIT 1];
        System.assertEquals(newPokemon.CaughtForm__c, newPokemon.Form__c);
    }

    static testMethod void shouldNotCopyCaughtFormToFormOnInsert_formProvided() {
        //given
        List<PMHR_PokemonData__c> forms = [SELECT Id, FamilyStage__c FROM PMHR_PokemonData__c WHERE Family__c = 'Testor' LIMIT 2];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];

        PMHR_PokemonData__c firstStageForm;
        PMHR_PokemonData__c secondStageForm;

        for (PMHR_PokemonData__c form : forms) {
            if (form.FamilyStage__c == 1) {
                firstStageForm = form;
            } else {
                secondStageForm = form;
            }
        }

        //when
        Test.startTest();
        PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setCaughtForm(firstStageForm.Id)
                .setForm(secondStageForm.Id)
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        newPokemon = [SELECT CaughtForm__c, Form__c FROM PMHR_Pokemon__c LIMIT 1];
        System.assertNotEquals(newPokemon.CaughtForm__c, newPokemon.Form__c);
        System.assertEquals(newPokemon.CaughtForm__c, firstStageForm.Id);
        System.assertEquals(newPokemon.Form__c, secondStageForm.Id);
    }

    static testMethod void shouldNotInsertPokemon_nuzlockeFinished() {
        //given
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                .save();

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .setCaughtForm(form.Id)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
        System.assertEquals(0, [SELECT Count() FROM PMHR_Pokemon__c]);
    }

    static testMethod void shouldInsertPokemon_allowedVariant() {
        //given
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        PMHR_PokemonData__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();

        //when
        Test.startTest();
        PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT Count() FROM PMHR_Pokemon__c]);
    }

    static testMethod void shouldNotInsertPokemon_forbiddenVariant() {
        //given
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
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
        System.assertEquals(0, [SELECT Count() FROM PMHR_Pokemon__c]);
    }

    static testMethod void shouldUpdatePokemon_allowedVariant() {
        //given
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        PMHR_PokemonData__c additionalVariant = new PMHR_PokemonAdditionalVariantBuilder()
                .setVariantOf(form.Id)
                .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                .save();
        PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
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
        System.assertEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, newPokemon.RegionalVariant__c);
    }

    static testMethod void shouldNotUpdatePokemon_forbiddenVariant() {
        //given
        PMHR_PokemonData__c form = [SELECT Id FROM PMHR_PokemonData__c LIMIT 1];
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        PMHR_Pokemon__c newPokemon = new PMHR_PokemonBuilder()
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
        System.assertNotEquals(PMHR_Utilities.REGION_VARIANT_ALOLAN, newPokemon.RegionalVariant__c);
    }
}