# Security Exercise Sheet 1

## Question E 1.4  Breaking a cipher

I need to find the hidden flag encrypted using the provided `challenge.py` script.

### What should I do?

When I opened the provided code in the terminal, there was an explanation of the encrypted flag.
There were two integer keys (`key1`, `key2`) and a message.
The message is encrypted with an Affine cipher, defined as:

<img width="1431" height="701" alt="Encryption" src="https://github.com/user-attachments/assets/f6ff8356-7e3a-4aea-939f-2b490cdcd426" />

Encryption:

$$
E(x) = (a \cdot x + b) \bmod m
$$

* `a` = multiplicative key
* `b` = additive key
* `m` = size of the alphabet

Decryption:

$$
D(x) = a^{-1} \cdot (x - b) \bmod m
$$

Given information:

```
Output: XL7V2sCOKWSIICsCg}W}qeWGqgWgEKkK0
```

Alphabet used:

```
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}><|
```

Since an alphabet is given and the key space is limited, brute-forcing is a good option.

So, `m = 66` possible characters.

We need to find the values of `a` and `b`.

### Writing the decryptor

Below is the Python script (`RSA.py`) used to brute-force all valid `(a, b)` combinations and test each decryption:

```python
#!/usr/bin/env python3
from math import gcd

alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}><|"
m = len(alphabet)
idx = {ch: i for i, ch in enumerate(alphabet)}

ciphertext = "XL7V2sCOKWSIICsCg}W}qeWGqgWgEKkK0"

def modinv(a, m):
    return pow(a, -1, m)  # modular inverse

def decrypt(ct, a, b):
    a_inv = modinv(a, m)
    return ''.join(alphabet[(a_inv * (idx[ch] - b)) % m] if ch in idx else ch for ch in ct)

for a in range(1, m):
    if gcd(a, m) != 1:
        continue  # 'a' must be coprime with m
    for b in range(m):
        pt = decrypt(ciphertext, a, b)
        if "flag{" in pt.lower():
            print(f"FOUND: a={a}, b={b} -> {pt}")
```

---

### Brute-force attack

Executed in WSL/terminal:

```bash (wsl)
python3 RSA.py
```

Output:

```
FOUND: a=65, b=44 -> FLAG{nice<affinity<you<got<there}
```

---

### Explanation

The affine cipher uses a small alphabet, so the key space is limited and can be brute-forced. Only values of `a` that are coprime with `m` are valid.

**Attack**

* Enumerate all possible `a` (coprime with `m`).
* Enumerate all possible `b` (from 0 to `m-1`).

---

### The Flag

```
FLAG{nice<affinity<you<got<there}
```
