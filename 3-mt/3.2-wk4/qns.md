### T_ID2

**Description:**  
A valid T_ID2 consists of two parts:

- The **first part** consists of zero or more letters (a-z, A-Z) or underscores (`_`).
- The **second part** consists only of digits.  
  If the first digit in the second part is even (`0`, `2`, `4`, `6`, or `8`), the total number of digits in this part must be even.  
  If the first digit is odd (`1`, `3`, `5`, `7`, or `9`), the total number of digits in this part must be odd.  
  **Note:** The restriction is on the total count of digits in the second part, not their individual values.

**Regex:**

```
(({LETTER}|_)*)   # First part: zero or more letters or underscores
(
    [02468]({DIGIT}{DIGIT})*        # Second part: starts with even digit, followed by an even number (possibly zero) of digit pairs -> total digits even
    |
    [13579]({DIGIT}{DIGIT})*{DIGIT} # Second part: starts with odd digit, followed by an even number (possibly zero) of digit pairs and one extra digit -> total digits odd
)
```

Or in condensed form:

```
(({LETTER}|_)*) ([02468]({DIGIT}{DIGIT})* | [13579]({DIGIT}{DIGIT})*{DIGIT})
```

### NUM2

**Description:**  
Number literals - add new rules besides `T_NUM`:

- **Binary literals** begin with `0b` and contain binary digits (`0` or `1`).
- **Octal literals** start with `0o` (zero o) and contain digits from `0` to `7`.
- **Hexadecimal literals** begin with `0x` and may contain digits and/or letters from `a` to `f` (letters may be capital).  
  For example, `0xaF` or `0o7` are valid literals, but `0o9` and `0xx` are not.
- **Senary literals (base 14)**: starts with `14` and may contain digits and/or letters from `a` to `d` (letters may be capital as well).  
  Valid examples: `140`, `14d3a9`  
  Invalid examples: `14`, `14e`, `14444g`, `1133`  
  Please double-check whether your senary literal recognition really happens (keep in mind you have a general `[0-9]+`-like rule for number recognition as well).
- **Sexagesimal literals (base 60)**: starts with `60` and every 'digit' can take the following values `00, 01, 02, ..., 59` — so every 'digit' takes two characters; therefore every valid sexagesimal number builds up from an even number of characters.  
  Every number that starts with `60` should automatically be considered as a sexagesimal instead of a decimal.  
  For example, `600223` is a valid sexagesimal; it is actually the `0223` sexagesimal number (which is `143` in decimal numbers).  
  More valid examples: `6000`, `60475902`  
  Invalid examples: `6100`, `60`, `603479`  
  Please double-check whether your sexagesimal literal recognition really happens (keep in mind you have a general `[0-9]+`-like rule for number recognition as well).

```
0b[01]*|0o[0-7]*|0x{DIGIT}*[a-fA-F]*|14{DIGIT}*[a-dA-D]*|60([0-5]{DIGIT})* 	std::cout << "T_NUM2" << std::endl;
```