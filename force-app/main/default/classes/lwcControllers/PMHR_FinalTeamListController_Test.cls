@IsTest
private class PMHR_FinalTeamListController_Test {
    @TestSetup static void setup() {
        Integer numberOfPokemons = 6;
        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();

        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();

        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<PMHR_PokemonData__c> pokemonData = new List<PMHR_PokemonData__c>();
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

        List<PMHR_Pokemon__c> pokemons = new List<PMHR_Pokemon__c>();
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

        PMHR_FinalTeam__c finalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        List<PMHR_FinalTeamMember__c> finalTeamMembers = new List<PMHR_FinalTeamMember__c>();
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
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        PMHR_FinalTeam__c finalTeam = [SELECT Id, Name FROM PMHR_FinalTeam__c LIMIT 1];

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
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        delete [SELECT Id FROM PMHR_FinalTeam__c];

        //when
        Test.startTest();
        List<PMHR_FinalTeamListControllerHelper.FinalTeam> finalTeamWrappers = PMHR_FinalTeamListController.getFinalTeamInfo(nuzlocke.Id);
        Test.stopTest();

        //then
        System.assert(finalTeamWrappers.isEmpty());
    }
}