public class PMHR_NextFormController {
    @AuraEnabled
    public static PokemonWithNextForms getNextAvailableForms(String pokemonId) {
        try {
            Pokemon__c pokemon = [SELECT Name, Form__r.Family__c, Form__r.Family_Stage__c FROM Pokemon__c WHERE Id = :pokemonId LIMIT 1];
            List<Pokemon_Data__c> nextAvailableForms = [SELECT Id, Name, Pokedex_Number__c, Family_Stage__c FROM Pokemon_Data__c WHERE Family__c = :pokemon.Form__r.Family__c AND Family_Stage__c > :pokemon.Form__r.Family_Stage__c AND Family_Stage__c <= :pokemon.Form__r.Family_Stage__c + 1 ORDER BY Pokedex_Number__c LIMIT 20];
            return new PokemonWithNextForms(pokemon, nextAvailableForms);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static void setPokemonForm(String pokemonId, String nextFormId) {
        try {
            Pokemon__c pokemon = [SELECT Form__c FROM Pokemon__c WHERE Id = :pokemonId LIMIT 1];
            pokemon.Form__c = nextFormId;
            update pokemon;
        } catch (DmlException ex) {
            System.debug(ex.getDmlMessage(0));
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    @TestVisible
    private class PokemonWithNextForms {
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public Decimal stage { get; private set; }
        @AuraEnabled public List<Pokemon_Data__c> nextForms { get; private set; }

        public PokemonWithNextForms(Pokemon__c pokemon, List<Pokemon_Data__c> nextAvailableForms) {
            this.name = pokemon.Name;
            this.stage = pokemon.Form__r.Family_Stage__c;
            this.nextForms = nextAvailableForms;
        }
    }
}