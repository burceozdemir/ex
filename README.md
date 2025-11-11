# Security  lecture Exercise sheet 1 
## Question E1.6 BBC

When I opened the given file on the terminal, this is the information that I had:

<img width="1753" height="822" alt="photo1" src="https://github.com/user-attachments/assets/cf0a485b-ea9d-49aa-a6e6-d1dc75ca2bb5" />

BBC sent us a secret message using RSA encryption.
However, they did it three times on the same message. So:
The public exponent is: e=3 

Each recipient has their own modulus: Ni​=pi​×qi

And there is no padding here.

Since all recipients got the same message m, this setup is vulnerable to Hastad’s broadcast attack.

Based on this informations, our ciphertexts are:

$$ c1​=m^3modN1​,c2​=m^3modN2​,c3​=m^3modN3​ $$




## Why the attack works (intuition + math)

If we can combine the three congruences above into a single integer (M) that satisfies all of them simultaneously, then that integer will be congruent to (m^3) modulo the product (N_1 N_2 N_3). Concretely, using the Chinese Remainder Theorem (CRT) we compute an integer

$$
M = \text{CRT}(c_1, c_2, c_3) ;\text{such that}; M \equiv m^3 \pmod{N_1 N_2 N_3}.
$$

If the original message integer (m) is small enough so that

$$
m^3 < N_1 N_2 N_3,
$$

then CRT yields the exact value

$$
M = m^3
$$

 Once we have (m^3) as a plain integer, we compute the integer cube root:

$$
m = \left\lfloor \sqrt[3]{M} \right\rfloor
$$

and convert (m) back to bytes to obtain the original plaintext.



1. Download the provided `generate.py` to inspect how the challenge was generated (confirms `e = 3`, same flag used, and a simple left-padding was applied).
2. Download `intercepted-messages` which contains the variables `N1, N2, N3, e1, e2, e3, encryptedMessage1, ...`.
3. Implement helper functions: modular inverse, CRT, integer k-th root, and integer-to-bytes conversion.
4. Use CRT to reconstruct (M = m^3) from the three ciphertexts.
5. Compute the integer cube root of (M) to obtain (m).
6. Convert (m) to bytes and print the recovered plaintext.

---

## Key formulas used

* Ciphertexts:

  (;c_i \equiv m^e \pmod{N_i};)

* Chinese Remainder Theorem (constructive form used programmatically):

  Let (P = \prod_{i=1}^3 N_i) and for each (i) let (p_i = P / N_i). Then

  $$
  M = \sum_{i=1}^3 c_i \cdot p_i \cdot (p_i^{-1} \bmod N_i) \quad(\bmod; P).
  $$

  The value (M) satisfies (M \equiv c_i \pmod{N_i}) for all (i), and for our situation it equals (m^e) as an integer when (m^e < P).

* Integer root (for (e=3)):

  Compute (m = \mathrm{iroot}(3, M)), i.e. the integer cube root. We verify by checking

  $$
  m^3 = M.
  $$

---

## Python helpers (conceptual)

Here are the small helper functions used (the actual script used in the assignment includes these implementations):

* `mul_inv(a, b)` — modular inverse of `a` modulo `b` (extended Euclidean algorithm).
* `chinese_remainder(mods, rems)` — reconstruct an integer satisfying congruences using CRT.
* `iroot(k, n)` — integer k-th root (Newton's method or an integer-Newton iteration).
* `long_to_bytes(n)` — convert integer back to big-endian byte string.

These are combined as follows:

```python
M = chinese_remainder([N1, N2, N3], [c1, c2, c3])  ### this is reconstruct m^e
m = iroot(3, M)                                    ### for integer cube root
plaintext = long_to_bytes(m)
```

---

## How to reproduce (commands)

1. Save `intercepted-messages` in the same folder as the solver script.
2. Run the solver (example):

```bash
python3 solve_bbc.py
```

If you run on Windows PowerShell and see encoding issues, re-save the script as UTF-8 and run with `py -3 solve_bbc.py`.

---

## Example output (the recovered message)

After running the script, the recovered plaintext bytes looked like this (raw):

```
b'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}'
```

Decoded UTF-8 (trimmed padding shown as `A`):

```
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}
```

So the flag is:

```
FLAG{l1n34r_tv_1s_d34d!}
```

---

## Security takeaways

* Never use deterministic RSA encryption without randomized padding. Modern deployments should use RSA-OAEP or an authenticated hybrid encryption scheme (e.g., encrypt a random symmetric key with RSA-OAEP, then use AES‑GCM for the message).
* Reusing the same message under the same small public exponent to multiple recipients is insecure.
* Small public exponents (like 3) are not inherently broken, but they require correct padding and protocol design.

---

