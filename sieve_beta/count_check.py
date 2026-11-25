#!/usr/bin/env python3
"""
Disclosure: this work is AI-driven analysis submitted for independent checking.
"""
"""Cycle 34 H3 Part B INDEPENDENT SECOND PATH for N_{151,5}(X0).
Deliberately different implementation from cycle34_h3_count1515.py:
 - primality by deterministic trial division (no sieve, no SPF);
 - candidates enumerated directly as n = 24t+1 (no prime list);
 - Legendre (n/151) by counting square roots: n is NR iff no x with
   x^2 = n (mod 151) (brute force over x), not Euler's criterion;
 - factorisation of K by trial division;
 - discrete log base 6 by iterated multiplication per query with a
   step-by-step power walk, not a precomputed table lookup built the
   same way (walk recomputed from 1 for each q);
 - gcd by Euclid written out inline.
Usage: python3 theory/cycle34_h3_count1515_check.py [X0] [ref.json] [out.json]
Compares its hit list against the main path's JSON when ref is given.
"""
import sys, json, time


def is_prime_td(n):
    if n < 2:
        return False
    if n % 2 == 0:
        return n == 2
    d = 3
    while d * d <= n:
        if n % d == 0:
            return False
        d += 2
    return True


def factor_td(m):
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


def dlog6(q):
    target = q % 151
    cur = 1
    for e in range(150):
        if cur == target:
            return e
        cur = (cur * 6) % 151
    return None


def euclid(a, b):
    while b:
        a, b = b, a % b
    return a


def is_nr_bruteforce(n):
    r = n % 151
    if r == 0:
        return False
    for x in range(151):
        if (x * x) % 151 == r:
            return False
    return True


def main():
    X0 = int(sys.argv[1]) if len(sys.argv) > 1 else 1000000
    ref_path = sys.argv[2] if len(sys.argv) > 2 else None
    out_path = sys.argv[3] if len(sys.argv) > 3 else "results/cycle34_h3_count1515_check.json"
    t0 = time.time()
    stages = {"i_candidates_1mod24": 0, "0prime": 0, "ii_NR": 0,
              "iii": 0, "iv": 0, "v": 0}
    hits = []
    n = 1
    while n <= X0:
        if n % 24 == 1:
            stages["i_candidates_1mod24"] += 1
            if is_prime_td(n):
                stages["0prime"] += 1
                if is_nr_bruteforce(n):
                    stages["ii_NR"] += 1
                    K = (n + 151) // 4
                    facs = factor_td(K)
                    logs = [dlog6(q) for q in facs]
                    if all(e is not None and e % 5 == 0 for e in logs):
                        stages["iii"] += 1
                        m = 150
                        for e in logs:
                            m = euclid(m, e)
                        if m == 5:
                            stages["iv"] += 1
                            if K % 2 == 0:
                                stages["v"] += 1
                                hits.append({"n": n, "K": K, "factors": facs,
                                             "logs": logs, "gcd_m": m})
        n += 1
    t1 = time.time()
    res = {"X0": X0, "attrition_check_path": stages, "N_check": len(hits),
           "hits": hits, "total_seconds": round(t1 - t0, 3)}
    agree = None
    if ref_path:
        ref = json.load(open(ref_path))
        agree = (ref["hits"] == hits)
        res["agrees_with_main_path_hit_list"] = agree
        res["main_path_attrition"] = ref["attrition"]
    with open(out_path, "w") as f:
        json.dump(res, f, indent=1)
    print(json.dumps(res, indent=1))
    print("AGREE" if agree else ("NO-REF" if agree is None else "DISAGREE"))


if __name__ == "__main__":
    main()
