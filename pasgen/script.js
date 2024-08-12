function generatePassword() {
    const length = document.getElementById('length').value;
    const includeUppercase = document.getElementById('uppercase').checked;
    const includeNumbers = document.getElementById('numbers').checked;
    const includeSymbols = document.getElementById('symbols').checked;

    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#$%^&*()_+~`|}{[]:;?><,./-=';
    
    let characters = lowercase;
    if (includeUppercase) characters += uppercase;
    if (includeNumbers) characters += numbers;
    if (includeSymbols) characters += symbols;

    let password = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        password += characters[randomIndex];
    }

    document.getElementById('password').value = password;
    evaluateStrength(password);
}

function copyPassword() {
    const passwordField = document.getElementById('password');
    passwordField.select();
    document.execCommand('copy');
    alert('Password copied to clipboard!');
}

function evaluateStrength(password) {
    let strength = 'Weak';
    if (password.length >= 12 && /[A-Z]/.test(password) && /[0-9]/.test(password) && /[!@#$%^&*()_+~`|}{[\]:;?><,./-=]/.test(password)) {
        strength = 'Strong';
    } else if (password.length >= 8 && (/[A-Z]/.test(password) || /[0-9]/.test(password) || /[!@#$%^&*()_+~`|}{[\]:;?><,./-=]/.test(password))) {
        strength = 'Medium';
    }
    document.getElementById('strength').textContent = `Password Strength: ${strength}`;
}
