

# Verification and Decryption Script (install.sh)



This project allows you to generate multiple encrypted shell scripts using `script.js`. You can use the `install.sh` script to download, verify, and decrypt these scripts. Here's how to use the project:

1. **Generate Encrypted Shell Scripts:**
   - Run `script.js` to generate encrypted shell scripts.
   - Provide the number of scripts you want to create.
   - The script will create directories for each script, containing the encrypted shell script and version information.
   - A `key.json` file in the root directory will store the decryption keys.

2. **Verify and Decrypt Scripts:**
   - Use `install.sh` to verify and decrypt the scripts.
   - Provide the path to the `key.json` file as an argument.
   - The script will download the encrypted scripts, decrypt them, and verify their version and decryption key.
   - You will see the output of each script with verified information.

3. **GitHub Pages:**
   - You can find the encrypted scripts and key.json on the [GitHub Pages](https://github.com/Sachita007/Scripts) of your repository.

4. **Usage:**
   - To generate encrypted scripts, run `script.js`.
   - To verify and decrypt scripts, run `install.sh` with `key.json` as an argument.

5. **Example Usage:**
   ```bash
   ./install.sh path/to/key.json
   ```

## Download Scripts

#### Download Install Script

```bash
wget https://sachita007.github.io/Scripts/install.sh
```

#### Key.json

```bash
wget https://sachita007.github.io/Scripts/scripts/key.json
```
#### For Accessing shell scripts 
```bash
wget https://sachita007.github.io/Scripts/scripts/{key}/script.sh.enc
```
[[Note:]] You can replace key ,with your key like key1. key2 and all.


# Decryption large files
This script allows you to download and decrypt a text file from a GitHub Pages repository using a decryption key stored as an environment variable. You can customize the number of words to display from the decrypted text.

#### Download Script

1. Set the decryption key:
    ```bash
     export l001=provided_secret_key
    ```

2. Download:

    - **Using wget (GitHub)**:
      ```bash
      wget -O - https://sachita007.github.io/Scripts/scripts/large.sh | bash
      ```
3. Execute:

```bash
bash large.sh l001
```


## File Structure For Scripts

```
parent-directory/
|-- largeScripts/
|   |-- l001/
|   |   |-- encrypted.text.enc  --- This is encrypted text file , that downloaded and decrypted by large.sh shell script
|   |   |-- input.txt.enc
|-- scripts/
|   |-- key001/
|   |   |-- script.sh.enc
|   |   |-- version.json.enc
|   |-- key002/
|   |   |-- script.sh.enc
|   |   |-- version.json.enc
|   |-- key003/
|   |   |-- script.sh.enc
|   |   |-- version.json.enc
|   |-- ...
|   |-- key.json
|-- install.sh
|-- large.sh -----For testing large file Decryption
|-- script.js ---For creating Shell Scripts
|-- README.md


```