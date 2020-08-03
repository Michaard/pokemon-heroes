@IsTest
private class PMHR_NextFormController_Test {
    private static final String FAMILY_ONE = 'Family 1';
    private static final String FAMILY_TWO = 'Family 2';

    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();

        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();

        List<Pokemon_Data__c> pokemonData = new List<Pokemon_Data__c>();
        List<String> regionSpecificVariants = PMHR_Utilities.getPokemonRegionalVariantsValues();
        regionSpecificVariants.remove(0);
        Integer stage = 1;
        for (Integer i = 0; i < 4; i++) {
            if (stage > 3) {
                stage = 3;
            }
            Pokemon_Data__c pokemonForm = new PMHR_PokemonFormBuilder()
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

        List<Pokemon_Data__c> pokemonAdditionalVariants = new List<Pokemon_Data__c>();
        for (Pokemon_Data__c pokemonForm : pokemonData) {
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

        List<Pokemon__c> pokemons = new List<Pokemon__c>();
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
        List<Pokemon__c> pokemons = [SELECT Id, Form__r.Name, Form__r.Family_Stage__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE];

        Pokemon__c firstStagePokemon;
        Pokemon__c secondStagePokemon;
        Pokemon__c thirdStagePokemonOne;
        Pokemon__c thirdStagePokemonTwo;

        for (Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.Family_Stage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.Family_Stage__c == 2) {
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
        PMHR_NextFormController.PokemonWithNextForms secondStageForms = PMHR_NextFormController.getNextAvailableForms(firstStagePokemon.Id);
        PMHR_NextFormController.PokemonWithNextForms thirdStageForms = PMHR_NextFormController.getNextAvailableForms(secondStagePokemon.Id);
        PMHR_NextFormController.PokemonWithNextForms forthStageFormsOne = PMHR_NextFormController.getNextAvailableForms(thirdStagePokemonOne.Id);
        PMHR_NextFormController.PokemonWithNextForms forthStageFormsTwo = PMHR_NextFormController.getNextAvailableForms(thirdStagePokemonTwo.Id);
        Test.stopTest();

        //then
        System.assertEquals(1, secondStageForms.nextForms.size());
        for (PMHR_NextFormController.PokemonNextForm nextForm : secondStageForms.nextForms) {
            System.assertEquals(2, nextForm.familyStage);
        }
        System.assertEquals(2, thirdStageForms.nextForms.size());
        for (PMHR_NextFormController.PokemonNextForm nextForm : thirdStageForms.nextForms) {
            System.assertEquals(3, nextForm.familyStage);
        }
        System.assertEquals(0, forthStageFormsOne.nextForms.size());
        System.assertEquals(0, forthStageFormsTwo.nextForms.size());
    }

    static testMethod void shouldNotGetNextAvailableForms_noNextForms() {
        //given
        Pokemon__c pokemon = [SELECT Id FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_TWO];

        //when
        Test.startTest();
        PMHR_NextFormController.PokemonWithNextForms secondStageForms = PMHR_NextFormController.getNextAvailableForms(pokemon.Id);
        Test.stopTest();

        //then
        System.assertEquals(0, secondStageForms.nextForms.size());
    }

    static testMethod void shouldNotGetNextAvailableForms_noPokemons() {
        //given
        Pokemon__c pokemon = [SELECT Id, Form__r.Family_Stage__c FROM Pokemon__c LIMIT 1];
        delete [SELECT Id FROM Pokemon__c];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_NextFormController.PokemonWithNextForms nextStageForms = PMHR_NextFormController.getNextAvailableForms(pokemon.Id);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldSetNextPokemonForm() {
        //given
        List<Pokemon__c> pokemons = [SELECT Id, Form__r.Family_Stage__c, Region_Specific_Variant__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.Family_Stage__c < 3];

        Pokemon__c firstStagePokemon;
        Pokemon__c secondStagePokemon;

        for (Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.Family_Stage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.Family_Stage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }

        //when
        Test.startTest();
        PMHR_NextFormController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.Region_Specific_Variant__c);
        Test.stopTest();

        //then
        Pokemon__c updatedPokemon = [SELECT Id, Form__r.Family_Stage__c FROM Pokemon__c WHERE Id = :firstStagePokemon.Id];
        System.assertEquals(2, updatedPokemon.Form__r.Family_Stage__c);
    }

    static testMethod void shouldNotSetNextPokemonForm_formFamilyDifferent() {
        //given
        Pokemon__c firstStagePokemon = [SELECT Id, Form__r.Family_Stage__c, Region_Specific_Variant__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_TWO LIMIT 1];
        Pokemon__c secondStagePokemon = [SELECT Id, Form__r.Family_Stage__c, Region_Specific_Variant__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.Family_Stage__c = 2 LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_NextFormController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.Region_Specific_Variant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldNotSetNextPokemonForm_formStageLower() {
        //given
        List<Pokemon__c> pokemons = [SELECT Id, Form__r.Family_Stage__c, Region_Specific_Variant__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.Family_Stage__c < 3];
        Boolean errorOccurred = false;

        Pokemon__c firstStagePokemon;
        Pokemon__c secondStagePokemon;

        for (Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.Family_Stage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.Family_Stage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }

        //when
        Test.startTest();
        try {
            PMHR_NextFormController.setPokemonForm(secondStagePokemon.Id, firstStagePokemon.Form__c, firstStagePokemon.Region_Specific_Variant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldNotSetNextPokemonForm_noPokemons() {
        //given
        List<Pokemon__c> pokemons = [SELECT Id, Form__r.Family_Stage__c, Region_Specific_Variant__c FROM Pokemon__c WHERE Form__r.Family__c = :FAMILY_ONE AND Form__r.Family_Stage__c < 3];

        Boolean errorOccurred = false;

        Pokemon__c firstStagePokemon;
        Pokemon__c secondStagePokemon;

        for (Pokemon__c pokemon : pokemons) {
            if (pokemon.Form__r.Family_Stage__c == 1) {
                firstStagePokemon = pokemon;
            } else if (pokemon.Form__r.Family_Stage__c == 2) {
                secondStagePokemon = pokemon;
            }
        }
        delete [SELECT Id FROM Pokemon__c];

        //when
        Test.startTest();
        try {
            PMHR_NextFormController.setPokemonForm(firstStagePokemon.Id, secondStagePokemon.Form__c, secondStagePokemon.Region_Specific_Variant__c);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }
}