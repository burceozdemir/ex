## In question E1.6 BBC sent us a encrypted message(m). When I opened the challange link, this is our output:

<img width="1753" height="822" alt="photo1" src="https://github.com/user-attachments/assets/034143f2-0a2f-4e06-82db-c237d16f5f12" />



Each recipient has their own modulus (N_i = p_i q_i). The public exponent is the same for all recipients: (e = 3). No padding was used.

The three ciphertexts are

  $$
  c_1 \equiv m^3 \pmod{N_1},\quad
  c_2 \equiv m^3 \pmod{N_2},\quad
  c_3 \equiv m^3 \pmod{N_3}.
  $$

---


If we can combine the three congruences above into a single integer (M) that satisfies all of them simultaneously, then that integer will be congruent to (m^3) modulo the product (N_1 N_2 N_3). Concretely, using the Chinese Remainder Theorem (CRT) we compute an integer

$$
M = \text{CRT}(c_1, c_2, c_3) ;\text{such that}; M \equiv m^3 \pmod{N_1 N_2 N_3}.
$$

If the original message integer (m) is small enough so that

$$
m^3 < N_1 N_2 N_3,
$$

then CRT yields us the exact value

$$
M = m^3
$$

Once we have (m^3) as a plain integer, we compute the integer cube root:

$$
m = \left\lfloor \sqrt[3]{M} \right\rfloor
$$

and convert (m) back to bytes to obtain the original plaintext.



---

What I did? (Step by step)


1. Download the provided `generate.py` to inspect how the challenge was generated (confirms `e = 3`, same flag used, and a simple left-padding was applied).

<img width="1898" height="943" alt="photo2" src="https://github.com/user-attachments/assets/32ecec5f-0ac5-4579-bd67-4d0921466b99" />

   <img width="1918" height="945" alt="photo3" src="https://github.com/user-attachments/assets/2042e1cd-06e1-42c0-803c-89dcfcc3e20f" />

2. Download `intercepted-messages` which contains the variables `N1, N2, N3, e1, e2, e3, encryptedMessage1, ...`.

  <img width="1919" height="542" alt="photo4" src="https://github.com/user-attachments/assets/272388be-b6e2-4f8e-a826-0d86d5701fe9" />

   
3. Implement helper functions: modular inverse, CRT, integer k-th root, and integer-to-bytes conversion.
4. Use CRT to reconstruct (M = m^3) from the three ciphertexts.
5. Compute the integer cube root of (M) to obtain (m).
6. Convert (m) to bytes and print the recovered plaintext.

<img width="680" height="820" alt="photo5" src="https://github.com/user-attachments/assets/ad37c323-3ed9-47c1-9558-ea322da8156d" />


---



Mathematical Explanation

Ciphertexts:

  (;c_i \equiv m^e \pmod{N_i};)

Chinese Remainder Theorem:

  Let (P = \prod_{i=1}^3 N_i) and for each (i) let (p_i = P / N_i). Then

  $$
  M = \sum_{i=1}^3 c_i \cdot p_i \cdot (p_i^{-1} \bmod N_i) \quad(\bmod; P).
  $$

  The value (M) satisfies (M \equiv c_i \pmod{N_i}) for all (i), and for our situation it equals (m^e) as an integer when (m^e < P).

 Integer root (for (e=3)):

  Compute (m = \mathrm{iroot}(3, M)), i.e. the integer cube root. We verify by checking

  $$
  m^3 = M.
  $$

---

Where did I use Python helpers ?

 `mul_inv(a, b)` — modular inverse of `a` modulo `b` (extended Euclidean algorithm).
 `chinese_remainder(mods, rems)` — reconstruct an integer satisfying congruences using CRT.
`iroot(k, n)` — integer k-th root (Newton's method or an integer-Newton iteration).
`long_to_bytes(n)` — convert integer back to big-endian byte string.

These are combined as follows:

```python
M = chinese_remainder([N1, N2, N3], [c1, c2, c3])  # reconstruct m^e
m = iroot(3, M)                                    # integer cube root
plaintext = long_to_bytes(m)
```

---
Then, save `intercepted-messages` in the same folder as the solver script and run the solver (example):

```bash
python3 solve_bbc.py
```
I was running on Windows PowerShell and saw encoding issues, re-saved the script as UTF-8 and runned with `py -3 solve_bbc.py`.

---


After running the script, the recovered plaintext bytes looked like this:

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


---

If you want: I can also (a) produce a `solve_bbc.py` ready-to-run script in this repository, (b) add a short diagram showing the CRT combination, or (c) convert this README to a downloadable `.md` or `.pdf`. Let me know which you prefer.
