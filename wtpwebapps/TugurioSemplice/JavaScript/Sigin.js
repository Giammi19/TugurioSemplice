document.addEventListener('DOMContentLoaded', function() {
    // Riferimenti agli elementi HTML
    const registrationForm = document.getElementById('registrationForm');
    
    // Creazione elementi per messaggi di errore
    function createErrorElement(inputElement) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.style.color = '#dc3545';
        errorDiv.style.fontSize = '0.875rem';
        errorDiv.style.marginTop = '0.25rem';
        inputElement.parentNode.insertBefore(errorDiv, inputElement.nextSibling);
        return errorDiv;
    }
    
    // Step 1 - Anagrafica
    const nomeInput = document.getElementById('nome');
    const cognomeInput = document.getElementById('cognome');
    const cfInput = document.getElementById('cf');
    const telefonoInput = document.getElementById('telefono');
    
    // Creazione elementi errore
    const nomeError = createErrorElement(nomeInput);
    const cognomeError = createErrorElement(cognomeInput);
    const cfError = createErrorElement(cfInput);
    const telefonoError = createErrorElement(telefonoInput);
    
    // Pulsanti navigazione
    const nextBtnStep1 = document.querySelector('#step1 .next-btn');

    // Step 2 - Account
    const usernameInput = document.getElementById('username');
    const emailInput = document.getElementById('email');
    const passkeyInput = document.getElementById('passkey');
    const passkey2Input = document.getElementById('passkey2');

    const usernameError = createErrorElement(usernameInput);
    const emailError = createErrorElement(emailInput);
    const passkeyError = createErrorElement(passkeyInput);
    const passkey2Error = createErrorElement(passkey2Input);

    const nextBtnStep2 = document.querySelector('#step2 .next-btn');

    // Step 3 - Spedizione
    const cityInput = document.getElementById('city');
    const provinciaInput = document.getElementById('provincia');
    const streetInput = document.getElementById('street');
    const capInput = document.getElementById('CAP');

    const cityError = createErrorElement(cityInput);
    const provinciaError = createErrorElement(provinciaInput);
    const streetError = createErrorElement(streetInput);
    const capError = createErrorElement(capInput);

    const submitBtn = document.querySelector('#step3 .submit-btn');

    // Funzioni di validazione specifiche per campo
    function validateField(inputElement, errorElement, validationFn, errorMessage) {
        if (!validationFn(inputElement.value.trim())) {
            errorElement.textContent = errorMessage;
            inputElement.classList.add('is-invalid');
            return false;
        } else {
            errorElement.textContent = '';
            inputElement.classList.remove('is-invalid');
            return true;
        }
    }

    // Validazioni per Step 1 (Anagrafica)
    const isNomeValid = (value) => value.length >= 2 && /^[a-zA-Zàèéìòù' ]+$/.test(value);
    const isCognomeValid = (value) => value.length >= 2 && /^[a-zA-Zàèéìòù' ]+$/.test(value);
    const isCfValid = (value) => value === '' || /^[A-Z]{6}[0-9LMNPQRSTUV]{2}[A-Z][0-9LMNPQRSTUV]{2}[A-Z][0-9LMNPQRSTUV]{3}[A-Z]$/i.test(value);
    const isTelefonoValid = (value) => value === '' || /^\+?[0-9]{7,15}$/.test(value);

    // Validazioni per Step 2 (Account)
    const isUsernameValid = (value) => value.length >= 4 && /^[a-zA-Z0-9_.]+$/.test(value);
    const isEmailValid = (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    const isPasswordValid = (value) => value.length >= 8 && /[A-Z]/.test(value) && /[a-z]/.test(value) && /[0-9]/.test(value) && /[^a-zA-Z0-9]/.test(value);
    const doPasswordsMatch = () => passkeyInput.value === passkey2Input.value;

    // Validazioni per Step 3 (Spedizione)
    const isCityValid = (value) => value.length >= 2 && /^[a-zA-Zàèéìòù' ]+$/.test(value);
    const isProvinciaValid = (value) => value.length === 2 && /^[A-Z]{2}$/.test(value);
    const isStreetValid = (value) => value.length >= 5;
    const isCapValid = (value) => /^[0-9]{5}$/.test(value);

    // Funzioni di validazione per Step
    function validateStep1() {
        let allValid = true;
        allValid = validateField(nomeInput, nomeError, isNomeValid, 'Nome non valido (almeno 2 lettere, solo lettere e spazi).') && allValid;
        allValid = validateField(cognomeInput, cognomeError, isCognomeValid, 'Cognome non valido (almeno 2 lettere, solo lettere e spazi).') && allValid;
        allValid = validateField(cfInput, cfError, isCfValid, 'Codice Fiscale non valido (16 caratteri alfanumerici).') && allValid;
        allValid = validateField(telefonoInput, telefonoError, isTelefonoValid, 'Numero di telefono non valido (7-15 cifre, opzionale + iniziale).') && allValid;
        
        nextBtnStep1.disabled = !allValid;
        return allValid;
    }

    function validateStep2() {
        let allValid = true;
        allValid = validateField(usernameInput, usernameError, isUsernameValid, 'Username non valido (almeno 4 caratteri, solo lettere, numeri, _ .).') && allValid;
        allValid = validateField(emailInput, emailError, isEmailValid, 'Formato email non valido.') && allValid;
        allValid = validateField(passkeyInput, passkeyError, isPasswordValid, 'Password non valida (min. 8 caratteri, 1 maiuscola, 1 minuscola, 1 numero, 1 simbolo).') && allValid;
        
        if (!doPasswordsMatch()) {
            passkey2Error.textContent = 'Le password non corrispondono.';
            passkey2Input.classList.add('is-invalid');
            allValid = false;
        } else {
            passkey2Error.textContent = '';
            passkey2Input.classList.remove('is-invalid');
        }

        nextBtnStep2.disabled = !allValid;
        return allValid;
    }

    function validateStep3() {
        let allValid = true;
        allValid = validateField(cityInput, cityError, isCityValid, 'Città non valida (almeno 2 lettere, solo lettere e spazi).') && allValid;
        allValid = validateField(provinciaInput, provinciaError, isProvinciaValid, 'Provincia non valida (2 lettere maiuscole es. RM).') && allValid;
        allValid = validateField(streetInput, streetError, isStreetValid, 'Via non valida (almeno 5 caratteri).') && allValid;
        allValid = validateField(capInput, capError, isCapValid, 'CAP non valido (5 cifre numeriche).') && allValid;
        
        submitBtn.disabled = !allValid;
        return allValid;
    }

    // Event Listeners per validazione in tempo reale
    // Step 1
    nomeInput.addEventListener('input', validateStep1);
    cognomeInput.addEventListener('input', validateStep1);
    cfInput.addEventListener('input', validateStep1);
    telefonoInput.addEventListener('input', validateStep1);
    nextBtnStep1.disabled = true;

    // Step 2
    usernameInput.addEventListener('input', validateStep2);
    emailInput.addEventListener('input', validateStep2);
    passkeyInput.addEventListener('input', validateStep2);
    passkey2Input.addEventListener('input', validateStep2);
    nextBtnStep2.disabled = true;

    // Step 3
    cityInput.addEventListener('input', validateStep3);
    provinciaInput.addEventListener('input', validateStep3);
    streetInput.addEventListener('input', validateStep3);
    capInput.addEventListener('input', validateStep3);
    submitBtn.disabled = true;

    // Funzioni per navigazione tra step
    window.nextStep = function(current, next) {
        document.getElementById('step' + current).classList.remove('active');
        document.getElementById('step' + next).classList.add('active');
        
        document.getElementById('step-indicator-' + current).classList.remove('active');
        document.getElementById('step-indicator-' + current).classList.add('completed');
        document.getElementById('step-indicator-' + next).classList.add('active');

        if (next === 2) validateStep2();
        if (next === 3) validateStep3();
    };
    
    window.prevStep = function(current, prev) {
        document.getElementById('step' + current).classList.remove('active');
        document.getElementById('step' + prev).classList.add('active');
        
        document.getElementById('step-indicator-' + current).classList.remove('active');
        document.getElementById('step-indicator-' + prev).classList.remove('completed');
        document.getElementById('step-indicator-' + prev).classList.add('active');

        if (prev === 1) validateStep1();
        if (prev === 2) validateStep2();
    };

    // Validazione iniziale
    validateStep1(); 
    validateStep2(); 
    validateStep3();
});