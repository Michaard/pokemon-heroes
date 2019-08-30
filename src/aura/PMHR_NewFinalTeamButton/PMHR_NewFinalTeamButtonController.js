({
    onSaveClick : function(component, event, helper) {
        let finalTeamName = component.get("v.finalTeamName");
        if (!$A.util.isEmpty(finalTeamName)) {
            helper.saveNewFinalTeam(component, finalTeamName);
        } else {
            helper.showErrorMessage(component, $A.get("$Label.c.Toast_Error_Missing_Fields"));
        }
    },

    onCancelClick : function(component, event, helper) {
        helper.hideErrorMessage(component);
        helper.closeModalDialog();
    }
})