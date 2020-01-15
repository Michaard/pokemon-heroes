public class PMHR_NextFormController {
    @AuraEnabled
    public static PokemonWithNextForms getNextAvailableForms(String pokemonId) {
        try {
            Pokemon__c pokemon = [SELECT Name, Form__r.Family__c, Form__r.Family_Stage__c, Form__r.Region_Specific_Variants__c FROM Pokemon__c WHERE Id = :pokemonId LIMIT 1];
            List<Pokemon_Data__c> nextAvailableForms = [SELECT Id, Name, Pokedex_Number__c, Family_Stage__c, Region_Specific_Variants__c FROM Pokemon_Data__c WHERE Family__c = :pokemon.Form__r.Family__c AND Family_Stage__c = :pokemon.Form__r.Family_Stage__c + 1 ORDER BY Pokedex_Number__c LIMIT 20];
            return new PokemonWithNextForms(pokemon, nextAvailableForms);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static void setPokemonForm(String pokemonId, String nextFormId, String variant) {
        try {
            Pokemon__c pokemon = [SELECT Form__c FROM Pokemon__c WHERE Id = :pokemonId LIMIT 1];
            pokemon.Form__c = nextFormId;
            pokemon.Region_Specific_Variant__c = variant;
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
        @AuraEnabled public List<PokemonNextForm> nextForms { get; private set; }

        public PokemonWithNextForms(Pokemon__c pokemon, List<Pokemon_Data__c> nextAvailableForms) {
            this.name = pokemon.Name;
            this.stage = pokemon.Form__r.Family_Stage__c;

            this.nextForms = new List<PokemonNextForm>();
            if (!nextAvailableForms.isEmpty()) {
                for (Pokemon_Data__c nextForm : nextAvailableForms) {
                    nextForms.addAll(generatePokemonNextForms(nextForm));
                }
            }
        }
    }

    private static List<PokemonNextForm> generatePokemonNextForms(Pokemon_Data__c nextForm) {
        List<PokemonNextForm> nextAvailableForms = new List<PokemonNextForm>();
        nextAvailableForms.add(new PokemonNextForm(nextForm));
        if (String.isNotBlank(nextForm.Region_Specific_Variants__c)) {
            for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
                if (nextForm.Region_Specific_Variants__c.contains(variant.getValue())) {
                    nextAvailableForms.add(new PokemonNextForm(nextForm, variant.getValue()));
                }
            }
        }
        return nextAvailableForms;
    }

    @TestVisible
    private class PokemonNextForm {
        @AuraEnabled public String id { get; private set; }
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public String pokedexNumber { get; private set; }
        @AuraEnabled public String variant { get; private set; }
        @AuraEnabled public Decimal familyStage { get; private set; }

        public PokemonNextForm(Pokemon_Data__c pokemonForm) {
            this.id = pokemonForm.Id;
            this.name = pokemonForm.Name;
            this.pokedexNumber = pokemonForm.Pokedex_Number__c;
            this.familyStage = pokemonForm.Family_Stage__c;
        }

        public PokemonNextForm(Pokemon_Data__c pokemonForm, String regionalVariant) {
            this.id = pokemonForm.Id;
            this.name = String.join(new List<String>{regionalVariant, pokemonForm.Name}, ' ');
            this.pokedexNumber = pokemonForm.Pokedex_Number__c;
            this.variant = regionalVariant;
            this.familyStage = pokemonForm.Family_Stage__c;
        }
    }
}