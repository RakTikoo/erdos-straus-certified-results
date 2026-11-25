# CLAIM — the exact statements claimed by this package

> Disclosure: this work is AI-driven analysis submitted for independent
> checking.

This file is the comparator. It states, standalone, exactly what is
claimed. If any summary, headline or description of this package says
more than this file allows, that summary is wrong. Wording rule for
the whole package: no novelty, priority or exclusivity language is
used or implied anywhere; the novelty status is the graded statement
in NOVELTY.md and nothing stronger.

## Component 1 — the certified extremal set

Definitions (frozen). For a prime n with n = 1 (mod 24), let
B_7(n) = int((ln n)^7). For each prime p = 3 (mod 4) with p <= B_7(n)
such that n is a quadratic non-residue mod p (an "NR shift"), let
K = (n + p)/4, let qs be the distinct prime factors of K, k = len(qs),
let c_g be the subset-product counts of qs modulo p,
R = sum_g c_g^2, N_{-1} = sum_g c_g * c_{-g mod p},
margin(n, p) = (p - 1) * N_{-1} / 4^k,
PhiS = (p - 1) * R / 4^k, Hord = lcm_i ord_p(q_i), m = (p - 1)/Hord,
budget gap g(n, p) = PhiS - 2m. H(n) is the maximum of margin(n, p)
over the NR shifts; G(n) is the minimum of g(n, p); C(n) is the
number of NR shifts.

CLAIM 1 (a certified computational result at its stated bounds).
For each of the 21 primes n listed in extremal_set/certificates.json —
193, 3361, 4153, 8017, 52081, 137713, 140617, 144817, 391393, 460777,
1793017, 1986097, 2060137, 2074417, 2183833, 2595793, 3380017,
4269721, 12331897, 23465017, 39579313 — margin(n, p) is exactly 0 at
every NR shift p <= B_7(n); equivalently H(n) = 0 at A = 7. For each
n the certificate data in extremal_set/certificates.json states
B_7(n), C(n), G(n), the argmin configuration(s) attaining G(n), and
(for 17 of the 21) the first 25 NR-shift configurations; each entry
was established by two independent full-range computations agreeing
on C(n) and on a margin-positive count of 0, plus a brute-force
sample check, as detailed per prime in certificates.json and in
extremal_set/source_data/.

CLAIM 1a (hardest member, comparative within this set only).
Within the 21 primes of Claim 1, the smallest G value is attained by
n = 391393, with G(391393) = 3/16. This is a comparison inside the
set; it asserts nothing about any prime outside the set.

CLAIM 1b (completeness, range-scoped). The censuses behind the
source data decided every prime in the ranges [100, 10^6],
(10^6, 2*10^6] and (2*10^6, 10^7]; within those ranges the H = 0
primes are exactly the 18 listed members not exceeding 10^7. Beyond
10^7, the tranche ranges (10^7, 2*10^7] and (2*10^7, 4*10^7] were
decided at the same screen scope, contributing exactly 12331897,
23465017 and 39579313 respectively as the additional H = 0 members
found there. No completeness is claimed for n > 4*10^7, and whether
G < 3/16 occurs for any prime is not decided by this package.

## Component 2 — the SIEVE-beta(151, 5) decision

The statement SIEVE-beta(151, 5) is the instance (p, d) = (151, 5)
of the statement family SIEVE-beta(p, d) inside Dahan's framework
for the Erdős–Straus problem, specialised as follows (the formalised
form is lean/SieveBeta.lean): there exists a prime n with
(i) n = 1 (mod 24); (ii) n is a quadratic non-residue mod 151;
(iii) for every prime divisor q of (n + 151)/4, every discrete log
of q base 6 mod 151 is divisible by 5; (iv) the gcd of all such
factor logs together with 150 is exactly 5; (v) 2 divides
(n + 151)/4.

CLAIM 2. SIEVE-beta(151, 5) is TRUE, witnessed by n = 1321:
1321 is prime, 1321 = 1 (mod 24), 1321 is a non-residue mod 151,
K = (1321 + 151)/4 = 368 = 2^4 * 23, the factor logs are
log_6(2) = 70 and log_6(23) = 115, both divisible by 5, and
gcd(70, 115, 150) = 5 exactly. The count of such primes up to 10^6
is N_{151,5}(10^6) = 321, with 1321 the smallest; the clause-by-clause
attrition is 78,498 primes up to 10^6 -> 9,732 after (i) -> 4,926
after (ii) -> 321 after (iii) -> 321 after (iv) -> 321 after (v).
Evidence: two independent implementations (sieve_beta/count_main.py
and sieve_beta/count_check.py) agree on the count and on the full
321-entry hit list (sieve_beta/count_output.json,
sieve_beta/count_check_output.json), and the formalised statement
is proved in Lean (lean/SieveBetaWitness.lean: theorem
sieveBeta151_5_witness, core Lean only, no Mathlib, zero sorry,
axioms [propext, Quot.sound]).

CLAIM 2a (what Claim 2 is not). Claim 2 is a decided instance of a
named statement inside Dahan's framework. It is not progress on the
Erdős–Straus conjecture itself, and nothing in this package claims
or implies such progress. The general statement SIEVE-beta(p, d)
for d > 1 remains open; deciding it would require an analytic
argument (an all-factor control input) that this package does not
contain. The witness n = 1321 was already present in the underlying
research programme's internal files before the counting and Lean
work packaged here; this component consolidates and machine-checks
that instance, and makes no discovery claim for it.

## What is not claimed anywhere in this package

- No solution, partial solution or progress claim for the
  Erdős–Straus conjecture.
- No statement about H(n) or G(n) for any prime outside Claim 1,
  and no statement about SIEVE-beta(p, d) for any (p, d) other
  than (151, 5).
- No novelty, priority or exclusivity claim: see NOVELTY.md for the
  graded verdict and its search limits.
