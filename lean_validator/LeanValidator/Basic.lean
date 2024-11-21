import Mathlib

theorem example_add_positive (a b : ℕ) (ha : 0 < a) (hb : 0 < b) : 0 < a + b := by
  have : 0 + 0 < a + b := add_lt_add ha hb
  exact this