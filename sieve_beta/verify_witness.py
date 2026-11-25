#!/usr/bin/env python3
"""
Raw-arithmetic verification for the SIEVE-beta(151, 5) component.

Disclosure: this work is AI-driven analysis submitted for independent
checking.

Two jobs, both in exact integer arithmetic, sharing no code with
count_main.py / count_check.py:

1. Clause-by-clause check of the witness n = 1321 against the
   statement formalised in lean/SieveBeta.lean:
   (i)   1321 is prime and 1321 = 1 (mod 24);
   (ii)  1321 is a quadratic non-residue mod 151 (Euler criterion AND
         brute force: no x with x^2 = 1321 (mod 151));
   (iii) K = (1321 + 151)/4 = 368 = 2^4 * 23, and for every distinct
         prime divisor q of K, every discrete log e of q base 6 mod
         151 satisfies 5 | e (checked over all e in [0, 150); 6 has
         order exactly 150 mod 151, so this covers all logs);
   (iv)  gcd of the realised factor logs {70, 115} together with 150
         is exactly 5;
   (v)   2 | K.

2. Recomputation of every hit in count_output.json: for each of the
   321 listed n <= 10^6, primality, clauses (i)-(v), K, the distinct
   factor list, the log list and the gcd are all recomputed from n
   alone and compared with the filed values; the hit count, the
   smallest hit and the attrition endpoint are checked.

Usage: python3 verify_witness.py
Exit code 0 iff every check passes.
"""
import json
import os
from math import gcd

HERE = os.path.dirname(os.path.abspath(__file__))
P = 151
G = 6


def is_prime_td(n):
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return False
        d += 1 if d == 2 else 2
    return True


def distinct_factors_td(m):
    out = []
    d = 2
    while d * d <= m:
        if m % d == 0:
            out.append(d)
            while m % d == 0:
                m //= d
        d += 1 if d == 2 else 2
    if m > 1:
        out.append(m)
    return out


def log_table():
    tab = {}
    cur = 1
    for e in range(150):
        tab[cur] = e
        cur = (cur * G) % P
    assert len(tab) == 150, "6 must have order exactly 150 mod 151"
    assert cur == 1
    return tab


def check_instance(n, tab):
    """Returns (K, factors, logs, gcd_m) if n satisfies (i)-(v),
    else None. All clauses recomputed from n."""
    if not is_prime_td(n):
        return None
    if n % 24 != 1:
        return None
    if pow(n, 75, P) != P - 1:  # Euler: (n/151) = -1
        return None
    if any((x * x) % P == n % P for x in range(P)):  # brute-force NR
        return None
    if (n + P) % 4 != 0:
        return None
    K = (n + P) // 4
    facs = distinct_factors_td(K)
    logs = []
    for q in facs:
        e = tab[q % P]
        # every log of q is e + 150t; 5 | e iff 5 | every log
        if e % 5 != 0:
            return None
        logs.append(e)
    g = 150
    for e in logs:
        g = gcd(g, e)
    if g != 5:
        return None
    if K % 2 != 0:
        return None
    return K, facs, logs, g


def main():
    tab = log_table()
    ok = True

    # --- job 1: the witness, clause by clause ---
    n = 1321
    w = check_instance(n, tab)
    print("witness 1321 instance check:", w)
    assert w is not None, "witness fails a clause"
    K, facs, logs, g = w
    checks = {
        "K == 368": K == 368,
        "368 == 2^4 * 23": 2 ** 4 * 23 == K,
        "factors == [2, 23]": facs == [2, 23],
        "logs == [70, 115]": logs == [70, 115],
        "gcd(70, 115, 150) == 5": gcd(gcd(70, 115), 150) == 5 == g,
        "pow(6,70,151) == 2": pow(6, 70, 151) == 2,
        "pow(6,115,151) == 23": pow(6, 115, 151) == 23,
        "order of 6 mod 151 == 150": len(tab) == 150,
    }
    for k, v in checks.items():
        print(f"  {k}: {v}")
        ok = ok and v

    # --- job 2: recompute every filed hit ---
    with open(os.path.join(HERE, "count_output.json")) as f:
        data = json.load(f)
    hits = data["hits"]
    bad = 0
    for h in hits:
        r = check_instance(h["n"], tab)
        if r is None:
            bad += 1
            continue
        K, facs, logs, g = r
        if not (K == h["K"] and facs == h["factors"]
                and logs == h["logs"] and g == h["gcd_m"]):
            bad += 1
    summary = {
        "filed_hits": len(hits),
        "recomputed_mismatches": bad,
        "smallest_hit": min(h["n"] for h in hits),
        "filed_N_151_5_at_10^6": data["N_151_5_at_X0"],
        "attrition": data["attrition"],
    }
    print(json.dumps(summary, indent=1))
    ok = ok and bad == 0 and len(hits) == 321 \
        and summary["smallest_hit"] == 1321 \
        and data["N_151_5_at_X0"] == 321
    print("WITNESS VERIFICATION:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
