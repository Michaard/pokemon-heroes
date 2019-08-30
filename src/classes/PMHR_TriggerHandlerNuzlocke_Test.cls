@IsTest
private class PMHR_TriggerHandlerNuzlocke_Test {
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Hero', 'Kanto');
        insert hero;
        insert PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke', Date.today(), hero.Id);
    }

    static testMethod void shouldNotFinishNuzlocke_WithStatusSuccess() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        String errorMessage;

        //when
        Test.startTest();
        try {
            nuzlocke.End_Status__c = PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS;
            nuzlocke.End_Date__c = Date.today();
            update nuzlocke;
        } catch (Exception ex) {
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, Is_Finished__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assert(!nuzlocke.Is_Finished__c);
        System.assert(!String.isEmpty(errorMessage));
        System.assert(errorMessage.contains(Label.Toast_Error_Nuzlocke_Finished_With_Success_Without_Final_Team));
    }

    static testMethod void shouldFinishNuzlocke_WithStatusFailure() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        String errorMessage;

        //when
        Test.startTest();
        try {
            nuzlocke.End_Status__c = PMHR_Utilities.NUZLOCKE_END_STATUS_FAILED;
            nuzlocke.End_Date__c = Date.today();
            update nuzlocke;
        } catch (Exception ex) {
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, Is_Finished__c, End_Status__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assert(nuzlocke.Is_Finished__c);
        System.assertEquals(nuzlocke.End_Status__c, PMHR_Utilities.NUZLOCKE_END_STATUS_FAILED);
        System.assert(String.isEmpty(errorMessage));
    }

    static testMethod void shouldFinishNuzlocke_WithStatusSuccess() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        String errorMessage;

        //when
        Test.startTest();
        try {
            Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);
            insert newFinalTeam;
        } catch (Exception ex) {
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, Is_Finished__c, End_Status__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id];
        System.assert(nuzlocke.Is_Finished__c);
        System.assertEquals(PMHR_Utilities.NUZLOCKE_END_STATUS_SUCCESS, nuzlocke.End_Status__c);
        System.assert(String.isEmpty(errorMessage));
    }

    static testMethod void shouldDeleteNuzlockeRelatedFinalTeam() {
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Final_Team__c newFinalTeam = PMHR_TestDataFactory.createFinalTeamObject('New Final Team', nuzlocke.Id);
        insert newFinalTeam;
        System.assertEquals(1, [SELECT Count() FROM Nuzlocke__c]);
        System.assertEquals(1, [SELECT Count() FROM Final_Team__c]);

        //when
        Test.startTest();
        delete nuzlocke;
        Test.stopTest();

        //then
        System.assertEquals(0, [SELECT Count() FROM Nuzlocke__c]);
        System.assertEquals(0, [SELECT Count() FROM Final_Team__c]);
    }
}