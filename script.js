const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const readline = require('readline');
const childProcess = require('child_process');

// Create a readline interface for user input
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

rl.question('How many scripts do you want to create? ', (numScripts) => {
    numScripts = parseInt(numScripts, 10);

    if (isNaN(numScripts) || numScripts <= 0) {
        console.log('Invalid input. Please enter a positive number.');
        rl.close();
        return;
    }

    // Create the root directory
    const rootDir = 'scripts';
    if (!fs.existsSync(rootDir)) {
        fs.mkdirSync(rootDir);
    }

    const keyJson = {};

    const version = "1.0"

    for (let i = 1; i <= numScripts; i++) {
        const key = `key${i}`;

        // Generate a random secret key (32 bytes)
        const secret = crypto.randomBytes(32);

        // Create a directory for the key
        const keyDir = path.join(rootDir, key);
        if (!fs.existsSync(keyDir)) {
            fs.mkdirSync(keyDir);
        }

        // Create a version.json file for this key
        const ver = version + `.${i}`;
        const versionJson = `{"version": "${ver}"}`;
        fs.writeFileSync(path.join(keyDir, 'version.json'), versionJson, 'utf-8');

        // Create the shell script for this key
        const shellScript = `#!/bin/bash\n\n` +
            `# Message Version\n` +
            `VERSION="${ver}"\n\n` +
            `# Decryption Key\n` +
            `DECRYPTION_KEY="${key}"\n\n` +
            `# Echo Version and Key\n` +
            `echo "Message Version: \${VERSION}"\n` +
            `echo "Decryption Key: \${DECRYPTION_KEY}"\n`;

        fs.writeFileSync(path.join(keyDir, 'script.sh'), shellScript, 'utf-8');

        // Use openssl to encrypt the shell script
        const opensslCommand = `openssl enc -aes-256-cbc -pbkdf2 -in "${path.join(keyDir, 'script.sh')}" -out "${path.join(keyDir, 'script.sh.enc')}" -pass pass:${secret.toString('hex')}`;
        const result = childProcess.execSync(opensslCommand);





        // Encrypt the version.json file with the same key as the script using OpenSSL
        const versionOpensslCommand = `echo '${versionJson}' | openssl enc -aes-256-cbc -pbkdf2 -out "${path.join(keyDir, 'version.json.enc')}" -pass pass:${secret.toString('hex')}`;
        const versionResult = childProcess.execSync(versionOpensslCommand);

        // Store the secret key in keyJson
        keyJson[key] = secret.toString('hex');
    }

    // Save the key.json in the root
    fs.writeFileSync(path.join(rootDir, 'key.json'), JSON.stringify(keyJson, null, 2), 'utf-8');

    console.log(`Created ${numScripts} directory structure, encrypted shell scripts, and a key.json file.`);
    rl.close();
});
