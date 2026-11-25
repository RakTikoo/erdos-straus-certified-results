#!/usr/bin/env python3
"""
Disclosure: this work is AI-driven analysis submitted for independent checking.
"""
"""Cycle 34 H3 Part B: exact counting function N_{151,5}(x) at x = X0 with a
clause-by-clause attrition table. Clauses (SieveBeta.lean specialised):
 (0) n prime, n <= X0; (i) n = 1 (mod 24); (ii) (n/151) = -1;
 (iii) every prime divisor q of (n+151)/4 has 5 | log_6 q;
 (iv) gcd(factor logs + {150}) = 5 exactly; (v) 2 | (n+151)/4.
Exact integer arithmetic only.
Usage: python3 theory/cycle34_h3_count1515.py [X0] [out.json]
"""
import sys, json, time
from math import gcd

P = 151
G = 6


def spf_sieve(limit):
    spf = list(range(limit + 1))
    i = 2
    while i * i <= limit:
        if spf[i] == i:
            for j in range(i * i, limit + 1, i):
                if spf[j] == j:
                    spf[j] = i
        i += 1
    return spf


def distinct_factors(m, spf):
    out = []
    while m > 1:
        q = spf[m]
        out.append(q)
        while m % q == 0:
            m //= q
    return out


def main():
    X0 = int(sys.argv[1]) if len(sys.argv) > 1 else 1000000
    out_path = sys.argv[2] if len(sys.argv) > 2 else "results/cycle34_h3_count1515.json"
    t0 = time.time()
    logtab = {}
    cur = 1
    for e in range(150):
        logtab[cur] = e
        cur = (cur * G) % P
    assert len(logtab) == 150
    spf = spf_sieve((X0 + P) // 4 + 1)
    # prime list by simple sieve
    is_composite = bytearray(X0 + 1)
    primes = []
    for i in range(2, X0 + 1):
        if not is_composite[i]:
            primes.append(i)
            if i * i <= X0:
                for j in range(i * i, X0 + 1, i):
                    is_composite[j] = 1
    stages = {"0_prime_le_X0": len(primes), "i_n_eq_1_mod_24": 0,
              "ii_legendre_NR": 0, "iii_all_factor_logs_div5": 0,
              "iv_gcd_exactly_5": 0, "v_forced_2_divides_K": 0}
    hits = []
    for n in primes:
        if n % 24 != 1:
            continue
        stages["i_n_eq_1_mod_24"] += 1
        if pow(n, 75, P) != P - 1:
            continue
        stages["ii_legendre_NR"] += 1
        K = (n + P) // 4
        facs = distinct_factors(K, spf)
        logs = [logtab[q % P] for q in facs]
        if not all(e % 5 == 0 for e in logs):
            continue
        stages["iii_all_factor_logs_div5"] += 1
        m = 150
        for e in logs:
            m = gcd(m, e)
        if m != 5:
            continue
        stages["iv_gcd_exactly_5"] += 1
        if K % 2 != 0:
            continue
        stages["v_forced_2_divides_K"] += 1
        hits.append({"n": n, "K": K, "factors": facs, "logs": logs, "gcd_m": m})
    t1 = time.time()
    res = {"p": 151, "d": 5, "X0": X0, "attrition": stages,
           "N_151_5_at_X0": len(hits), "hits": hits,
           "total_seconds": round(t1 - t0, 3)}
    with open(out_path, "w") as f:
        json.dump(res, f, indent=1)
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    main()
