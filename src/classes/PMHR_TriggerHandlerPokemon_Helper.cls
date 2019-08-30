public class PMHR_TriggerHandlerPokemon_Helper {
    public static void copyCaughtFormToForm(Pokemon__c pokemon) {
        if (pokemon.Form__c == null) {
            pokemon.Form__c = pokemon.Caught_Form__c;
        }
    }
}