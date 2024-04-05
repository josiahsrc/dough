export const isDevMode = () => {
    return process && process.env && process.env.NODE_ENV === 'development';
};
const warnings = {};
export const deprecationWarning = (key, message) => {
    if (isDevMode()) {
        if (!warnings[key]) {
            console.warn(message);
            warnings[key] = true;
        }
    }
};
//# sourceMappingURL=dev.js.map