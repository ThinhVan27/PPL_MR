"""
Operating Systems Application Runner: Deadlock Detection using ASP
==================================================================
Runs deadlock detection and minimum recovery-set optimization on all examples.
"""

import clingo
import os
import sys

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEADLOCK_LP = os.path.join(SCRIPT_DIR, "deadlock_detection.lp")
EXAMPLES_DIR = os.path.join(SCRIPT_DIR, "examples")


def symbol_name(symbol):
    """Return a readable name for a clingo constant symbol."""
    return symbol.name if symbol.type == clingo.SymbolType.Function else str(symbol)


def read_header_comments(example_file):
    """Print leading comments from an example file for context."""
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


def run_example(example_file):
    """Run deadlock detection on a single example file."""
    print(f"\n{'='*70}")
    print(f"  Example: {os.path.basename(example_file)}")
    print(f"{'='*70}")

    read_header_comments(example_file)
    print()

    ctl = clingo.Control(["0"], logger=lambda code, msg: None)
    ctl.load(DEADLOCK_LP)
    ctl.load(example_file)
    ctl.ground([("base", [])])

    shown_models = []
    model_optimizations = []

    def on_model(model):
        shown_models.append(list(model.symbols(shown=True)))
        model_optimizations.append(list(model.cost))

    result = ctl.solve(on_model=on_model)

    if not result.satisfiable:
        print("  [FAIL] UNSATISFIABLE -- invalid system snapshot")
        return

    # With optimization, the final reported model is the best model found.
    shown_atoms = shown_models[-1]
    model_optimization = model_optimizations[-1] if model_optimizations else []

    available = []
    blocked = []
    waits_for = []
    deadlocked = []
    terminate = []

    for atom in shown_atoms:
        if atom.name == "available":
            available.append(symbol_name(atom.arguments[0]))
        elif atom.name == "blocked":
            p = symbol_name(atom.arguments[0])
            r = symbol_name(atom.arguments[1])
            blocked.append((p, r))
        elif atom.name == "waits_for":
            p1 = symbol_name(atom.arguments[0])
            p2 = symbol_name(atom.arguments[1])
            r = symbol_name(atom.arguments[2])
            waits_for.append((p1, p2, r))
        elif atom.name == "deadlocked":
            deadlocked.append(symbol_name(atom.arguments[0]))
        elif atom.name == "terminate":
            terminate.append(symbol_name(atom.arguments[0]))

    if available:
        print("  Available Resources:")
        for r in sorted(available):
            print(f"    {r}")

    if blocked:
        print("\n  Blocked Processes:")
        for p, r in sorted(blocked):
            print(f"    {p} waiting for {r}")

    if waits_for:
        print("\n  Wait-For Graph:")
        for p1, p2, r in sorted(waits_for):
            print(f"    {p1} -> {p2} via {r}")

    if deadlocked:
        print("\n  [DEADLOCK] Deadlock detected")
        print(f"    Deadlocked processes: {', '.join(sorted(deadlocked))}")

        if terminate:
            print("\n  Recovery Suggestion:")
            for p in sorted(terminate):
                print(f"    terminate {p}")
            print(f"    terminated processes: {len(terminate)}")
            if model_optimization:
                print(f"    minimum cut size: {model_optimization[0]}")
    else:
        print("  [OK] No deadlock detected")


def main():
    print("\n" + "="*70)
    print("  Operating Systems Application: Deadlock Detection using ASP")
    print("  (Wait-for graph cycle detection and minimum recovery set)")
    print("="*70)

    examples = sorted([
        os.path.join(EXAMPLES_DIR, f)
        for f in os.listdir(EXAMPLES_DIR)
        if f.endswith(".lp")
    ])

    for example in examples:
        run_example(example)

    print("\n" + "="*70)
    print("  Operating Systems Application Complete")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
