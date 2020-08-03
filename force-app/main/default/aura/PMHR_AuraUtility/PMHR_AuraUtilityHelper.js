({
    parseErrors : function (errors) {
       let message;
       if (errors && Array.isArray(errors) && errors.length > 0) {
           message = errors[0].message;
           if ($A.util.isEmpty(message)) {
               let fieldErrors = errors[0].fieldErrors;
               let pageErrors = errors[0].pageErrors;
               if (fieldErrors && fieldErrors.length > 0) {
                   message = fieldErrors[0].message;
               } else {
                   message = pageErrors[0].message;
               }
           }
       }
       return message;
    },

    isFieldEmpty : function(field, fieldValue) {
        if ($A.util.isEmpty(fieldValue)) {
            field.showHelpMessageIfInvalid();
            return true;
        }
        return false;
    },
})