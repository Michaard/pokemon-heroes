@IsTest
private class PMHR_TriggerHandlerFinalTeam_Test {
    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();

        List<Nuzlocke__c> nuzlockes = new List<Nuzlocke__c>();
        nuzlockes.add(new PMHR_NuzlockeBuilder()
                .setName('Test Nuzlocke')
                .setHero(hero.Id)
                .build()
        );
        nuzlockes.add(new PMHR_NuzlockeBuilder()
                .setName('Test Nuzlocke With Multiple Elite Four Fights')
                .setHero(hero.Id)
                .setMultipleEliteFourFights(true)
                .build()
        );
        insert nuzlockes;
    }

    static testMethod void shouldMarkNuzlockeAsFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        System.assertEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(null, nuzlocke.End_Status__c);
        Nuzlocke__c updatedNuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];
        System.assertNotEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsFinished_MultipleFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        //when
        Test.startTest();
        Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(null, nuzlocke.End_Status__c);
    }

    static testMethod void shouldMarkNuzlockeAsNotFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = false LIMIT 1];

        //when
        Test.startTest();
        Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(nuzlocke.Is_Finished__c);
        System.assertNotEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, nuzlocke.End_Status__c);

        delete newFinalTeam;
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(!nuzlocke.Is_Finished__c);
        System.assertEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(null, nuzlocke.End_Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsNotFinished_ManyFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        Final_Team__c newFinalTeamOne = new PMHR_FinalTeamBuilder()
                .setName('New Final Team One')
                .setNuzlocke(nuzlocke.Id)
                .build();
        Final_Team__c newFinalTeamTwo = new PMHR_FinalTeamBuilder()
                .setName('New Final Team Two')
                .setNuzlocke(nuzlocke.Id)
                .build();

        //when
        Test.startTest();
        insert new List<Final_Team__c> {newFinalTeamOne, newFinalTeamTwo};

        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(false, nuzlocke.Is_Finished__c);
        System.assertEquals(null, nuzlocke.End_Date__c);
        System.assertEquals(null, nuzlocke.End_Status__c);

        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS)
                .save();

        delete newFinalTeamOne;
        Test.stopTest();

        //then
        Nuzlocke__c updatedNuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(true, updatedNuzlocke.Is_Finished__c);
        System.assertNotEquals(null, updatedNuzlocke.End_Date__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, updatedNuzlocke.End_Status__c);
    }

    static testMethod void shouldNotInsertFinalTeam_nuzlockeFinished() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id, End_Date__c, End_Status__c FROM Nuzlocke__c LIMIT 1];
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                .save();

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(nuzlocke.Is_Finished__c);
        System.assert(errorOccurred);
        System.assertEquals(0, [SELECT Count() FROM Final_Team__c]);
    }
}