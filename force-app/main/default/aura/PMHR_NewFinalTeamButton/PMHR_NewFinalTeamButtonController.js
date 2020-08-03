({
    onSaveClick : function(component, event, helper) {
        let nameInputField = component.find("nameInput");
        let finalTeamName = component.get("v.finalTeamName");
        if (!helper.showErrorOnFieldIfInvalid(nameInputField, finalTeamName)) {
            helper.saveNewFinalTeam(component, finalTeamName);
        }
    },

    onCancelClick : function(component, event, helper) {
        helper.closeModalDialog();
    }
})