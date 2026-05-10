% =============================================================================
% Example 1: Simple Arithmetic and Basic Expressions
% =============================================================================
% This file demonstrates type checking for basic expression types.
% Each expression node has a unique ID for the flat AST representation.
% =============================================================================

% --- Expression 1: (3 + 5) * 2 ---
% Expected type: int
%
% AST:
%   e1_mul
%   ├── e1_add
%   │   ├── e1_3 (lit int 3)
%   │   └── e1_5 (lit int 5)
%   └── e1_2 (lit int 2)

expr(e1_3, lit).   lit_val(e1_3, int, 3).
expr(e1_5, lit).   lit_val(e1_5, int, 5).
expr(e1_2, lit).   lit_val(e1_2, int, 2).
expr(e1_add, arith).  arith_expr(e1_add, add, e1_3, e1_5).
expr(e1_mul, arith).  arith_expr(e1_mul, mul, e1_add, e1_2).
root_expr(e1_mul).

% --- Expression 2: (3 + 5) < 10 ---
% Expected type: bool

expr(e2_10, lit).  lit_val(e2_10, int, 10).
expr(e2_cmp, cmp).  cmp_expr(e2_cmp, lt, e1_add, e2_10).
root_expr(e2_cmp).

% --- Expression 3: (3 < 5) and (2 == 2) ---
% Expected type: bool

expr(e3_cmp1, cmp).  cmp_expr(e3_cmp1, lt, e1_3, e1_5).
expr(e3_2a, lit).    lit_val(e3_2a, int, 2).
expr(e3_2b, lit).    lit_val(e3_2b, int, 2).
expr(e3_cmp2, cmp).  cmp_expr(e3_cmp2, eq, e3_2a, e3_2b).
expr(e3_and, bool_op).  bool_expr(e3_and, and, e3_cmp1, e3_cmp2).
root_expr(e3_and).

% --- Expression 4: if (3 < 5) then 10 else 20 ---
% Expected type: int

expr(e4_20, lit).  lit_val(e4_20, int, 20).
expr(e4_ite, ite).  ite_expr(e4_ite, e3_cmp1, e2_10, e4_20).
root_expr(e4_ite).

% --- Expression 5: not (3 < 5) ---
% Expected type: bool

expr(e5_neg, neg).  neg_expr(e5_neg, e3_cmp1).
root_expr(e5_neg).

% --- Expression 6: (10 - 3) / 2 ---
% Expected type: int

expr(e6_sub, arith).  arith_expr(e6_sub, sub, e2_10, e1_3).
expr(e6_div, arith).  arith_expr(e6_div, div, e6_sub, e1_2).
root_expr(e6_div).
