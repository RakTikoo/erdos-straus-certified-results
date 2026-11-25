# Two certified computational results on Erdős–Straus-type statistics

> Disclosure: this work is AI-driven analysis submitted for independent
> checking. Every number in this package can be reproduced from the
> included code and data; nothing here requires trusting the prose.

This package contains two independent, self-verifying computational
components. The exact claims are stated in CLAIM.md (the comparator
file); SCOPE.md states what each component does and does not cover;
NOVELTY.md gives the graded novelty verdict with its search limits.
No claim about the Erdős–Straus conjecture itself is made anywhere
in this package.

## Component 1 — a certified extremal set (extremal_set/)

Under the frozen definitions in CLAIM.md (a margin statistic over
shift primes up to the bound B_7(n) = int((ln n)^7)), the following
21 primes are certified to satisfy H(n) = 0 at A = 7 — the margin is
exactly 0 at every non-residue shift in range:

193, 3361, 4153, 8017, 52081, 137713, 140617, 144817, 391393,
460777, 1793017, 1986097, 2060137, 2074417, 2183833, 2595793,
3380017, 4269721, 12331897, 23465017, 39579313.

This is a certified computational result at its stated bounds. The
set is complete for n <= 10^7 at the census scope stated in
SCOPE.md, with the three largest members coming from decided
tranche ranges beyond 10^7. Within the set, the smallest budget
gap G is attained by 391393, with G = 3/16. Per-prime certificate
data (bound, shift count C(n), G(n), argmin and first-25
configurations, and the basis for each entry) is in
extremal_set/certificates.json; the underlying computation outputs
are in extremal_set/source_data/.

Re-check it yourself (Python 3, standard library only):

```sh
cd extremal_set
python3 verify_extremal.py --n 391393     # one prime
python3 verify_extremal.py --all          # all 21 (hours of CPU)
```

The verifier recomputes both independent paths and the brute-force
sample from the definitions, compares every value against
certificates.json, and refuses loudly — nonzero exit, no output —
if a supplied shift file does not cover the full bound. It never
certifies a truncated range. Verification outputs from a full run
of this verifier over all 21 primes, performed on this package as
assembled, are in extremal_set/verification/.

## Component 2 — SIEVE-beta(151, 5), decided (sieve_beta/)

SIEVE-beta(151, 5) is a named statement inside Dahan's framework
for the Erdős–Straus problem (the instance (p, d) = (151, 5) of
SIEVE-beta(p, d); formalised in sieve_beta/lean/SieveBeta.lean).
It is decided TRUE, witnessed by the prime n = 1321:

- K = (1321 + 151)/4 = 368 = 2^4 * 23;
- the factor logs base 6 mod 151 are 70 (for 2) and 115 (for 23);
- gcd(70, 115, 150) = 5 exactly.

The count of such primes up to 10^6 is N_{151,5}(10^6) = 321, with
1321 the smallest; two independent implementations
(sieve_beta/count_main.py, sieve_beta/count_check.py) agree on the
count and on the full hit list (sieve_beta/count_output.json,
sieve_beta/count_check_output.json), and sieve_beta/verify_witness.py
re-checks the witness clause by clause and recomputes all 321 hits
from scratch. The formalised statement is also proved in Lean:
sieve_beta/lean/SieveBetaWitness.lean proves it in core Lean, no
Mathlib, zero sorry, axioms [propext, Quot.sound] — see
sieve_beta/lean/README_LEAN.md for the two commands that check it.

Component 2 is a decided instance of a framework statement. It is
not progress on the Erdős–Straus conjecture itself, and the
general statement SIEVE-beta(p, d) for d > 1 remains open.

## Package layout

- CLAIM.md — the exact claimed statements, standalone.
- SCOPE.md — coverage and non-coverage, per component.
- NOVELTY.md — the graded novelty verdict and the search limits.
- BUNDLE_MANIFEST.md — SHA-256 for every file in the package.
- extremal_set/ — certificates.json, verify_extremal.py,
  source_data/ (the computation outputs behind each entry),
  verification/ (this package's own re-verification outputs).
- sieve_beta/ — count_main.py, count_check.py, their outputs,
  verify_witness.py, and lean/ (statement file, proof file,
  README_LEAN.md).
