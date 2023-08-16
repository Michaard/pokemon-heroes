@IsTest
private class PMHR_TriggerHandlerFinalTeam_Test {
    @TestSetup static void setup() {
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();

        List<PMHR_Nuzlocke__c> nuzlockes = new List<PMHR_Nuzlocke__c>();
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
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        System.assertEquals(null, nuzlocke.EndDate__c);
        System.assertEquals(null, nuzlocke.Status__c);
        PMHR_Nuzlocke__c updatedNuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c LIMIT 1];
        System.assertNotEquals(null, updatedNuzlocke.EndDate__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, updatedNuzlocke.Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsFinished_MultipleFinalTeams() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        //when
        Test.startTest();
        PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(null, nuzlocke.EndDate__c);
        System.assertEquals(null, nuzlocke.Status__c);
    }

    static testMethod void shouldMarkNuzlockeAsNotFinished() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = false LIMIT 1];

        //when
        Test.startTest();
        PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(nuzlocke.IsFinished__c);
        System.assertNotEquals(null, nuzlocke.EndDate__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, nuzlocke.Status__c);

        delete newFinalTeam;
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(!nuzlocke.IsFinished__c);
        System.assertEquals(null, nuzlocke.EndDate__c);
        System.assertEquals(null, nuzlocke.Status__c);
    }

    static testMethod void shouldNotMarkNuzlockeAsNotFinished_ManyFinalTeams() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c WHERE Multiple_Elite_Four_Fights__c = true LIMIT 1];

        PMHR_FinalTeam__c newFinalTeamOne = new PMHR_FinalTeamBuilder()
                .setName('New Final Team One')
                .setNuzlocke(nuzlocke.Id)
                .build();
        PMHR_FinalTeam__c newFinalTeamTwo = new PMHR_FinalTeamBuilder()
                .setName('New Final Team Two')
                .setNuzlocke(nuzlocke.Id)
                .build();

        //when
        Test.startTest();
        insert new List<PMHR_FinalTeam__c> {newFinalTeamOne, newFinalTeamTwo};

        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(false, nuzlocke.IsFinished__c);
        System.assertEquals(null, nuzlocke.EndDate__c);
        System.assertEquals(null, nuzlocke.Status__c);

        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS)
                .save();

        delete newFinalTeamOne;
        Test.stopTest();

        //then
        PMHR_Nuzlocke__c updatedNuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(true, updatedNuzlocke.IsFinished__c);
        System.assertNotEquals(null, updatedNuzlocke.EndDate__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, updatedNuzlocke.Status__c);
    }

    static testMethod void shouldNotInsertFinalTeam_nuzlockeFinished() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id, EndDate__c, Status__c FROM PMHR_Nuzlocke__c LIMIT 1];
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(Date.today())
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                .save();

        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .save();
        } catch (DmlException ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(nuzlocke.IsFinished__c);
        System.assert(errorOccurred);
        System.assertEquals(0, [SELECT Count() FROM PMHR_FinalTeam__c]);
    }
}