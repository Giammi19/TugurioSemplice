document.addEventListener('DOMContentLoaded', function() {
    // Riferimenti agli elementi del form
    const form = document.querySelector('form');
    const nomeInput = document.getElementById('nome');
    const cognomeInput = document.getElementById('cognome');
    const numeroInput = document.getElementById('numero');
    const scadenzaInput = document.getElementById('scadenza');
    const cvvInput = document.getElementById('cvv');
    const spedizioneSelect = document.getElementById('spedizione');
    const submitBtn = document.querySelector('.submit-btn');

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
    
    // Creazione dei div errore
    const nomeError = createErrorElement(nomeInput);
    const cognomeError = createErrorElement(cognomeInput);
    const numeroError = createErrorElement(numeroInput);
    const scadenzaError = createErrorElement(scadenzaInput);
    const cvvError = createErrorElement(cvvInput);

    // Funzioni di validazione passate a validateField come argomenti
    
    // Validazione nome e cognome (2-50 caratteri, solo lettere, spazi, apostrofi, accenti)
    const isNomeValid = (value) => {
        const trimmedValue = value.trim();
        return (trimmedValue.length >= 2) && 
               (trimmedValue.length <= 50) && 
               (/^[a-zA-ZàèéìòùÀÈÉÌÒÙ'\s]+$/.test(trimmedValue));
    };

    // Validazione numero carta (16 cifre numeriche con formattazione a 19 caratteri)
    const isNumeroCartaValid = (value) => {
        return value.replaceAll(' ', '').length === 16;
    };

    // Validazione CVV (3 cifre numeriche)
    const isCvvValid = (value) => {
        return /^\d{3}$/.test(value);
    };

    // Validazione data scadenza (MM/AA, non scaduta)
    const isScadenzaValid = (value) => {
        if (!/^\d{2}\/\d{2}$/.test(value)) {
            return false;
        }
        
        const [month, year] = value.split('/');
        const monthNum = parseInt(month);
        const yearNum = parseInt('20' + year);
        
        // Controlla validità mese
        if (monthNum < 1 || monthNum > 12) {
            return false;
        }
        
        // Controlla che non sia scaduta
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear();
        const currentMonth = currentDate.getMonth() + 1;
        
        if (yearNum < currentYear || (yearNum === currentYear && monthNum < currentMonth)) {
            return false;
        }
        
        return true;
    };

    // Funzione generica di validazione campo
    function validateField(inputElement, errorElement, validationFn, errorMessage) {
        const value = inputElement.value.trim();
        if (!validationFn(value)) {
            errorElement.textContent = errorMessage;
            inputElement.style.borderColor = '#dc3545';
            return false;
        } else {
            errorElement.textContent = '';
            inputElement.style.borderColor = '';
            return true;
        }
    }

    // Validazione completa form
    function validateForm() {
        let isValid = true;

        isValid = validateField(
            nomeInput, 
            nomeError, 
            isNomeValid, 
            'Nome non valido (2-50 caratteri, solo lettere e spazi)'
        ) && isValid;

        isValid = validateField(
            cognomeInput, 
            cognomeError, 
            isNomeValid, 
            'Cognome non valido (2-50 caratteri, solo lettere e spazi)'
        ) && isValid;

        isValid = validateField(
            numeroInput, 
            numeroError, 
            isNumeroCartaValid, 
            'Numero carta non valido. Inserire numero carta valido.'
        ) && isValid;

        isValid = validateField(
            scadenzaInput, 
            scadenzaError, 
            isScadenzaValid, 
            'Data scadenza non valida (formato MM/AA, non scaduta)'
        ) && isValid;

        isValid = validateField(
            cvvInput, 
            cvvError, 
            isCvvValid, 
            'CVV non valido (3 cifre)'
        ) && isValid;

        // Controlla selezione spedizione
        if (!spedizioneSelect.value) {
            isValid = false;
        }

        // Abilita/disabilita pulsante submit
        submitBtn.disabled = !isValid;
        submitBtn.style.opacity = isValid ? '1' : '0.6';
        submitBtn.style.cursor = isValid ? 'pointer' : 'not-allowed';

        return isValid;
    }

    // Formattazione numero carta (aggiunge spazi ogni 4 cifre)
    numeroInput.addEventListener('keydown', event => {
        const { value } = event.target;
        const { keyCode } = event;

        if (!value) return;

        // Puoi cancellare
        if (keyCode === 8) {
            validateForm();
            return;
        }

        // Non scrivi lettere
        if (keyCode < 48 || keyCode > 57) {
            event.preventDefault();
            validateForm();
            return;
        }

        if (value.length === 19) {
            validateForm();
            event.preventDefault(); // Blocco inserimento sopra i 19 caratteri
            return;
        }

        if (value.replaceAll(' ', '').length % 4 === 0) {
            event.target.value += ' ';
        }
        
        validateForm();
    });

    // Formattazione data scadenza (MM/AA)
    scadenzaInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        
        if (value.length >= 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        
        e.target.value = value;
        validateForm();
    });

    // Previene inserimento caratteri non numerici per data scadenza
    scadenzaInput.addEventListener('keypress', function(e) {
        if (!/\d/.test(e.key) && !['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'].includes(e.key)) {
            e.preventDefault();
        }
    });

    // Solo numeri per CVV
    cvvInput.addEventListener('keypress', function(e) {
        if (!/\d/.test(e.key) && !['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'].includes(e.key)) {
            e.preventDefault();
        }
    });

    // Limita lunghezza CVV a 3 caratteri
    cvvInput.addEventListener('input', function(e) {
        if (e.target.value.length > 3) {
            e.target.value = e.target.value.substring(0, 3);
        }
        validateForm();
    });

    // Event listeners per validazione in tempo reale
    nomeInput.addEventListener('input', validateForm);
    cognomeInput.addEventListener('input', validateForm);
    spedizioneSelect.addEventListener('change', validateForm);

    // Validazione al submit
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            alert('Per favore, correggi tutti i campi evidenziati in rosso prima di procedere.');
            return false;
        }
        
        // Rimuovi spazi dal numero carta prima dell'invio (mantenendo solo 16 cifre)
        numeroInput.value = numeroInput.value.replaceAll(' ', '');
        
        // Conferma finale
        const confirmed = confirm('Confermi i dati della carta di credito per procedere con il pagamento?');
        if (!confirmed) {
            e.preventDefault();
            // Ripristina la formattazione del numero carta se l'utente annulla
            let value = numeroInput.value;
            let formattedValue = '';
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) {
                    formattedValue += ' ';
                }
                formattedValue += value[i];
            }
            numeroInput.value = formattedValue;
        }
    });

    // Inizializzazione
    // Disabilita il pulsante submit inizialmente
    submitBtn.disabled = true;
    submitBtn.style.opacity = '0.6';
    submitBtn.style.cursor = 'not-allowed';
    
    // Validazione iniziale
    validateForm();
});