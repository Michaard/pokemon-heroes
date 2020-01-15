@IsTest
private class PMHR_TriggerHandlerPokemon_Test {
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Hero', 'Test Region');
        insert hero;

        Nuzlocke__c nuzlocke = PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke', Date.today(), hero.Id);
        insert nuzlocke;

        List<Pokemon_Data__c> pokemonData = new List<Pokemon_Data__c>();
        for (Integer i = 0; i < 2; i++) {
            pokemonData.add(PMHR_TestDataFactory.createPokemonDataObject('00' + (i + 1), 'Testor v' + i, 'Normal', 'Testor', i + 1));
        }

        pokemonData.add(PMHR_TestDataFactory.createPokemonDataObject('003', 'Alestor', 'Dark', 'Alestor', 1));

        insert pokemonData;
    }

    static testMethod void shouldCopyCaughtFormToFormOnInsert() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        Pokemon__c newPokemon = PMHR_TestDataFactory.createPokemonObject('New', PMHR_Utilities.GENDER_MALE, form.Id, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, nuzlocke.Id);

        //when
        Test.startTest();
        insert newPokemon;
        Test.stopTest();

        //then
        Pokemon__c insertedPokemon = [SELECT Caught_Form__c, Form__c FROM Pokemon__c LIMIT 1];
        System.assertEquals(insertedPokemon.Caught_Form__c, insertedPokemon.Form__c);
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

        Pokemon__c newPokemon = PMHR_TestDataFactory.createPokemonObject('New', PMHR_Utilities.GENDER_MALE, firstStageForm.Id, secondStageForm.Id, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, nuzlocke.Id, null);

        //when
        Test.startTest();
        insert newPokemon;
        Test.stopTest();

        //then
        Pokemon__c insertedPokemon = [SELECT Caught_Form__c, Form__c FROM Pokemon__c LIMIT 1];
        System.assertNotEquals(insertedPokemon.Caught_Form__c, insertedPokemon.Form__c);
        System.assertEquals(insertedPokemon.Caught_Form__c, firstStageForm.Id);
        System.assertEquals(insertedPokemon.Form__c, secondStageForm.Id);
    }

    static testMethod void shouldNotInsertPokemon_nuzlockeFinished() {
        //given
        Pokemon_Data__c form = [SELECT Id FROM Pokemon_Data__c LIMIT 1];
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        nuzlocke.End_Date__c = Date.today();
        nuzlocke.End_Status__c = PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS;

        Pokemon__c newPokemon = PMHR_TestDataFactory.createPokemonObject('New', PMHR_Utilities.GENDER_MALE, form.Id, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, nuzlocke.Id);
        String errorMessage;

        //when
        Test.startTest();
        try {
            update nuzlocke;
            insert newPokemon;
        } catch (DmlException ex) {
            errorMessage = ex.getDmlMessage(0);
        }
        Test.stopTest();

        //then
        System.assert(!String.isEmpty(errorMessage));
        System.assertEquals(0, [SELECT Count() FROM Pokemon__c]);
    }
}