({
    showErrorMessage : function(component, event) {
        let params = event.getParam("arguments");
        if (params) {
            component.set("v.showError", params.showError);
            component.set("v.errorMessage", params.errorMessage);
        }
    }
})