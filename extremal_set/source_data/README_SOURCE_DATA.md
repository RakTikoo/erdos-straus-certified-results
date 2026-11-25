# Source data — provenance

> Disclosure: this work is AI-driven analysis submitted for independent
> checking.

The files in this directory are the computation outputs behind the
entries in ../certificates.json, reproduced verbatim (they are data
outputs; their field names are the producing tools' own). They are
evidence, not prose: the claims of the package are in ../../CLAIM.md,
and ../verify_extremal.py re-derives every value independently of
these files.

Per prime:

- 193, 3361, 4153, 8017 — `control_<n>.json`: extracts of a
  full-range evaluation scan (bound, NR count, minimum budget gap,
  argmin configuration) and of an independent full-range margin-only
  scan of the same primes; the two agree on the NR count and on the
  absence of any positive margin.
- 52081, 137713, 140617, 144817, 391393, 460777 —
  `n4_verify_<n>.json`: a full-range evaluation scan, a second
  full-range scan with a different subset construction (the
  `second_path` counts), and a brute-force sample over the argmin
  and first-25 shifts (`bruteforce_sample`).
- 1793017, 1986097, 2060137, 2074417, 2183833, 2595793, 3380017,
  4269721 — `s2_p1_<n>.json` (Path 1 full-range margin scan),
  `s2_p2_<n>.json` (Path 2 full-range independent recount with the
  gap profile: G, argmin, first 25), `s2_sample_<n>.json`
  (brute-force sample over argmin + first 25 shifts).
- 12331897, 23465017, 39579313 — `kernel_cert_<n>.json` (a
  two-path certification produced by a census kernel; its path1
  and path2 agree), `s2_p2_<n>.json` (an independent home Path 2
  full-range recount agreeing with the kernel certification on
  every compared field), `s2_sample_<n>.json` (brute-force sample).

The range hazard found in an early version of the Path 1/Path 2
tooling — a fixed working bound that could silently truncate the
range for large n — is not present in any result used here: the
deciding harvest for the affected sizes ran under a per-target
range correction applied at driver level, the correction was later
folded into the tooling itself (deriving the bound from the target
and refusing loudly on any shortfall), and two of the affected
certifications (1793017 and 2060137) were re-produced
field-for-field under the corrected tooling as controls, with
2060137's certification standing unchanged. The same corrected
behaviour is implemented in ../verify_extremal.py.
