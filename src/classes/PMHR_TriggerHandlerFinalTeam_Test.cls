@IsTest
private class PMHR_TriggerHandlerFinalTeam_Test {
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Hero', 'Test Region');
        insert hero;

        List<Nuzlocke__c> nuzlockes = new List<Nuzlocke__c>();
        nuzlockes.add(PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke', Date.today(), hero.Id));
        nuzlockes.add(PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke With Multiple Elite Four Fights', Date.today(), hero.Id, true));
        insert nuzlockes;
    }

    static testMethod void shouldMarkNuzlockeAsFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];

        Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);

        //when
        Test.startTest();
        insert newFinalTeam;
        Test.stopTest();

        //then
        System.assertEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(null, nuzlocke.End_Status__c);
        Nuzlocke__c updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];
        System.assertNotEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsFinished_MultipleFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);

        //when
        Test.startTest();
        insert newFinalTeam;
        Test.stopTest();

        //then
        Nuzlocke__c updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assertEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(null, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldMarkNuzlockeAsNotFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = false LIMIT 1];

        Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);

        //when
        Test.startTest();
        insert newFinalTeam;

        Nuzlocke__c updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assert(updatedNuzlocke.Is_Finished__c);
        System.assertNotEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS, updatedNuzlocke.End_Status__c);

        delete newFinalTeam;
        Test.stopTest();

        //then
        updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assert(!updatedNuzlocke.Is_Finished__c);
        System.assertEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(null, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsNotFinished_ManyFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        Final_Team__c newFinalTeamOne = PMHR_TestDataFactory.createFinalTeamObject('New Final Team One', nuzlocke.Id);
        Final_Team__c newFinalTeamTwo = PMHR_TestDataFactory.createFinalTeamObject('New Final Team Two', nuzlocke.Id);

        List<Final_Team__c> finalTeamsToInsert = new List<Final_Team__c> {newFinalTeamOne, newFinalTeamTwo};

        //when
        Test.startTest();
        insert finalTeamsToInsert;

        Nuzlocke__c updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assertEquals(false, updatedNuzlocke.Is_Finished__c);
        System.assertEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(null, updatedNuzlocke.End_Status__c);

        nuzlocke.End_Date__c = Date.today();
        nuzlocke.End_Status__c = PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS;
        update nuzlocke;

        delete newFinalTeamOne;
        Test.stopTest();

        //then
        updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assertEquals(true, updatedNuzlocke.Is_Finished__c);
        System.assertNotEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldNotInsertFinalTeam_nuzlockeFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];
        nuzlocke.End_Date__c = Date.today();
        nuzlocke.End_Status__c = PMHR_Utilities.NUZLOCKE_END_STATUS_FAILED;

        Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);
        String errorMessage;

        //when
        Test.startTest();
        try {
            update nuzlocke;
            insert newFinalTeam;
        } catch (DmlException ex) {
            errorMessage = ex.getDmlMessage(0);
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assert(nuzlocke.Is_Finished__c);
        System.assert(!String.isEmpty(errorMessage));
        System.assertEquals(0, [SELECT Count() FROM Final_Team__c]);
    }
}