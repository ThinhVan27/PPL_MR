"""
PPL Application Runner: Type Checking and Inference using ASP
=============================================================
Runs the type checker on all example programs and displays results.
"""

import clingo
import os
import sys

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TYPE_CHECKER = os.path.join(SCRIPT_DIR, "type_checker.lp")
EXAMPLES_DIR = os.path.join(SCRIPT_DIR, "examples")


def format_type(t):
    """Pretty-print a type symbol."""
    if t.type == clingo.SymbolType.Function:
        if t.name == "arrow":
            return "(... -> ...)"
        elif t.name in ("int", "bool"):
            return t.name
    return str(t)


def run_example(example_file):
    """Run the type checker on a single example file."""
    print(f"\n{'='*70}")
    print(f"  Example: {os.path.basename(example_file)}")
    print(f"{'='*70}")

    # Read comments from the file for context
    with open(example_file, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line.startswith('% ==='):
                continue
            if line.startswith('%'):
                print(f"  {line}")
            elif line == '':
                continue
            else:
                break
    print()

    ctl = clingo.Control(["0"])  # Find all stable models
    
    # Use logger to suppress info messages
    ctl = clingo.Control(["0"], logger=lambda code, msg: None)
    ctl.load(TYPE_CHECKER)
    ctl.load(example_file)
    ctl.ground([("base", [])])

    models = []

    def on_model(model):
        atoms = model.symbols(shown=True)
        models.append(list(atoms))

    result = ctl.solve(on_model=on_model)

    if result.satisfiable:
        print(f"  [OK] SATISFIABLE -- {len(models)} stable model(s) found\n")

        for i, atoms in enumerate(models):
            if len(models) > 1:
                print(f"  --- Model {i+1} ---")

            # Categorize atoms
            type_assignments = []
            well_typed = []
            type_errors = []
            type_mismatches = []
            unbound_vars = []
            arrow_params = {}
            arrow_returns = {}

            for atom in atoms:
                if atom.name == "has_type":
                    type_assignments.append((str(atom.arguments[0]), atom.arguments[1]))
                elif atom.name == "well_typed":
                    well_typed.append(str(atom.arguments[0]))
                elif atom.name == "type_error":
                    type_errors.append(str(atom.arguments[0]))
                elif atom.name == "type_mismatch":
                    type_mismatches.append(atom)
                elif atom.name == "unbound_var":
                    unbound_vars.append((str(atom.arguments[0]), str(atom.arguments[1])))
                elif atom.name == "arrow_param_type":
                    arrow_params[str(atom.arguments[0])] = format_type(atom.arguments[1])
                elif atom.name == "arrow_return_type":
                    arrow_returns[str(atom.arguments[0])] = format_type(atom.arguments[1])

            # Build arrow type display
            def display_type(t):
                if t.type == clingo.SymbolType.Function and t.name == "arrow":
                    lam_id = str(t.arguments[0])
                    pt = arrow_params.get(lam_id, "?")
                    rt = arrow_returns.get(lam_id, "?")
                    return f"({pt} -> {rt})"
                return format_type(t)

            # Display type assignments
            if type_assignments:
                print("  Type Assignments:")
                for (eid, t) in sorted(type_assignments, key=lambda x: x[0]):
                    marker = ""
                    if eid in well_typed:
                        marker = " << ROOT (well-typed)"
                    elif eid in type_errors:
                        marker = " << ROOT (TYPE ERROR)"
                    print(f"    {eid:25s} : {display_type(t)}{marker}")

            # Display well-typed
            if well_typed:
                print(f"\n  [OK] Well-Typed Root Expressions: {', '.join(sorted(well_typed))}")

            # Display type errors
            if type_errors:
                print(f"\n  [ERROR] Type Errors Detected:")
                for eid in sorted(type_errors):
                    print(f"    {eid} -- cannot be assigned a valid type")

            # Display mismatch details
            if type_mismatches:
                print(f"\n  [WARN] Type Mismatch Details:")
                for atom in type_mismatches:
                    eid = str(atom.arguments[0])
                    kind = str(atom.arguments[1])
                    op = str(atom.arguments[2])
                    if kind == "arith_operand":
                        print(f"    {eid}: arithmetic '{op}' requires int operands")
                    elif kind == "ite_condition":
                        print(f"    {eid}: if-then-else condition must be bool")
                    elif kind == "ite_branches":
                        print(f"    {eid}: if-then-else branches have different types")
                    elif kind == "app_non_function":
                        print(f"    {eid}: applying a non-function value")
                    else:
                        print(f"    {eid}: {kind}")

            # Display unbound variables
            if unbound_vars:
                print(f"\n  [WARN] Unbound Variables:")
                for (eid, name) in sorted(unbound_vars):
                    print(f"    {eid}: variable '{name}' is not bound in any scope")

            print()
    else:
        print("\n  [FAIL] UNSATISFIABLE -- No valid typing found\n")


def main():
    print("\n" + "="*70)
    print("  PPL Application: Type Checking & Inference using ASP")
    print("  (Declarative typing judgments for a simple typed language)")
    print("="*70)

    examples = sorted([
        os.path.join(EXAMPLES_DIR, f)
        for f in os.listdir(EXAMPLES_DIR)
        if f.endswith(".lp")
    ])

    for example in examples:
        run_example(example)

    print("="*70)
    print("  PPL Application Complete")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
