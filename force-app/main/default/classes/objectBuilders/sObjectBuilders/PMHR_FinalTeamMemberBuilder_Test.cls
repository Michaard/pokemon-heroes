@IsTest
private class PMHR_FinalTeamMemberBuilder_Test {
    static testMethod void shouldBuildFinalTeamMember() {
        //given
        String ability = 'Blaze';
        String nature = 'Calm';
        String heldItem = 'Quick Claw';
        Integer level = 65;
        String move1 = 'Tackle';
        String move2 = 'Flamethrower';
        String move3 = 'Toxic';
        String move4 = 'Roar';

        Map<Integer, String> moves = new Map<Integer, String> {
                1 => move1,
                2 => move2,
                3 => move3,
                4 => move4
        };

        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        PMHR_PokemonData__c pokemonData = new PMHR_PokemonFormBuilder()
                .save();
        PMHR_Pokemon__c pokemon = new PMHR_PokemonBuilder()
                .setNuzlocke(nuzlocke.Id)
                .setCaughtForm(pokemonData.Id)
                .save();
        PMHR_FinalTeam__c finalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        //when
        PMHR_FinalTeamMember__c member = new PMHR_FinalTeamMemberBuilder()
                .setPokemon(pokemon.Id)
                .setFinalTeam(finalTeam.Id)
                .setAbility(ability)
                .setNature(nature)
                .setHeldItem(heldItem)
                .setLevel(level)
                .setMoves(moves)
                .save();

        //then
        member = PMHR_FinalTeamMemberQueryService.getFinalTeamMemberById(member.Id);
        System.assertEquals(pokemon.Id, member.Pokemon__c);
        System.assertEquals(finalTeam.Id, member.FinalTeam__c);
        System.assertEquals(ability, member.Ability__c);
        System.assertEquals(nature, member.Nature__c);
        System.assertEquals(heldItem, member.HeldItem__c);
        System.assertEquals(level, Integer.valueOf(member.Level__c));
        System.assertEquals(move1, member.Move1__c);
        System.assertEquals(move2, member.Move2__c);
        System.assertEquals(move3, member.Move3__c);
        System.assertEquals(move4, member.Move4__c);
    }

    static testMethod void shouldThrowExceptionToManyMoves() {
        //given
        Map<Integer, String> moves = new Map<Integer, String> {
                1 => 'move1',
                2 => 'move2',
                3 => 'move3',
                4 => 'move4',
                5 => 'move5'
        };
        Boolean errorOccurred = false;

        //when
        try {
            PMHR_FinalTeamMember__c member = new PMHR_FinalTeamMemberBuilder()
                    .setMoves(moves)
                    .build();
        } catch (PMHR_FinalTeamMemberBuilder.InvalidNumberOfMovesException ex) {
            errorOccurred = true;
        }

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldThrowExceptionToNullMoves() {
        //given
        Boolean errorOccurred = false;

        //when
        try {
            PMHR_FinalTeamMember__c member = new PMHR_FinalTeamMemberBuilder()
                    .setMoves(null)
                    .build();
        } catch (PMHR_FinalTeamMemberBuilder.InvalidNumberOfMovesException ex) {
            errorOccurred = true;
        }

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldThrowExceptionInvalidMoveNumber() {
        //given
        Map<Integer, String> moves = new Map<Integer, String> {
                5 => 'move5'
        };
        Boolean errorOccurred = false;

        //when
        try {
            PMHR_FinalTeamMember__c member = new PMHR_FinalTeamMemberBuilder()
                    .setMoves(moves)
                    .build();
        } catch (PMHR_FinalTeamMemberBuilder.InvalidMoveNumberException ex) {
            errorOccurred = true;
        }

        //then
        System.assert(errorOccurred);
    }
}