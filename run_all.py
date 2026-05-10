"""
Master Runner: Applications of Answer Set Programming to Education
==================================================================
Runs all three ASP applications:
  1. PPL -- Type Checking & Inference
  2. Database -- Functional Dependency Analysis
  3. Discrete Mathematics -- Graph Problems

Usage: python run_all.py
"""

import os
import sys
import importlib.util

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def run_module(module_path, module_name):
    """Dynamically load and run a module's main() function."""
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.main()


def main():
    print("\n" + "#"*70)
    print("#" + " "*68 + "#")
    print("#   Applications of Answer Set Programming to Education" + " "*13 + "#")
    print("#   PPL (Honors Module) -- Mini-Project" + " "*29 + "#")
    print("#" + " "*68 + "#")
    print("#"*70)
    print()
    print("  Three applications across Computer Science subjects:")
    print("    1. Principles of Programming Languages (PPL)")
    print("    2. Database Systems")
    print("    3. Discrete Mathematics")
    print()

    # Application 1: PPL
    print("\n" + "="*70)
    print("  APPLICATION 1: Principles of Programming Languages")
    print("  Topic: Type Checking & Inference")
    print("="*70)
    run_module(os.path.join(SCRIPT_DIR, "ppl", "run.py"), "ppl_run")

    # Application 2: Database
    print("\n" + "="*70)
    print("  APPLICATION 2: Database Systems")
    print("  Topic: Functional Dependency Analysis & Normalization")
    print("="*70)
    run_module(os.path.join(SCRIPT_DIR, "database", "run.py"), "db_run")

    # Application 3: Discrete Mathematics
    print("\n" + "="*70)
    print("  APPLICATION 3: Discrete Mathematics")
    print("  Topic: Graph Coloring & Hamiltonian Paths")
    print("="*70)
    run_module(os.path.join(SCRIPT_DIR, "discrete_math", "run.py"), "dm_run")

    # Summary
    print("\n" + "#"*70)
    print("#" + " "*68 + "#")
    print("#   All applications completed successfully!" + " "*26 + "#")
    print("#" + " "*68 + "#")
    print("#"*70 + "\n")


if __name__ == "__main__":
    main()
