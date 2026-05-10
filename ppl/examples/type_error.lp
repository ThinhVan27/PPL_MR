% =============================================================================
% Example 3: Intentional Type Errors
% =============================================================================
% These programs contain type errors that the type checker should detect.
% =============================================================================

% --- Error 1: 3 + true ---
% Cannot add int and bool
expr(err1_3, lit).      lit_val(err1_3, int, 3).
expr(err1_true, lit).   lit_val(err1_true, bool, true).
expr(err1_add, arith).  arith_expr(err1_add, add, err1_3, err1_true).
root_expr(err1_add).

% --- Error 2: if 42 then 1 else 2 ---
% Condition must be bool, not int
expr(err2_42, lit).     lit_val(err2_42, int, 42).
expr(err2_1, lit).      lit_val(err2_1, int, 1).
expr(err2_2, lit).      lit_val(err2_2, int, 2).
expr(err2_ite, ite).    ite_expr(err2_ite, err2_42, err2_1, err2_2).
root_expr(err2_ite).

% --- Error 3: if true then 1 else false ---
% Branch types mismatch: int vs bool
expr(err3_true, lit).   lit_val(err3_true, bool, true).
expr(err3_1, lit).      lit_val(err3_1, int, 1).
expr(err3_false, lit).  lit_val(err3_false, bool, false).
expr(err3_ite, ite).    ite_expr(err3_ite, err3_true, err3_1, err3_false).
root_expr(err3_ite).

% --- Error 4: 5 applied to 3 (applying non-function) ---
% 5 is int, not a function
expr(err4_5, lit).      lit_val(err4_5, int, 5).
expr(err4_3, lit).      lit_val(err4_3, int, 3).
expr(err4_app, app).    app_expr(err4_app, err4_5, err4_3).
root_expr(err4_app).

% --- Error 5: Unbound variable ---
% Variable z is never defined
expr(err5_z, var).      var_expr(err5_z, z).
root_expr(err5_z).

% --- Error 6: true and 3 ---
% Cannot use 'and' with int operand
expr(err6_true, lit).   lit_val(err6_true, bool, true).
expr(err6_3, lit).      lit_val(err6_3, int, 3).
expr(err6_and, bool_op). bool_expr(err6_and, and, err6_true, err6_3).
root_expr(err6_and).
