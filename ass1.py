
from math import gcd

alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}><|"
m = len(alphabet)
idx = {ch:i for i,ch in enumerate(alphabet)}

ciphertext = "XL7V2sCOKWSIICsCg}W}qeWGqgWgEKkK0"

def modinv(a, m):
    return pow(a, -1, m)

def decrypt(ct, a, b):
    a_inv = modinv(a, m)
    return ''.join(alphabet[(a_inv*(idx[ch]-b))%m] if ch in idx else ch for ch in ct)

for a in range(1, m):
    if gcd(a, m) != 1: continue
    for b in range(m):
        pt = decrypt(ciphertext, a, b)
        if "flag{" in pt.lower() or "FLAG{" in pt:
            print(f"FOUND: a={a}, b={b} -> {pt}")

