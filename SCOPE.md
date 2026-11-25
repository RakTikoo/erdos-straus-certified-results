# SCOPE — what this package covers, and what it does not

> Disclosure: this work is AI-driven analysis submitted for independent
> checking.

## Component 1 — the certified extremal set

Covered:
- Exactly the 21 primes listed in CLAIM.md Claim 1, each at the
  bound B_7(n) = int((ln n)^7) stated in
  extremal_set/certificates.json, under the frozen definitions in
  CLAIM.md. "Certified" means: two independent full-range
  computations agree on the NR-shift count C(n) and on a
  margin-positive count of exactly 0, and a brute-force sample over
  the argmin and first-25 shifts agrees with both. The per-prime
  basis is stated in certificates.json; the underlying computation
  outputs are in extremal_set/source_data/.
- The range-scoped completeness statement of CLAIM.md Claim 1b,
  at exactly the ranges and scope stated there.

Not covered:
- Any prime not in the list of 21, at any bound. In particular
  nothing here decides whether G < 3/16 occurs anywhere, or how
  the H = 0 set grows beyond 4*10^7.
- Any bound other than A = 7: H(n) at other exponents is a
  different quantity and is not computed here.
- The H = 0 property is a property of the stated margin statistic
  inside the stated framework. These primes are not counterexamples
  to anything, and no statement about the Erdős–Straus conjecture
  follows from Component 1.
- The four smallest members (193, 3361, 4153, 8017) carry no
  separately filed brute-force sample in the source data; their
  basis is the two agreeing full-range scans stated in
  certificates.json. The package verifier
  (extremal_set/verify_extremal.py) supplies its own brute-force
  sample check for all 21 primes uniformly.

## Component 2 — SIEVE-beta(151, 5)

Covered:
- The single instance (p, d) = (151, 5) of SIEVE-beta(p, d), as
  formalised in sieve_beta/lean/SieveBeta.lean: decided TRUE,
  witnessed at n = 1321, with the counting value
  N_{151,5}(10^6) = 321 and the attrition table in CLAIM.md.
- The Lean proof term in sieve_beta/lean/SieveBetaWitness.lean,
  which proves the formalised statement from the statement file
  included alongside it, in core Lean with no Mathlib, zero sorry,
  and axioms [propext, Quot.sound].

Not covered:
- SIEVE-beta(p, d) for any other (p, d), and the general statement
  for d > 1, which remains open. The analytic route to the general
  statement (an all-factor control input) is not in this package.
- The Erdős–Straus conjecture. Component 2 is a decided instance
  of a named statement inside Dahan's framework; it is not
  progress on the conjecture itself, and the package says so
  wherever the component is described.
- The counting value at any X other than 10^6.

## Whole package

- The novelty status is graded, not absolute: see NOVELTY.md.
  Nothing in this package asserts that any part of it is new to
  the literature; it asserts only what was and was not found in
  the search described there, with that search's limits stated.
- Verification is computational and exact (integer and Fraction
  arithmetic; the only floating-point use is the bound formula
  B_7(n) = int((ln n)^7), inherited verbatim from the frozen
  definitions). Any checker can reproduce every number from the
  included code and data without trusting this package's prose.
