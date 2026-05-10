% =============================================================================
% PPL Application: Type Checking and Inference for a Simple Typed Language
% =============================================================================
% This ASP program encodes typing rules for a simple expression language with:
%   - Integer and Boolean base types
%   - Arithmetic operations (+, -, *, /)
%   - Comparison operations (<, <=, ==, !=)
%   - Boolean operations (and, or, not)
%   - If-then-else expressions
%   - Let bindings (with type inference)
%   - Lambda abstractions and function application
%   - Variables with environment-based lookup
%
% Expressions are identified by unique IDs (atoms). The AST structure is
% encoded via facts rather than nested terms to avoid grounding issues.
%
% Input predicates:
%   - expr(ID, Kind): expression ID has kind Kind
%   - lit_val(ID, Type, Val): literal ID has type Type and value Val
%   - arith_expr(ID, Op, Left, Right): arithmetic expression
%   - cmp_expr(ID, Op, Left, Right): comparison expression
%   - bool_expr(ID, Op, Left, Right): boolean binary expression
%   - neg_expr(ID, Inner): boolean negation
%   - ite_expr(ID, Cond, Then, Else): if-then-else
%   - var_expr(ID, Name): variable reference
%   - let_expr(ID, VarName, BindExpr, BodyExpr): let binding
%   - lam_expr(ID, Param, ParamType, Body): lambda abstraction
%   - app_expr(ID, Func, Arg): function application
%   - root_expr(ID): marks a root expression to type-check
% =============================================================================

% --- Typing rules for literals ---
has_type(ID, int) :- expr(ID, lit), lit_val(ID, int, _).
has_type(ID, bool) :- expr(ID, lit), lit_val(ID, bool, _).

% --- Typing rules for arithmetic operations ---
arith_op(add). arith_op(sub). arith_op(mul). arith_op(div).

has_type(ID, int) :-
    expr(ID, arith),
    arith_expr(ID, Op, E1, E2),
    arith_op(Op),
    has_type(E1, int),
    has_type(E2, int).

% --- Typing rules for comparison operations ---
cmp_op(lt). cmp_op(leq). cmp_op(eq). cmp_op(neq).

has_type(ID, bool) :-
    expr(ID, cmp),
    cmp_expr(ID, Op, E1, E2),
    cmp_op(Op),
    has_type(E1, int),
    has_type(E2, int).

% --- Typing rules for boolean operations ---
has_type(ID, bool) :-
    expr(ID, bool_op),
    bool_expr(ID, _, E1, E2),
    has_type(E1, bool),
    has_type(E2, bool).

has_type(ID, bool) :-
    expr(ID, neg),
    neg_expr(ID, E),
    has_type(E, bool).

% --- Typing rule for if-then-else ---
% if e1 then e2 else e3 : T  when  e1 : bool, e2 : T, e3 : T
has_type(ID, T) :-
    expr(ID, ite),
    ite_expr(ID, Cond, Then, Else),
    has_type(Cond, bool),
    has_type(Then, T),
    has_type(Else, T).

% --- Typing rule for variables ---
has_type(ID, T) :-
    expr(ID, var),
    var_expr(ID, X),
    env(X, T).

% --- Typing rule for let bindings ---
% let x = e1 in e2 : T2  when  e1 : T1, x:T1 |- e2 : T2
has_type(ID, T2) :-
    expr(ID, let),
    let_expr(ID, _, E1, E2),
    has_type(E1, _),
    has_type(E2, T2).

env(X, T) :- let_expr(_, X, E1, _), has_type(E1, T).

% --- Typing rules for lambda and application ---
% λx:T1. body : arrow(ID)  — we track function types by the lambda's own ID
has_type(ID, arrow(ID)) :-
    expr(ID, lam),
    lam_expr(ID, _, _, Body),
    has_type(Body, _).

% Lambda parameter adds to environment
env(X, T1) :- lam_expr(_, X, T1, _).

% Arrow type metadata
arrow_param_type(ID, T1) :- lam_expr(ID, _, T1, _).
arrow_return_type(ID, T2) :- lam_expr(ID, _, _, Body), has_type(Body, T2).

% Application: e1 e2 : T2  when  e1 : arrow(LamID), param(LamID)=T1, e2 : T1
has_type(ID, T2) :-
    expr(ID, app),
    app_expr(ID, E1, E2),
    has_type(E1, arrow(LamID)),
    arrow_param_type(LamID, T1),
    arrow_return_type(LamID, T2),
    has_type(E2, T1).

% --- Type error detection ---
well_typed(ID) :- root_expr(ID), has_type(ID, _).
type_error(ID) :- root_expr(ID), not well_typed(ID).

% --- Mismatch diagnostics ---
type_mismatch(ID, arith_operand, Op) :-
    expr(ID, arith), arith_expr(ID, Op, E1, E2),
    has_type(E1, T1), T1 != int.

type_mismatch(ID, arith_operand, Op) :-
    expr(ID, arith), arith_expr(ID, Op, E1, E2),
    has_type(E2, T2), T2 != int.

type_mismatch(ID, ite_condition, if) :-
    expr(ID, ite), ite_expr(ID, Cond, _, _),
    has_type(Cond, T), T != bool.

type_mismatch(ID, ite_branches, if) :-
    expr(ID, ite), ite_expr(ID, _, Then, Else),
    has_type(Then, T1), has_type(Else, T2), T1 != T2.

type_mismatch(ID, app_non_function, app) :-
    expr(ID, app), app_expr(ID, E1, _),
    has_type(E1, int).

type_mismatch(ID, app_non_function, app) :-
    expr(ID, app), app_expr(ID, E1, _),
    has_type(E1, bool).

% Detect when nothing can be typed (unbound variable)
unbound_var(ID, X) :-
    expr(ID, var), var_expr(ID, X), not env(X, _).

% --- Show directives ---
#show has_type/2.
#show type_error/1.
#show well_typed/1.
#show type_mismatch/3.
#show unbound_var/2.
#show arrow_param_type/2.
#show arrow_return_type/2.
