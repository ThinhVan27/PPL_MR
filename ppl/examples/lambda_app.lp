% =============================================================================
% Example 2: Lambda Abstractions, Let Bindings, and Function Application
% =============================================================================
% Demonstrates type inference for higher-order functions.
% =============================================================================

% --- Program 1: let double = λx:int. x + x in double 5 ---
% Expected: double : int → int, result : int
%
% AST:
%   e_let_double (let)
%   ├── bind: e_lam_double (lam x:int)
%   │         └── e_add_xx (add)
%   │             ├── e_var_x1 (var x)
%   │             └── e_var_x2 (var x)
%   └── body: e_app_d5 (app)
%             ├── e_var_double (var double)
%             └── e_lit_5 (lit int 5)

expr(e_var_x1, var).     var_expr(e_var_x1, x).
expr(e_var_x2, var).     var_expr(e_var_x2, x).
expr(e_add_xx, arith).   arith_expr(e_add_xx, add, e_var_x1, e_var_x2).
expr(e_lam_double, lam). lam_expr(e_lam_double, x, int, e_add_xx).

expr(e_lit_5, lit).      lit_val(e_lit_5, int, 5).
expr(e_var_double, var). var_expr(e_var_double, double).
expr(e_app_d5, app).     app_expr(e_app_d5, e_var_double, e_lit_5).

expr(e_let_double, let). let_expr(e_let_double, double, e_lam_double, e_app_d5).
root_expr(e_let_double).

% --- Program 2: λy:int. y + 1 ---
% A standalone lambda: should be typed as a function int → int

expr(e_var_y, var).      var_expr(e_var_y, y).
expr(e_lit_1, lit).      lit_val(e_lit_1, int, 1).
expr(e_add_y1, arith).   arith_expr(e_add_y1, add, e_var_y, e_lit_1).
expr(e_lam_inc, lam).    lam_expr(e_lam_inc, y, int, e_add_y1).
root_expr(e_lam_inc).

% --- Program 3: let negate = λb:bool. not b in negate true ---
% negate : bool → bool, result : bool

expr(e_var_b, var).      var_expr(e_var_b, b).
expr(e_neg_b, neg).      neg_expr(e_neg_b, e_var_b).
expr(e_lam_neg, lam).    lam_expr(e_lam_neg, b, bool, e_neg_b).

expr(e_lit_true, lit).   lit_val(e_lit_true, bool, true).
expr(e_var_neg, var).    var_expr(e_var_neg, negate).
expr(e_app_neg, app).    app_expr(e_app_neg, e_var_neg, e_lit_true).

expr(e_let_neg, let).    let_expr(e_let_neg, negate, e_lam_neg, e_app_neg).
root_expr(e_let_neg).
