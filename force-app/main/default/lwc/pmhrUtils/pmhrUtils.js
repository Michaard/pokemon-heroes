class PMHR_Utils {
    static stringFormat(stringToFormat, ...tokens) {
        if (typeof stringToFormat !== 'string') throw new Error('\'stringToFormat\' must be a String.');
        return stringToFormat.replace(/{(\d+)}/gm, (match, index) => (tokens[index] === undefined ? '' : `${tokens[index]}`));
    }
}

export { PMHR_Utils };