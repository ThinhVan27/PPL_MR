# Applications of Answer Set Programming to Education

## Mini-Project — PPL (Honors Module), Semester 2 (2025–2026)

### Overview

This project demonstrates three educational applications of Answer Set Programming (ASP) 
across three Computer Science subjects:

1. **Principles of Programming Languages (PPL)** — Type Checking and Inference  
2. **Database Systems** — Functional Dependency Analysis and Normalization Verification  
3. **Discrete Mathematics** — Graph Coloring and Hamiltonian Path Problems  

Each application includes ASP encodings, example instances, a Python runner script, and 
detailed explanations of the stable models produced.

---

### Prerequisites

- **Python 3.10+**
- **clingo** (Potassco ASP solver)

Install dependencies:

```bash
pip install -r requirements.txt
```

---

### Project Structure

```
.
├── README.md
├── ppl/                        # Application 1: PPL — Type Checking & Inference
│   ├── type_checker.lp         # ASP encoding for type rules
│   ├── examples/               # Example programs to type-check
│   │   ├── simple_arith.lp     # Simple arithmetic expressions
│   │   ├── lambda_app.lp       # Lambda application with type inference
│   │   └── type_error.lp       # Program with intentional type error
│   └── run.py                  # Python runner & output analyzer
│
├── database/                   # Application 2: Database — FD Analysis & Normalization
│   ├── fd_analysis.lp          # ASP encoding for functional dependency analysis
│   ├── examples/               # Example schemas
│   │   ├── student_db.lp       # Student database schema
│   │   ├── bcnf_violation.lp   # Schema with BCNF violation
│   │   └── normalized_db.lp    # Already normalized schema
│   └── run.py                  # Python runner & output analyzer
│
├── discrete_math/              # Application 3: Discrete Math — Graph Problems
│   ├── graph_coloring.lp       # ASP encoding for graph coloring
│   ├── hamiltonian.lp          # ASP encoding for Hamiltonian path
│   ├── examples/               # Example graphs
│   │   ├── petersen.lp         # Petersen graph
│   │   ├── k4_complete.lp      # Complete graph K4
│   │   └── bipartite.lp        # Bipartite graph
│   └── run.py                  # Python runner & output analyzer
│
├── run_all.py                  # Run all three applications
└── specs.pdf                   # Assignment specification
```

---

### How to Run

#### Run all applications at once:

```bash
python run_all.py
```

#### Run individual applications:

```bash
# PPL — Type Checking & Inference
python ppl/run.py

# Database — Functional Dependency Analysis
python database/run.py

# Discrete Mathematics — Graph Problems
python discrete_math/run.py
```

---

### Application Details

#### 1. PPL: Type Checking and Inference

Models a simple typed lambda calculus with integers, booleans, and function types.  
ASP rules encode typing judgments (Γ ⊢ e : τ) declaratively. Given an expression AST 
and partial type annotations, the solver infers types or detects type errors.

**Key concepts demonstrated:** Type rules, type environments, Hindley-Milner style inference, 
type error detection.

#### 2. Database: Functional Dependency Analysis

Encodes functional dependencies (FDs) and relation schemas as ASP facts. The solver 
computes attribute closures, candidate keys, checks for BCNF/3NF violations, and 
suggests decompositions.

**Key concepts demonstrated:** Armstrong's axioms, attribute closure, candidate keys, 
normal form verification.

#### 3. Discrete Mathematics: Graph Coloring and Hamiltonian Paths

Solves classic graph theory problems: k-coloring and Hamiltonian path finding.  
Demonstrates ASP's natural ability to encode NP-complete problems declaratively.

**Key concepts demonstrated:** Graph coloring, chromatic number, Hamiltonian paths, 
constraint satisfaction.

---

### Cross-Domain Analysis

See the report for a detailed cross-domain comparison of how ASP modeling patterns 
differ across the three subjects, including:
- Constraint types (type compatibility vs. functional dependencies vs. graph adjacency)
- Search space structure (type assignments vs. decompositions vs. color/path assignments)
- Use of integrity constraints, choice rules, and optimization statements

---

### License

This project is for academic use at HCMUT — VNU-HCM.
