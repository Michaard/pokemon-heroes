@IsTest private class PMHR_EvolvePokemonControllerTest {
    private static final String FAMILY_ONE = 'Family 1';
    private static final String FAMILY_TWO = 'Family 2';

    @TestSetup static void setup() {
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();

        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<PMHR_PokemonData__c> pokemonData = new List<PMHR_PokemonData__c>();
        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();
        regionSpecificVariants.remove(0);
        Integer stage = 1;
        for (Integer i = 0; i < 4; i++) {
            if (stage > 3) {
                stage = 3;
            }
            PMHR_PokemonData__c pokemonForm = new PMHR_PokemonFormBuilder()
                    .setPokedexNumber('00' + (i + 1))
                    .setForm('Testor v' + i)
                    .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_NORMAL)
                    .setFamily(FAMILY_ONE)
                    .setFamilyStage(stage++)
                    .build();
            pokemonData.add(pokemonForm);
        }
        pokemonData.add(new PMHR_PokemonFormBuilder()
                .setPokedexNumber('005')
                .setForm('Alestor')
                .setPrimaryType(PMHR_PokemonDataBuilder.TYPE_DARK)
                .setFamily(FAMILY_TWO)
                .setFamilyStage(1)
                .build()
        );
        insert pokemonData;

        List<PMHR_PokemonData__c> pokemonAdditionalVariants = new List<PMHR_PokemonData__c>();
        for (PMHR_PokemonData__c pokemonForm : pokemonData) {
            for (String variant : regionSpecificVariants) {
                pokemonAdditionalVariants.add(new PMHR_PokemonAdditionalVariantBuilder()
                        .setVariantOf(pokemonForm.Id)
                        .setRegionSpecificVariant(variant)
                        .setEvolvesFromVariant(variant)
                        .build()
                );
            }
        }
        insert pokemonAdditionalVariants;

        List<PMHR_Pokemon__c> pokemons = new List<PMHR_Pokemon__c>();
        for (Integer i = 0; i < 5; i++) {
            pokemons.add(new PMHR_PokemonBuilder()
                    .setName('Testinho ' + i)
                    .setGender(PMHR_Utilities.GENDER_MALE)
                    .setCaughtForm(pokemonData.get(i).Id)
                    .setCatchMethod(PMHR_PokemonBuilder.CATCH_METHOD_EVENT)
                    .setNuzlocke(nuzlocke.Id)
                    .build()
            );
        }
        insert pokemons;
    }

    static testMethod void shouldGetNextAvailableForms() {
        //given
        List<PMHR_Pokemon__c> pokemons = [SELECT Id, Form__r.Name, Form__r.FamilyStage__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE];

        PMHR_Pokemon__c firstStagePokemon;
        PMHR_Pokemon__c secondStagePokemon;
        PMHR_Pokemon__c thirdStagePokemonOne;
        PMHR_Pokemon__c thirdStagePokemonTwo;

        for (PMHR_Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.FamilyStage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.FamilyStage__c == 2) {
                secondStagePokemon = new PMHR_PokemonBuilder(pokemon)
                        .setRegionSpecificVariant(PMHR_Utilities.REGION_VARIANT_ALOLAN)
                        .save();
            } else {
                if (thirdStagePokemonOne == null) {
                    thirdStagePokemonOne = pokemon;
                } else {
                    thirdStagePokemonTwo = pokemon;
                }
            }
        }

        //when
        Test.startTest();
        List<PMHR_EvolvePokemonController.PokemonNextForm> secondStageForms = PMHR_EvolvePokemonController.getNextAvailableForms(firstStagePokemon.Id);
        List<PMHR_EvolvePokemonController.PokemonNextForm> thirdStageForms = PMHR_EvolvePokemonController.getNextAvailableForms(secondStagePokemon.Id);
        List<PMHR_EvolvePokemonController.PokemonNextForm> forthStageFormsOne = PMHR_EvolvePokemonController.getNextAvailableForms(thirdStagePokemonOne.Id);
        List<PMHR_EvolvePokemonController.PokemonNextForm> forthStageFormsTwo = PMHR_EvolvePokemonController.getNextAvailableForms(thirdStagePokemonTwo.Id);
        Test.stopTest();

        //then
        System.assertEquals(1, secondStageForms.size());
        for (PMHR_EvolvePokemonController.PokemonNextForm nextForm : secondStageForms) {
            System.assertEquals(2, nextForm.familyStage);
        }
        System.assertEquals(2, thirdStageForms.size());
        for (PMHR_EvolvePokemonController.PokemonNextForm nextForm : thirdStageForms) {
            System.assertEquals(3, nextForm.familyStage);
        }
        System.assertEquals(0, forthStageFormsOne.size());
        System.assertEquals(0, forthStageFormsTwo.size());
    }

    static testMethod void shouldNotGetNextAvailableForms_noNextForms() {
        //given
        PMHR_Pokemon__c pokemon = [SELECT Id FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_TWO];

        //when
        Test.startTest();
        List<PMHR_EvolvePokemonController.PokemonNextForm> secondStageForms = PMHR_EvolvePokemonController.getNextAvailableForms(pokemon.Id);
        Test.stopTest();

        //then
        System.assertEquals(0, secondStageForms.size());
    }

    static testMethod void shouldNotGetNextAvailableForms_noPokemons() {
        //given
        PMHR_Pokemon__c pokemon = [SELECT Id, Form__r.FamilyStage__c FROM PMHR_Pokemon__c LIMIT 1];
        delete [SELECT Id FROM PMHR_Pokemon__c];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            List<PMHR_EvolvePokemonController.PokemonNextForm> nextStageForms = PMHR_EvolvePokemonController.getNextAvailableForms(pokemon.Id);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldSetNextPokemonForm() {
        //given
        List<PMHR_Pokemon__c> pokemons = [SELECT Id, Form__r.FamilyStage__c, RegionalVariant__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.FamilyStage__c < 3];

        PMHR_Pokemon__c firstStagePokemon;
        PMHR_Pokemon__c secondStagePokemon;

        for (PMHR_Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.FamilyStage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.FamilyStage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }

        //when
        Test.startTest();
        PMHR_EvolvePokemonController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.RegionalVariant__c);
        Test.stopTest();

        //then
        PMHR_Pokemon__c updatedPokemon = [SELECT Id, Form__r.FamilyStage__c FROM PMHR_Pokemon__c WHERE Id = :firstStagePokemon.Id];
        System.assertEquals(2, updatedPokemon.Form__r.FamilyStage__c);
    }

    static testMethod void shouldNotSetNextPokemonForm_formFamilyDifferent() {
        //given
        PMHR_Pokemon__c firstStagePokemon = [SELECT Id, Form__r.FamilyStage__c, RegionalVariant__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_TWO LIMIT 1];
        PMHR_Pokemon__c secondStagePokemon = [SELECT Id, Form__r.FamilyStage__c, RegionalVariant__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.FamilyStage__c = 2 LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_EvolvePokemonController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.RegionalVariant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldNotSetNextPokemonForm_formStageLower() {
        //given
        List<PMHR_Pokemon__c> pokemons = [SELECT Id, Form__r.FamilyStage__c, RegionalVariant__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.FamilyStage__c < 3];
        Boolean errorOccurred = false;

        PMHR_Pokemon__c firstStagePokemon;
        PMHR_Pokemon__c secondStagePokemon;

        for (PMHR_Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.FamilyStage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.FamilyStage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }

        //when
        Test.startTest();
        try {
            PMHR_EvolvePokemonController.setPokemonForm(secondStagePokemon.Id, firstStagePokemon.Form__c, firstStagePokemon.RegionalVariant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldNotSetNextPokemonForm_noPokemons() {
        //given
        List<PMHR_Pokemon__c> pokemons = [SELECT Id, Form__r.FamilyStage__c, RegionalVariant__c FROM PMHR_Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.FamilyStage__c < 3];

        Boolean errorOccurred = false;

        PMHR_Pokemon__c firstStagePokemon;
        PMHR_Pokemon__c secondStagePokemon;

        for (PMHR_Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.FamilyStage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.FamilyStage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }
        delete [SELECT Id FROM PMHR_Pokemon__c];

        //when
        Test.startTest();
        try {
            PMHR_EvolvePokemonController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.RegionalVariant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }
}