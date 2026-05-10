"""
Database Application Runner: Functional Dependency Analysis using ASP
=====================================================================
Runs the FD analyzer on all example schemas and displays results.
"""

import clingo
import os
import sys

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
FD_ANALYSIS = os.path.join(SCRIPT_DIR, "fd_analysis.lp")
EXAMPLES_DIR = os.path.join(SCRIPT_DIR, "examples")


def run_example(example_file):
    """Run the FD analyzer on a single example file."""
    print(f"\n{'='*70}")
    print(f"  Example: {os.path.basename(example_file)}")
    print(f"{'='*70}")

    ctl = clingo.Control(["0"], logger=lambda code, msg: None)
    ctl.load(FD_ANALYSIS)
    ctl.load(example_file)
    ctl.ground([("base", [])])

    models = []

    def on_model(model):
        atoms = model.symbols(shown=True)
        models.append(list(atoms))

    result = ctl.solve(on_model=on_model)

    if result.satisfiable:
        print(f"\n  [OK] SATISFIABLE -- {len(models)} stable model(s) found\n")

        for i, atoms in enumerate(models):
            if len(models) > 1:
                print(f"  --- Model {i+1} ---")

            # Categorize atoms by relation
            relations = set()
            closures = {}
            superkeys = {}
            fd_superkeys = {}
            bcnf_violations = {}
            bcnf_ok = set()
            tnf_violations = {}
            tnf_ok = set()
            closure_members = {}
            trivial = {}
            prime_attrs = {}

            for atom in atoms:
                if atom.name == "in_closure":
                    r = str(atom.arguments[0])
                    fd = str(atom.arguments[1])
                    a = str(atom.arguments[2])
                    relations.add(r)
                    key = (r, fd)
                    closures.setdefault(key, set()).add(a)

                elif atom.name == "is_superkey":
                    r = str(atom.arguments[0])
                    sid = str(atom.arguments[1])
                    relations.add(r)
                    superkeys.setdefault(r, []).append(sid)

                elif atom.name == "fd_lhs_is_superkey":
                    r = str(atom.arguments[0])
                    fd = str(atom.arguments[1])
                    relations.add(r)
                    fd_superkeys.setdefault(r, []).append(fd)

                elif atom.name == "bcnf_violation":
                    r = str(atom.arguments[0])
                    fd = str(atom.arguments[1])
                    relations.add(r)
                    bcnf_violations.setdefault(r, []).append(fd)

                elif atom.name == "in_bcnf":
                    r = str(atom.arguments[0])
                    relations.add(r)
                    bcnf_ok.add(r)

                elif atom.name == "threenfv":
                    r = str(atom.arguments[0])
                    fd = str(atom.arguments[1])
                    relations.add(r)
                    tnf_violations.setdefault(r, []).append(fd)

                elif atom.name == "in_3nf":
                    r = str(atom.arguments[0])
                    relations.add(r)
                    tnf_ok.add(r)

                elif atom.name == "closure_member":
                    r = str(atom.arguments[0])
                    sid = str(atom.arguments[1])
                    a = str(atom.arguments[2])
                    relations.add(r)
                    closure_members.setdefault((r, sid), set()).add(a)

                elif atom.name == "trivial_fd":
                    r = str(atom.arguments[0])
                    fd = str(atom.arguments[1])
                    relations.add(r)
                    trivial.setdefault(r, []).append(fd)

                elif atom.name == "prime_attribute":
                    r = str(atom.arguments[0])
                    a = str(atom.arguments[1])
                    relations.add(r)
                    prime_attrs.setdefault(r, set()).add(a)

            # Display per-relation results
            for r in sorted(relations):
                print(f"  +-- Relation: {r}")
                print(f"  |")

                # FD closures
                fd_keys = sorted([k for k in closures if k[0] == r], key=lambda x: x[1])
                if fd_keys:
                    print(f"  |  Attribute Closures (per FD LHS):")
                    for (_, fd) in fd_keys:
                        attrs = sorted(closures[(r, fd)])
                        print(f"  |    {fd}+ = {{{', '.join(attrs)}}}")

                # Attribute set closures
                set_keys = sorted([k for k in closure_members if k[0] == r], key=lambda x: x[1])
                if set_keys:
                    print(f"  |  Attribute Set Closures:")
                    for (_, sid) in set_keys:
                        attrs = sorted(closure_members[(r, sid)])
                        print(f"  |    {sid}+ = {{{', '.join(attrs)}}}")

                # Superkeys
                if r in superkeys:
                    print(f"  |  Superkeys: {', '.join(sorted(superkeys[r]))}")

                # Prime attributes
                if r in prime_attrs:
                    print(f"  |  Prime Attributes: {{{', '.join(sorted(prime_attrs[r]))}}}")

                # FDs with superkey LHS
                if r in fd_superkeys:
                    print(f"  |  FDs with Superkey LHS: {', '.join(sorted(fd_superkeys[r]))}")

                # Trivial FDs
                if r in trivial:
                    print(f"  |  Trivial FDs: {', '.join(sorted(trivial[r]))}")

                # BCNF status
                if r in bcnf_ok:
                    print(f"  |  BCNF: [OK] In BCNF")
                elif r in bcnf_violations:
                    print(f"  |  BCNF: [FAIL] Violations at FDs: {', '.join(sorted(bcnf_violations[r]))}")

                # 3NF status
                if r in tnf_ok:
                    print(f"  |  3NF:  [OK] In 3NF")
                elif r in tnf_violations:
                    print(f"  |  3NF:  [FAIL] Violations at FDs: {', '.join(sorted(tnf_violations[r]))}")

                print(f"  +{'='*50}")
                print()

    else:
        print("\n  [FAIL] UNSATISFIABLE\n")


def main():
    print("\n" + "="*70)
    print("  Database Application: Functional Dependency Analysis using ASP")
    print("  (Attribute closure, superkeys, BCNF/3NF verification)")
    print("="*70)

    examples = sorted([
        os.path.join(EXAMPLES_DIR, f)
        for f in os.listdir(EXAMPLES_DIR)
        if f.endswith(".lp")
    ])

    for example in examples:
        run_example(example)

    print("="*70)
    print("  Database Application Complete")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
