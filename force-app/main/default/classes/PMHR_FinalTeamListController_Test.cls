@IsTest
private class PMHR_FinalTeamListController_Test {
    @TestSetup static void setup() {
        Integer numberOfPokemons = 6;
        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();

        Hero__c hero = new PMHR_HeroBuilder()
                .save();

        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<Pokemon_Data__c> pokemonData = new List<Pokemon_Data__c>();
        PMHR_PokemonFormBuilder pokemonFormBuilder = new PMHR_PokemonFormBuilder();
        for (Integer i = 0; i < numberOfPokemons; i++) {
            pokemonData.add(pokemonFormBuilder
                    .setPokedexNumber('00' + (i + 1))
                    .setForm('Testor v' + i)
                    .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_NORMAL)
                    .setFamily('Testor v' + i)
                    .setFamilyStage(1)
                    .build()
            );
        }
        insert pokemonData;

        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        PMHR_PokemonBuilder pokemonBuilder = new PMHR_PokemonBuilder();
        for (Integer i = 0; i < numberOfPokemons; i++) {
            pokemons.add(pokemonBuilder
                    .setName('Testinho ' + i)
                    .setGender(PMHR_Utilities.GENDER_MALE)
                    .setCaughtForm(pokemonData.get(i).Id)
                    .setNuzlocke(nuzlocke.Id)
                    .build()
            );
        }
        insert pokemons;

        Final_Team__c finalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        List<Final_Team_Member__c> finalTeamMembers = new List<Final_Team_Member__c>();
        for (Integer i = 0; i < numberOfPokemons; i++) {
            finalTeamMembers.add(new PMHR_FinalTeamMemberBuilder()
                    .setFinalTeam(finalTeam.Id)
                    .setPokemon(pokemons.get(i).Id)
                    .build()
            );
        }
        insert finalTeamMembers;
    }

    static testMethod void shouldGetFinalTeamInfo() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Final_Team__c finalTeam = [SELECT Id, Name FROM Final_Team__c LIMIT 1];

        //when
        Test.startTest();
        List<PMHR_FinalTeamListControllerHelper.FinalTeam> finalTeamWrappers = PMHR_FinalTeamListController.getFinalTeamInfo(nuzlocke.Id);
        Test.stopTest();

        //then
        System.assert(!finalTeamWrappers.isEmpty());
        PMHR_FinalTeamListControllerHelper.FinalTeam finalTeamWrapper = finalTeamWrappers.get(0);
        System.assertEquals(finalTeam.Id, finalTeamWrapper.id);
        System.assertEquals(finalTeam.Name, finalTeamWrapper.name);
        System.assertEquals(6, finalTeamWrapper.members.size());
    }

    static testMethod void shouldNotGetFinalTeamInfo_noFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        delete [SELECT Id FROM Final_Team__c];

        //when
        Test.startTest();
        List<PMHR_FinalTeamListControllerHelper.FinalTeam> finalTeamWrappers = PMHR_FinalTeamListController.getFinalTeamInfo(nuzlocke.Id);
        Test.stopTest();

        //then
        System.assert(finalTeamWrappers.isEmpty());
    }
}