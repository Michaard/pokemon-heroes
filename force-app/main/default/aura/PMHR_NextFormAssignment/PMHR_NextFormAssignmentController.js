({
    init : function(component, event, helper) {
        helper.getNextAvailableForms(component);
    },

    levelUp : function(component, event, helper) {
        let index = event.getSource().get("v.name");
        let nextForm = component.get("v.nextAvailableForms")[index];
        let nextFormId = nextForm.id;
        let nextFormVariant = nextForm.variant;
        helper.setPokemonForm(component, nextFormId, nextFormVariant);
    }
})