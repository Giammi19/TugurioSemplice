document.addEventListener('DOMContentLoaded', function() {
    // Riferimenti agli elementi del form
    const recuperoForm = document.querySelector('form[method="post"]');
    const usemailInput = document.getElementById('usemail');
    const newPasswordInput = document.getElementById('NewPassword');
    const newPassword2Input = document.getElementById('NewPassword2');
    const submitBtn = recuperoForm.querySelector('button[type="submit"]');

    // Crea elementi per messaggi di errore se non esistono già
    function ensureErrorElement(inputElement) {
        let errorDiv = inputElement.nextElementSibling;
        if (!errorDiv || !errorDiv.classList.contains('error-message')) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            inputElement.parentNode.insertBefore(errorDiv, inputElement.nextSibling);
        }
        return errorDiv;
    }

    // Inizializza elementi errore
    const usemailError = ensureErrorElement(usemailInput);
    const newPasswordError = ensureErrorElement(newPasswordInput);
    const newPassword2Error = ensureErrorElement(newPassword2Input);

    // Funzioni di validazione
    const isUsemailValid = (value) => value.trim().length >= 4;
    
    const isPasswordValid = (value) => {
        const val = value.trim();
        return val.length >= 8 && 
               /[A-Z]/.test(val) && 
               /[a-z]/.test(val) &&
               /[0-9]/.test(val) &&
               /[^a-zA-Z0-9]/.test(val);
    };

    const doPasswordsMatch = () => newPasswordInput.value.trim() === newPassword2Input.value.trim();

    // Funzione di validazione generica
    function validateField(inputElement, errorElement, validationFn, errorMessage) {
        const isValid = validationFn(inputElement.value);
        errorElement.textContent = isValid ? '' : errorMessage;
        inputElement.classList.toggle('is-invalid', !isValid);
        return isValid;
    }

    // Validazione completa del form
    function validateForm() {
        let isValid = true;

        // Validazione username/email
        isValid = validateField(
            usemailInput, 
            usemailError, 
            isUsemailValid, 
            'Inserisci un username o email valida (almeno 4 caratteri)'
        ) && isValid;

        // Validazione nuova password
        isValid = validateField(
            newPasswordInput, 
            newPasswordError, 
            isPasswordValid, 
            'Password non valida (min. 8 caratteri, con maiuscole, minuscole, numeri e simboli)'
        ) && isValid;

        // Validazione conferma password
        if (newPasswordInput.value.trim() && !doPasswordsMatch()) {
            newPassword2Error.textContent = 'Le password non corrispondono';
            newPassword2Input.classList.add('is-invalid');
            isValid = false;
        } else {
            newPassword2Error.textContent = '';
            newPassword2Input.classList.remove('is-invalid');
        }

        return isValid;
    }

    // Event listeners per validazione in tempo reale
    usemailInput.addEventListener('input', function() {
        validateField(
            usemailInput, 
            usemailError, 
            isUsemailValid, 
            'Inserisci un username o email valida (almeno 4 caratteri)'
        );
    });

    newPasswordInput.addEventListener('input', function() {
        validateField(
            newPasswordInput, 
            newPasswordError, 
            isPasswordValid, 
            'Password non valida (min. 8 caratteri, con maiuscole, minuscole, numeri e simboli)'
        );
        // Valida anche la conferma password quando cambi la password principale
        if (newPassword2Input.value) {
            newPassword2Error.textContent = doPasswordsMatch() ? '' : 'Le password non corrispondono';
            newPassword2Input.classList.toggle('is-invalid', !doPasswordsMatch());
        }
    });

    newPassword2Input.addEventListener('input', function() {
        newPassword2Error.textContent = doPasswordsMatch() ? '' : 'Le password non corrispondono';
        newPassword2Input.classList.toggle('is-invalid', !doPasswordsMatch());
    });

    // Validazione al submit
    recuperoForm.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            // Mostra tutti gli errori
            usemailInput.dispatchEvent(new Event('input'));
            newPasswordInput.dispatchEvent(new Event('input'));
            newPassword2Input.dispatchEvent(new Event('input'));
        } else {
            // Conferma finale all'utente
            const confirmed = confirm('Sei sicuro di voler reimpostare la password?');
            if (!confirmed) {
                e.preventDefault();
            }
        }
    });

    // Validazione iniziale
    validateForm();
});