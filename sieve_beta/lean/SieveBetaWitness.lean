import Init
import SieveBeta
/-
  SieveBetaWitness.lean — discharge of obligation O12 of
  theory/SIEVE_BETA_151_5_MAP.md: a Lean proof term witnessing
  `SieveBeta151_5` at n = 1321.

  Core Lean only (`import Init`), no Mathlib, no placeholder
  proofs, no added axioms. The statement file `SieveBeta.lean` is NOT
  edited; this file imports it.

  The blocker named in the map (O12) is that the formalisation's
  predicates are not in decidable form (`IsNR151` quantifies over
  all of Nat; clause (iii) over all prime divisors and all logs;
  `GcdLogsIs5` over all factor logs and common divisors). The
  route taken here is a decidable reformulation per clause:

  - primality of the concrete primes (1321, 2, 23): a bounded
    divisor ball `∀ m < B, m ∣ n → m = 1 ∨ m = n`, closed by
    `decide` (core `Nat.decidableBallLT`), then lifted to the
    unbounded `IsPrimeN` via `Nat.le_of_dvd`;
  - clause (ii) at 1321: `(x*x) % 151` depends only on `x % 151`
    (`Nat.mul_mod`), and `1321 % 151 = 113`; the 151 residues are
    checked by `decide`;
  - the prime divisors of K = (1321+151)/4 = 368 are exactly
    {2, 23}: a bounded nested-ball `decide` (with the `2 ≤ q`
    hypothesis of `IsPrimeN` carried as a conjunction, which is
    the form core's instance synthesis accepts);
  - logs: 6 has order 150 mod 151 (`(6^150) % 151 = 1` by
    `decide`), so `6^e % 151 = 6^(e % 150) % 151`
    (`pow6_mod_period`); the finitely many residues
    `r < 150` with `6^r % 151 ∈ {2, 23}` all satisfy `5 ∣ r`
    (checked by `decide`), and `5 ∣ e % 150 → 5 ∣ e` since
    `5 ∣ 150`;
  - clause (iv): part 1 is clause (iii) itself; part 2 uses the
    two realised factor logs 70 (prime 2) and 115 (prime 23):
    any common divisor `d` divides `Nat.gcd 70 115 = 5`
    (`Nat.dvd_gcd`).

  Home facts used (re-verified in Lean as they are used):
  1321 prime; 1321 % 24 = 1; 1321 % 151 = 113, a non-residue;
  K = 368 = 2^4 * 23; log_6(2) = 70, log_6(23) = 115;
  gcd(70, 115, 150) = 5; 2 ∣ 368.
-/

/-! ### Elementary power lemmas (core Lean has no `pow_add` /
    `pow_mul` for Nat under those names; proved by induction). -/

theorem pow_add' (a m n : Nat) : a ^ (m + n) = a ^ m * a ^ n := by
  induction n with
  | zero => simp
  | succ k ih => rw [Nat.add_succ, Nat.pow_succ, ih, Nat.pow_succ, Nat.mul_assoc]

theorem pow_mul' (a m n : Nat) : a ^ (m * n) = (a ^ m) ^ n := by
  induction n with
  | zero => simp
  | succ k ih => rw [Nat.mul_succ, pow_add', ih, Nat.pow_succ]

/-! ### Primality from a bounded divisor ball. -/

theorem isPrimeN_of_ball {n B : Nat} (hn : 2 ≤ n) (hB : n < B)
    (h : ∀ m, m < B → m ∣ n → m = 1 ∨ m = n) : IsPrimeN n := by
  refine ⟨hn, ?_⟩
  intro m hm
  have hle : m ≤ n := Nat.le_of_dvd (by omega) hm
  exact h m (by omega) hm

set_option maxRecDepth 8192 in
theorem ball_1321 : ∀ m, m < 1322 → m ∣ 1321 → m = 1 ∨ m = 1321 := by
  decide

theorem prime_1321 : IsPrimeN 1321 :=
  isPrimeN_of_ball (by decide) (by decide) ball_1321

theorem ball_2 : ∀ m, m < 3 → m ∣ 2 → m = 1 ∨ m = 2 := by decide

theorem prime_2 : IsPrimeN 2 :=
  isPrimeN_of_ball (by decide) (by decide) ball_2

theorem ball_23 : ∀ m, m < 24 → m ∣ 23 → m = 1 ∨ m = 23 := by decide

theorem prime_23 : IsPrimeN 23 :=
  isPrimeN_of_ball (by decide) (by decide) ball_23

/-! ### Clause (ii): 1321 is a quadratic non-residue mod 151. -/

theorem nr_check : ∀ r, r < 151 → (r * r) % 151 ≠ 113 := by decide

theorem nr_1321 : IsNR151 1321 := by
  refine ⟨by decide, ?_⟩
  intro x
  have h1 : (x * x) % 151 = ((x % 151) * (x % 151)) % 151 := Nat.mul_mod x x 151
  have h2 : (1321 : Nat) % 151 = 113 := rfl
  rw [h1, h2]
  exact nr_check (x % 151) (Nat.mod_lt x (by decide))

/-! ### Logs base 6 mod 151: period 150, and the finite log check. -/

theorem pow150_mod_one : ∀ k, ((6 ^ 150) ^ k) % 151 = 1 := by
  have h150 : (6 ^ 150) % 151 = 1 := by decide
  intro k
  induction k with
  | zero => rfl
  | succ k ih => rw [Nat.pow_succ, Nat.mul_mod, ih, h150]

theorem pow6_mod_period (e : Nat) : (6 ^ e) % 151 = (6 ^ (e % 150)) % 151 := by
  calc (6 ^ e) % 151
      = ((6 ^ 150) ^ (e / 150) * 6 ^ (e % 150)) % 151 := by
          congr 1
          rw [← pow_mul', ← pow_add', Nat.div_add_mod]
    _ = (6 ^ (e % 150)) % 151 := by
          rw [Nat.mul_mod, pow150_mod_one, Nat.one_mul, Nat.mod_mod]

theorem log_check :
    ∀ r, r < 150 → (6 ^ r % 151 = 2 ∨ 6 ^ r % 151 = 23) → 5 ∣ r := by
  decide

/-- Every log (base 6, mod 151) of a unit whose residue is 2 or 23
    is divisible by 5. -/
theorem five_dvd_of_isLog {q e : Nat}
    (hq : q % 151 = 2 ∨ q % 151 = 23) (h : IsLog151 q e) : 5 ∣ e := by
  have h' : (6 ^ e) % 151 = q % 151 := h
  rw [pow6_mod_period] at h'
  have h5 : 5 ∣ e % 150 := by
    apply log_check (e % 150) (Nat.mod_lt e (by decide))
    rcases hq with hq | hq
    · exact Or.inl (h'.trans hq)
    · exact Or.inr (h'.trans hq)
  rcases h5 with ⟨w, hw⟩
  exact ⟨30 * (e / 150) + w, by
    have hdiv := Nat.div_add_mod e 150
    omega⟩

/-! ### Clause (iii): the prime divisors of 368 are exactly 2, 23. -/

set_option maxRecDepth 8192 in
theorem divisors_368 :
    ∀ q, q < 369 →
      (2 ≤ q ∧ q ∣ 368 ∧ (∀ m, m < 369 → m ∣ q → m = 1 ∨ m = q)) →
      q = 2 ∨ q = 23 := by
  decide

theorem clause_iii :
    ∀ q, IsPrimeN q → q ∣ (1321 + 151) / 4 →
      ∀ e, IsLog151 q e → 5 ∣ e := by
  intro q hq hqd e hloge
  have hK : (1321 + 151) / 4 = 368 := rfl
  rw [hK] at hqd
  have hqle : q ≤ 368 := Nat.le_of_dvd (by decide) hqd
  have hq2 : q = 2 ∨ q = 23 :=
    divisors_368 q (by omega) ⟨hq.1, hqd, fun m _ hm => hq.2 m hm⟩
  apply five_dvd_of_isLog _ hloge
  rcases hq2 with rfl | rfl
  · exact Or.inl (by decide)
  · exact Or.inr (by decide)

/-! ### Clause (iv): the two realised factor logs, 70 and 115. -/

theorem factorLog70 : FactorLog151 1321 70 :=
  ⟨2, prime_2, ⟨184, rfl⟩, by show (6 ^ 70) % 151 = 2 % 151; decide⟩

theorem factorLog115 : FactorLog151 1321 115 :=
  ⟨23, prime_23, ⟨16, rfl⟩, by show (6 ^ 115) % 151 = 23 % 151; decide⟩

theorem gcd5_1321 : GcdLogsIs5 1321 := by
  refine ⟨?_, ?_⟩
  · intro e he
    rcases he with ⟨q, hq, hqd, hloge⟩
    exact clause_iii q hq hqd e hloge
  · intro d hd _
    have h70 : d ∣ 70 := hd 70 factorLog70
    have h115 : d ∣ 115 := hd 115 factorLog115
    have h := Nat.dvd_gcd h70 h115
    have hg : Nat.gcd 70 115 = 5 := rfl
    rwa [hg] at h

/-! ### The instance at n = 1321, and the witnessed statement. -/

theorem instance_1321 : SieveBetaInstance151_5 1321 :=
  ⟨prime_1321, by decide, nr_1321, clause_iii, gcd5_1321, ⟨184, rfl⟩⟩

/-- **O12 discharged:** `SieveBeta151_5` (SIEVE-β(151, 5), the
    formalised statement of `SieveBeta.lean`) is witnessed by
    the prime n = 1321. -/
theorem sieveBeta151_5_witness : SieveBeta151_5 :=
  ⟨1321, instance_1321⟩

#print axioms sieveBeta151_5_witness
