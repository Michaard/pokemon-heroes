@IsTest
private class PMHR_FinalTeamListController_Test {
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Hero', 'Test Region');
        insert hero;

        Nuzlocke__c nuzlocke = PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke', Date.today(), hero.Id);
        insert nuzlocke;

        List<Pokemon_Data__c> pokemonData = new List<Pokemon_Data__c>();
        for (Integer i = 0; i < 6; i++) {
            pokemonData.add(PMHR_TestDataFactory.createPokemonDataObject('00' + (i + 1), 'Testor v' + i, 'Normal', 'Testor v' + i, 1));
        }
        insert pokemonData;

        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        for (Integer i = 0; i < 6; i++) {
            pokemons.add(PMHR_TestDataFactory.createPokemonObject('Testinho ' + i, PMHR_Utilities.GENDER_MALE, pokemonData.get(i).Id, 'Any', nuzlocke.Id));
        }
        insert pokemons;

        Final_Team__c finalTeam = PMHR_TestDataFactory.createFinalTeamObject('Test Final Team', nuzlocke.Id);
        insert finalTeam;

        List<Final_Team_Member__c> finalTeamMembers = new List<Final_Team_Member__c>();
        for (Integer i = 0; i < 6; i++) {
            finalTeamMembers.add(PMHR_TestDataFactory.createFinalTeamMemberObject(finalTeam.Id,pokemons.get(0).Id));
        }
        insert finalTeamMembers;
    }

    static testMethod void shouldGetFinalTeamInfo() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Final_Team__c finalTeam = [SELECT Id, Name FROM Final_Team__c LIMIT 1];

        //when
        Test.startTest();
        List<PMHR_FinalTeamListController.FinalTeam> finalTeamWrappers = PMHR_FinalTeamListController.getFinalTeamInfo(nuzlocke.Id);
        Test.stopTest();

        //then
        System.assert(!finalTeamWrappers.isEmpty());
        PMHR_FinalTeamListController.FinalTeam finalTeamWrapper = finalTeamWrappers.get(0);
        System.assertEquals(finalTeam.Id, finalTeamWrapper.id);
        System.assertEquals(finalTeam.Name, finalTeamWrapper.name);
        System.assertEquals(6, finalTeamWrapper.members.size());
    }

    static testMethod void shouldNotGetFinalTeamInfo_noFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        delete [SELECT Id, Name FROM Final_Team__c];

        //when
        Test.startTest();
        List<PMHR_FinalTeamListController.FinalTeam> finalTeamWrappers = PMHR_FinalTeamListController.getFinalTeamInfo(nuzlocke.Id);
        Test.stopTest();

        //then
        System.assert(finalTeamWrappers.isEmpty());
    }
}