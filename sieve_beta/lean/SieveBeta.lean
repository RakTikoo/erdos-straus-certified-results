import Init
/-
  SieveBeta.lean — faithful formalisation (STATEMENT ONLY) of the
  smallest open SIEVE-β instance, (p, d) = (151, 5), as identified
  in theory/LINE_A.md §2.2–§2.3, with the clause text taken from
  lens1/CYCLE22_BETAPRIME_FINDINGS.md §2 as quoted in Line A §2.1
  and in lens1/CYCLE23_BETAPRIME_FINDINGS.md §4.

  Core Lean only (`import Init`). Core Lean has no `Nat.Prime`,
  so primality is defined elementarily below (`IsPrimeN`: the
  standard `2 ≤ n ∧ ∀ m ∣ n, m = 1 ∨ m = n`).

  Pilot data at p = 151 used here (all from the records named
  above): primitive root `g = 6`; `N = p − 1 = 150`; forced set
  `{2}` (so clause (v) is `2 ∣ (n + 151)/4`); predicted genuine
  strata `{1, 5}` with `G = gcd(70, 150) = 10`, `log₆(2) = 70`.
  Stratum `d = 1` at p = 151 is PROVEN in the pilot (Cycle 23);
  stratum `d = 5` is OPEN. Nothing in this file is a proof of the
  statement formalised here, and no claim about the
  Erdős–Straus conjecture is made.
-/

/-- Primality, elementary form (core Lean has no `Nat.Prime`). -/
def IsPrimeN (n : Nat) : Prop :=
  2 ≤ n ∧ ∀ m, m ∣ n → m = 1 ∨ m = n

/-- Discrete log base `6` modulo `151`, as a relation: `e` is a
    log of `q` iff `6^e ≡ q (mod 151)`. (6 is a primitive root
    mod 151 — pilot-verified, Cycle 23 §3 — so logs exist for
    every unit `q` and are unique modulo 150; the clauses below
    quantify over all logs, which is unambiguous because
    `5 ∣ e ↔ 5 ∣ e + 150`.) -/
def IsLog151 (q e : Nat) : Prop :=
  (6 ^ e) % 151 = q % 151

/-- Clause (ii)'s content, `(n / 151) = −1` (Legendre symbol):
    `n` is a quadratic non-residue modulo 151. -/
def IsNR151 (n : Nat) : Prop :=
  n % 151 ≠ 0 ∧ ∀ x, (x * x) % 151 ≠ n % 151

/-- The set of factor logs at `n`, as a predicate: `e` is a
    factor log iff some prime divisor `q` of `(n + 151)/4` has
    log `e` (base 6, mod 151). -/
def FactorLog151 (n e : Nat) : Prop :=
  ∃ q, IsPrimeN q ∧ q ∣ (n + 151) / 4 ∧ IsLog151 q e

/-- Clause (iv), `gcd({factor logs} ∪ {150}) = 5` exactly, stated
    through the divisibility characterisation of the gcd: 5 is a
    common divisor of every factor log (and of 150), and every
    common divisor of all factor logs that also divides 150
    already divides 5 — i.e. the gcd is 5, not a proper multiple
    of 5. -/
def GcdLogsIs5 (n : Nat) : Prop :=
  (∀ e, FactorLog151 n e → 5 ∣ e) ∧
  (∀ d, (∀ e, FactorLog151 n e → d ∣ e) → d ∣ 150 → d ∣ 5)

/-- **SIEVE-β(151, 5), one instance at a prime `n`** — clauses
    (i)–(v) of the pilot's SIEVE-β(p, d) specialised to
    `p = 151`, `d = 5`:
    (i) `n ≡ 1 (mod 24)`; (ii) `(n/151) = −1`;
    (iii) EVERY prime divisor `q` of `(n + 151)/4` satisfies
    `5 ∣ log₆ q`, i.e. `q mod 151 ∈ H₅`;
    (iv) the gcd of all factor logs together with `150` is
    exactly `5`; (v) the forced prime at `p = 151`, namely `2`,
    divides `(n + 151)/4`. -/
def SieveBetaInstance151_5 (n : Nat) : Prop :=
  IsPrimeN n ∧
  n % 24 = 1 ∧
  IsNR151 n ∧
  (∀ q, IsPrimeN q → q ∣ (n + 151) / 4 →
    ∀ e, IsLog151 q e → 5 ∣ e) ∧
  GcdLogsIs5 n ∧
  2 ∣ (n + 151) / 4

/-- **SIEVE-β(151, 5)** (the statement itself; OPEN in the
    pilot): there exists a prime `n` satisfying clauses
    (i)–(v). -/
def SieveBeta151_5 : Prop :=
  ∃ n, SieveBetaInstance151_5 n
