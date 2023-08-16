public with sharing class PMHR_EvolvePokemonController {
    @AuraEnabled
    public static List<PokemonNextForm> getNextAvailableForms(Id pokemonId) {
        try {
            PMHR_Pokemon__c pokemon = PMHR_PokemonQueryService.getPokemonWithFormById(pokemonId);
            return getPokemonNextForms(pokemon);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void setPokemonForm(Id pokemonId, Id nextFormId, String variant) {
        try {
            new PMHR_PokemonBuilder(new PMHR_Pokemon__c(Id = pokemonId))
                    .setForm(nextFormId)
                    .setRegionSpecificVariant(variant)
                    .save();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static List<PokemonNextForm> getPokemonNextForms(PMHR_Pokemon__c pokemon) {
        List<PokemonNextForm> nextForms = new List<PokemonNextForm>();
        List<PMHR_PokemonData__c> availableNextForms = PMHR_PokemonDataQueryService.getAvailableNextPokemonForms(pokemon);
        if (availableNextForms != null) {
            for (PMHR_PokemonData__c nextForm : availableNextForms) {
                nextForms.addAll(generatePokemonNextForms(pokemon.RegionalVariant__c, nextForm));
            }
        }
        return nextForms;
    }

    private static List<PokemonNextForm> generatePokemonNextForms(String pokemonVariant, PMHR_PokemonData__c nextForm) {
        List<PokemonNextForm> validNextForms = new List<PokemonNextForm>();
        if (nextForm.EvolvesFromVariant__c == pokemonVariant) {
            validNextForms.add(new PokemonNextForm(nextForm));
        }
        for (PMHR_PokemonData__c additionalVariant : nextForm.Variants__r) {
            if (additionalVariant.EvolvesFromVariant__c == pokemonVariant) {
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

        public PokemonNextForm(PMHR_PokemonData__c pokemonForm) {
            this.id = pokemonForm.Id;
            this.name = pokemonForm.Name;
            this.pokedexNumber = pokemonForm.PokedexNumber__c;
            this.type = pokemonForm.Type__c;
            this.familyStage = pokemonForm.FamilyStage__c;
            this.pictureUrl = pokemonForm.PictureUrl__c;
        }

        public PokemonNextForm(PMHR_PokemonData__c pokemonForm, PMHR_PokemonData__c variant) {
            this(pokemonForm);
            this.name = variant.VariantName__c;
            this.variant = variant.RegionalVariant__c;
            this.type = variant.Type__c;
            this.pictureUrl = variant.PictureUrl__c;
        }
    }
}