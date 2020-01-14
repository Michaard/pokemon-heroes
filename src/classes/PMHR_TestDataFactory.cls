@IsTest
public class PMHR_TestDataFactory {
    public static Hero__c createHeroObject(String name, String region) {
        return createHeroObject(name, region, PMHR_Utilities.HERO_GAME_VERSION_RED);
    }

    public static Hero__c createHeroObject(String name, String region, String gameVersion) {
        Hero__c hero = new Hero__c();
        hero.Name = name;
        hero.Region__c = region;
        hero.Game_Version__c = gameVersion;

        return hero;
    }

    public static Nuzlocke__c createNuzlockeObject(String name, Date startDate, Id heroId) {
        return createNuzlockeObject(name, startDate, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, heroId, PMHR_Utilities.NUZLOCKE_LEGENDARIES_RULE_KILL, false);
    }

    public static Nuzlocke__c createNuzlockeObject(String name, Date startDate, Id heroId, Boolean multipleEliteFourFights) {
        return createNuzlockeObject(name, startDate, PMHR_Utilities.POKEMON_CATCH_METHOD_EVENT, heroId, PMHR_Utilities.NUZLOCKE_LEGENDARIES_RULE_KILL, multipleEliteFourFights);
    }

    public static Nuzlocke__c createNuzlockeObject(String name, Date startDate, String allowedCatchingMethods, Id heroId, String legendariesRule, Boolean multipleEliteFourFights) {
        Nuzlocke__c nuzlocke = new Nuzlocke__c();
        nuzlocke.Name = name;
        nuzlocke.Start_Date__c = startDate;
        nuzlocke.Allowed_Catching_Methods_Per_Area__c = allowedCatchingMethods;
        nuzlocke.Hero__c = heroId;
        nuzlocke.Legendaries_Rule__c = legendariesRule;
        nuzlocke.Multiple_Elite_Four_Fights__c = multipleEliteFourFights;

        return nuzlocke;
    }

    public static Pokemon_Data__c createPokemonDataObject(String pokedexNr, String form, String formType, String family, Integer familyStage) {
        Pokemon_Data__c pokemonData = new Pokemon_Data__c();
        pokemonData.Pokedex_Number__c = pokedexNr;
        pokemonData.Name = form;
        pokemonData.Primary_Type__c = formType;
        pokemonData.Family__c = family;
        pokemonData.Family_Stage__c = familyStage;
        List<String> variants = new List<String>();
        for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
            if (variant.getValue() != PMHR_Utilities.REGION_VARIANT_STANDARD) {
                variants.add(variant.getValue());
            }
        }
        pokemonData.Region_Specific_Variants__c = String.join(variants, ';');

        return pokemonData;
    }

    public static Pokemon__c createPokemonObject(String name, String gender, Id caughtFormId, String catchMethod, Id nuzlockeId) {
        return createPokemonObject(name, gender, caughtFormId, null, catchMethod, nuzlockeId, PMHR_Utilities.REGION_VARIANT_STANDARD);
    }

    public static Pokemon__c createPokemonObject(String name, String gender, Id caughtFormId, Id formId, String catchMethod, Id nuzlockeId, String variant) {
        Pokemon__c pokemon = new Pokemon__c();
        pokemon.Name = name;
        pokemon.Gender__c = gender;
        pokemon.Caught_Form__c = caughtFormId;
        pokemon.Form__c = formId;
        pokemon.Catch_Method__c = catchMethod;
        pokemon.Nuzlocke__c = nuzlockeId;
        pokemon.Variant__c = variant;

        return pokemon;
    }

    public static Final_Team__c createFinalTeamObject(String name, Id nuzlockeId) {
        Final_Team__c finalTeam = new Final_Team__c();

        finalTeam.Name = name;
        finalTeam.Nuzlocke__c = nuzlockeId;

        return finalTeam;
    }

    public static Final_Team_Member__c createFinalTeamMemberObject(Id finalTeamId, Id pokemonId) {
        Final_Team_Member__c finalTeamMember = new Final_Team_Member__c();

        finalTeamMember.Final_Team__c = finalTeamId;
        finalTeamMember.Pokemon__c = pokemonId;

        return finalTeamMember;
    }
}