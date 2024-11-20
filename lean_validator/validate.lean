/-
Validator for generated Lean proofs
-/
import minif2f_import

open_locale big_operators
open_locale nat
open_locale real
open_locale rat

/- Helper function to extract theorem statement -/
meta def get_theorem_statement (thm_name : string) : option expr :=
do
  env ← tactic.get_env,
  match env.find thm_name with
  | none := pure none
  | some decl := pure (some decl.type)
  end

/- Helper function to check if a proof is valid -/
meta def check_proof (thm_name : string) (proof : string) : bool :=
do
  -- Get the theorem statement
  let thm_stmt ← get_theorem_statement thm_name,
  match thm_stmt with
  | none := pure false  -- Theorem not found
  | some stmt := do
    -- Create a temporary file with the proof
    let temp_file := "temp_proof.lean",
    -- Write the theorem and proof to the file
    io.fs.write_file temp_file (s!"theorem {thm_name} : {stmt} :=\n{proof}"),
    -- Try to compile the proof
    let result ← io.cmd "lean" [temp_file],
    -- Clean up
    io.fs.remove temp_file,
    -- Return true if compilation succeeded
    pure (result = 0)
  end

/- Main validation function -/
def validate_proof (thm_name : string) (proof : string) : bool :=
check_proof thm_name proof

/- Command to validate a proof -/
def main (args : list string) : io unit := do
  match args with
  | [thm_name, proof_file] => do
    proof ← io.fs.read_file proof_file,
    let result := validate_proof thm_name proof,
    io.println (if result then "valid" else "invalid")
  | _ => io.println "Usage: lean validate.lean <theorem_name> <proof_file>"
