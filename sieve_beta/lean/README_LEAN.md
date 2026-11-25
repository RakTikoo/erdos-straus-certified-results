# Lean component — SIEVE-beta(151, 5), machine-checked

> Disclosure: this work is AI-driven analysis submitted for independent
> checking.

Files:
- `SieveBeta.lean` — statement only. It defines the elementary
  primality predicate, the discrete-log relation base 6 mod 151,
  the non-residue predicate, the factor-log predicate, the
  gcd-exactly-5 predicate, the one-instance statement
  `SieveBetaInstance151_5 n` (clauses (i)–(v)), and the statement
  `SieveBeta151_5`: there exists a prime n satisfying (i)–(v).
  Core Lean only (`import Init`); no Mathlib.
- `SieveBetaWitness.lean` — the proof. It proves
  `theorem sieveBeta151_5_witness : SieveBeta151_5` by the witness
  n = 1321, clause by clause, using decidable reformulations of the
  predicates (bounded divisor balls for primality, a finite residue
  check for the non-residue clause, a divisor characterisation of
  368 = 2^4 * 23, and the period-150 reduction for logs base 6).
  It imports `SieveBeta.lean`; the statement file is not modified
  by the proof file.

The two .lean files are byte-identical to the versions whose hashes
are listed in the package manifest (BUNDLE_MANIFEST.md at the
package root); the proof file's SHA-256 is
dafcc7e84325fdf50ae4a996a443e3b1bd8dcea88d2bc4ffed0f0ab7e992e8f2
and the statement file's is
02c7a9b535078e59b8240976efb2de5fded108b2c4b41641fba5ba9f4198b3ec.

## How to check

Requirements: Lean 4.36.0 (the toolchain the proof was built and
re-checked with; install via elan, e.g. `elan toolchain install
leanprover/lean4:v4.36.0`). No Mathlib, no other dependencies.

From this directory:

```sh
lean -o SieveBeta.olean SieveBeta.lean
LEAN_PATH=. lean -o SieveBetaWitness.olean SieveBetaWitness.lean
```

Expected: both files compile with no errors, and the second command
prints exactly

```
'sieveBeta151_5_witness' depends on axioms: [propext, Quot.sound]
```

Checks a reviewer can run in seconds:
- `grep -c sorry SieveBeta.lean SieveBetaWitness.lean` prints 0 for
  both files: there are no placeholder proofs, and `sorryAx` does
  not appear in the axiom list above.
- The axiom list contains only standard core axioms; even
  `Classical.choice` is not used.

## Scope of the proof

The theorem proved is the formalised statement `SieveBeta151_5`
and nothing else: a decided instance of a named statement inside
Dahan's framework. It is not a proof of, or progress on, the
Erdős–Straus conjecture, and the general statement
SIEVE-beta(p, d) for d > 1 remains open. See the package root
CLAIM.md and SCOPE.md.
