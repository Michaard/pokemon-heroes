public with sharing class PMHR_EvolvePokemonController {
    @AuraEnabled
    public static List<PokemonNextForm> getNextAvailableForms(Id pokemonId) {
        try {
            Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
            return getPokemonNextForms(pokemon);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void setPokemonForm(Id pokemonId, Id nextFormId, String variant) {
        try {
            new PMHR_PokemonBuilder(new Pokemon__c(Id = pokemonId))
                    .setForm(nextFormId)
                    .setRegionSpecificVariant(variant)
                    .save();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static List<PokemonNextForm> getPokemonNextForms(Pokemon__c pokemon) {
        List<PokemonNextForm> nextForms = new List<PokemonNextForm>();
        List<Pokemon_Data__c> availableNextForms = PMHR_PokemonDataQueryService.getAvailableNextPokemonForms(pokemon);
        if (availableNextForms != null) {
            for (Pokemon_Data__c nextForm : availableNextForms) {
                nextForms.addAll(generatePokemonNextForms(pokemon.Region_Specific_Variant__c, nextForm));
            }
        }
        return nextForms;
    }

    private static List<PokemonNextForm> generatePokemonNextForms(String pokemonVariant, Pokemon_Data__c nextForm) {
        List<PokemonNextForm> validNextForms = new List<PokemonNextForm>();
        if (nextForm.Evolves_from_Variant__c == pokemonVariant) {
            validNextForms.add(new PokemonNextForm(nextForm));
        }
        for (Pokemon_Data__c additionalVariant : nextForm.Additional_Variants__r) {
            if (additionalVariant.Evolves_from_Variant__c == pokemonVariant) {
                validNextForms.add(new PokemonNextForm(nextForm, additionalVariant));
            }
        }
        return validNextForms;
    }

    @TestVisible
    private class PokemonNextForm {
        @AuraEnabled public String id { get; private set; }
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public String pokedexNumber { get; private set; }
        @AuraEnabled public String variant { get; private set; }
        @AuraEnabled public String type { get; private set; }
        @AuraEnabled public Decimal familyStage { get; private set; }
        @AuraEnabled public String pictureUrl { get; private set; }

        public PokemonNextForm(Pokemon_Data__c pokemonForm) {
            this.id = pokemonForm.Id;
            this.name = pokemonForm.Name;
            this.pokedexNumber = pokemonForm.Pokedex_Number__c;
            this.type = pokemonForm.Type__c;
            this.familyStage = pokemonForm.Family_Stage__c;
            this.pictureUrl = pokemonForm.Picture_Url__c;
        }

        public PokemonNextForm(Pokemon_Data__c pokemonForm, Pokemon_Data__c variant) {
            this(pokemonForm);
            this.name = variant.Variant_Name__c;
            this.variant = variant.Region_Specific_Variant__c;
            this.type = variant.Type__c;
            this.pictureUrl = variant.Picture_Url__c;
        }
    }
}