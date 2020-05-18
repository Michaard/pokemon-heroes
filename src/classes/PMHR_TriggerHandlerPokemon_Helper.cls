public class PMHR_TriggerHandlerPokemon_Helper {
    public static void copyCaughtFormToForm(Pokemon__c pokemon) {
        if (pokemon.Form__c == null) {
            pokemon = new PMHR_PokemonBuilder(pokemon)
                    .setForm(pokemon.Caught_Form__c)
                    .build();
        }
    }
}