"""
Discrete Mathematics Application Runner: Graph Problems using ASP
=================================================================
Runs graph coloring and Hamiltonian path on all example graphs.
"""

import clingo
import os
import sys

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
COLORING_LP = os.path.join(SCRIPT_DIR, "graph_coloring.lp")
HAMILTON_LP = os.path.join(SCRIPT_DIR, "hamiltonian.lp")
EXAMPLES_DIR = os.path.join(SCRIPT_DIR, "examples")

COLOR_NAMES = {1: "Red", 2: "Blue", 3: "Green", 4: "Yellow", 5: "Purple", 6: "Orange"}


def run_coloring(example_file):
    """Run graph coloring on an example."""
    print(f"\n  -- Graph Coloring --")

    ctl = clingo.Control(["1"], logger=lambda code, msg: None)
    ctl.load(COLORING_LP)
    ctl.load(example_file)
    ctl.ground([("base", [])])

    models = []

    def on_model(model):
        atoms = model.symbols(shown=True)
        models.append(list(atoms))

    result = ctl.solve(on_model=on_model)

    if result.satisfiable:
        atoms = models[0]
        assignments = {}
        colors_used = 0

        for atom in atoms:
            if atom.name == "assign":
                v = atom.arguments[0].number
                c = atom.arguments[1].number
                assignments[v] = c
            elif atom.name == "colors_used":
                colors_used = atom.arguments[0].number

        print(f"  [OK] Valid {colors_used}-coloring found:")
        for v in sorted(assignments):
            c = assignments[v]
            cname = COLOR_NAMES.get(c, f"Color{c}")
            print(f"    Vertex {v} -> {cname} ({c})")
        print(f"  Total colors used: {colors_used}")
    else:
        print(f"  [FAIL] No valid coloring found with the given number of colors")
        print(f"  Searching for chromatic number...")
        for k in range(1, 20):
            ctl2 = clingo.Control(["1"], logger=lambda code, msg: None)
            ctl2.load(COLORING_LP)
            ctl2.load(example_file)
            ctl2.add("base", [], f"num_colors({k}).")
            ctl2.ground([("base", [])])

            found = [False]

            def on_model2(model):
                found[0] = True

            ctl2.solve(on_model=on_model2)
            if found[0]:
                print(f"  Chromatic number: {k}")
                break


def run_hamiltonian(example_file):
    """Run Hamiltonian path on an example."""
    print(f"\n  -- Hamiltonian Path --")

    # Check if the example has arc facts
    has_arcs = False
    with open(example_file, 'r', encoding='utf-8') as f:
        content = f.read()
        if 'arc(' in content:
            has_arcs = True

    if not has_arcs:
        print("  (Skipped -- no directed arcs defined for this graph)")
        return

    ctl = clingo.Control(["1"], logger=lambda code, msg: None)
    ctl.load(HAMILTON_LP)
    ctl.load(example_file)
    ctl.ground([("base", [])])

    models = []

    def on_model(model):
        atoms = model.symbols(shown=True)
        models.append(list(atoms))

    result = ctl.solve(on_model=on_model)

    if result.satisfiable:
        atoms = models[0]
        positions = {}
        start_v = None

        for atom in atoms:
            if atom.name == "position":
                v = atom.arguments[0].number
                p = atom.arguments[1].number
                positions[p] = v
            elif atom.name == "start":
                start_v = atom.arguments[0].number

        path = [positions[p] for p in sorted(positions)]
        path_str = " -> ".join(str(v) for v in path)

        print(f"  [OK] Hamiltonian path found!")
        print(f"    Start: vertex {start_v}")
        print(f"    Path:  {path_str}")
        print(f"    Length: {len(path)} vertices")
    else:
        print(f"  [FAIL] No Hamiltonian path exists for this graph")


def run_example(example_file):
    """Run all graph analyses on an example."""
    basename = os.path.basename(example_file)
    print(f"\n{'='*70}")
    print(f"  Example: {basename}")
    print(f"{'='*70}")

    # Read and display graph comments
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

    run_coloring(example_file)
    run_hamiltonian(example_file)


def main():
    print("\n" + "="*70)
    print("  Discrete Math Application: Graph Problems using ASP")
    print("  (Graph Coloring & Hamiltonian Paths)")
    print("="*70)

    examples = sorted([
        os.path.join(EXAMPLES_DIR, f)
        for f in os.listdir(EXAMPLES_DIR)
        if f.endswith(".lp")
    ])

    for example in examples:
        run_example(example)

    print("\n" + "="*70)
    print("  Discrete Math Application Complete")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
