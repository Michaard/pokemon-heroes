({
    parseErrorFromAction : function(component, event, helper) {
        let params = event.getParams().arguments;
        return helper.parseErrors(params.errors);
    },

    showErrorOnFieldIfEmpty : function(component, event, helper) {
        let params = event.getParams().arguments;
        return helper.isFieldEmpty(params.field, params.fieldValue);
    },
})