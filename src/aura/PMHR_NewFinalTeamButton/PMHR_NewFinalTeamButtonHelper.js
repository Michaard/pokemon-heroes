({
    saveNewFinalTeam : function(component, finalTeamName) {
        let nuzlockeId = component.get("v.recordId");

        let action = component.get("c.createFinalTeam");
        action.setParams({
            "nuzlockeId" : nuzlockeId,
            "finalTeamName" : finalTeamName
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let toastEvent = $A.get("e.force:showToast");
                if (toastEvent) {
                    let finalTeamAddedEvent = $A.get("e.c:PMHR_EventFinalTeamAdded");
                    if (finalTeamAddedEvent) {
                        finalTeamAddedEvent.fire();
                    }
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.Toast_Success_Add_New_Final_Team"),
                        "type": "success"
                    });
                    toastEvent.fire();
                    this.closeModalDialog();
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                this.showErrorMessage(component, errors[0].message);
            }
            component.set("v.displaySpinner", false);
        });

        $A.enqueueAction(action);
        component.set("v.displaySpinner", true);
    },

    closeModalDialog : function() {
        $A.get("e.force:closeQuickAction").fire();
    },

    showErrorMessage : function(component, errorMessage) {
        let componentErrorMessage = component.find("componentErrorMessage");
        if (componentErrorMessage) {
            componentErrorMessage.showErrorMessage(true, errorMessage);
        }
    }
})