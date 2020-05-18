public class PMHR_NextFormController {
    @AuraEnabled
    public static PokemonWithNextForms getNextAvailableForms(String pokemonId) {
        Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
        List<Pokemon_Data__c> availableNextForms = PMHR_PokemonDataQueryService.getAvailableNextPokemonForms(pokemon);
        return new PokemonWithNextForms(pokemon, availableNextForms);
    }

    @AuraEnabled
    public static void setPokemonForm(String pokemonId, String nextFormId, String variant) {
        new PMHR_PokemonBuilder(new Pokemon__c(Id = pokemonId))
                .setForm(nextFormId)
                .setRegionSpecificVariant(variant)
                .save();
    }

    @TestVisible
    private class PokemonWithNextForms {
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public Decimal stage { get; private set; }
        @AuraEnabled public List<PokemonNextForm> nextForms { get; private set; }

        public PokemonWithNextForms(Pokemon__c pokemon, List<Pokemon_Data__c> availableNextForms) {
            this.name = pokemon.Name;
            this.stage = pokemon.Form__r.Family_Stage__c;

            this.nextForms = new List<PokemonNextForm>();
            if (availableNextForms != null) {
                for (Pokemon_Data__c nextForm : availableNextForms) {
                    if (String.isBlank(pokemon.Region_Specific_Variant__c)) {
                        nextForms.addAll(this.generatePokemonNextForms(nextForm));
                    } else {
                        nextForms.add(new PokemonNextForm(nextForm, pokemon.Region_Specific_Variant__c));
                    }
                }
            }
        }

        private List<PokemonNextForm> generatePokemonNextForms(Pokemon_Data__c nextForm) {
            List<PokemonNextForm> availableNextForms = new List<PokemonNextForm>();
            availableNextForms.add(new PokemonNextForm(nextForm));
            if (String.isNotBlank(nextForm.Region_Specific_Variants__c)) {
                for (String variant : nextForm.Region_Specific_Variants__c.split(';')) {
                    availableNextForms.add(new PokemonNextForm(nextForm, variant));
                }
            }
            return availableNextForms;
        }
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
            this(pokemonForm);
            this.name = String.join(new List<String>{regionalVariant, pokemonForm.Name}, ' ');
            this.variant = regionalVariant;
        }
    }
}