import { ShowToastEvent } from 'lightning/platformShowToastEvent';

class PMHR_Utils {
    static stringFormat(stringToFormat, ...tokens) {
        if (typeof stringToFormat !== 'string') throw new Error('\'stringToFormat\' must be a String.');
        return stringToFormat.replace(/{(\d+)}/gm, (match, index) => (tokens[index] === undefined ? '' : `${tokens[index]}`));
    }
}

const stringFormat = (stringToFormat, ...tokens) => {
    if (typeof stringToFormat !== 'string') {
        throw new Error('\'stringToFormat\' must be a String.');
    }
    return stringToFormat.replace(/{(\d+)}/gm, (match, index) => (tokens[index] === undefined ? '' : `${tokens[index]}`));
}

const showToast = (title, message, variant) => {
    const toast = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    dispatchEvent(toast);
}

export {
    PMHR_Utils,
    stringFormat,
    showToast
};