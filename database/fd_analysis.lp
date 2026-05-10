% =============================================================================
% Database Application: Functional Dependency Analysis & Normalization
% =============================================================================
% This ASP program analyzes a relational schema with functional dependencies.
% It computes:
%   1. Attribute closure under a set of FDs (Armstrong's axioms)
%   2. Candidate keys
%   3. BCNF and 3NF violation detection
%   4. Superkey identification
%
% Input facts (provided in example files):
%   - relation(R): R is a relation name
%   - attribute(R, A): A is an attribute of relation R
%   - fd(R, ID): declares a functional dependency with identifier ID in R
%   - fd_lhs(R, ID, A): A is on the left-hand side of FD ID
%   - fd_rhs(R, ID, A): A is on the right-hand side of FD ID
% =============================================================================

% --- Attribute Closure Computation ---
% Start: LHS attributes of an FD are in their own closure
in_closure(R, ID, A) :- fd_lhs(R, ID, A).

% Armstrong's Transitivity: if all LHS attributes of another FD are in the closure,
% then all RHS attributes of that FD are also in the closure
in_closure(R, ID, A) :-
    fd(R, ID),
    fd_rhs(R, ID2, A),
    fd(R, ID2),
    all_lhs_in_closure(R, ID, ID2).

% Check if all LHS attributes of FD ID2 are in the closure of FD ID
all_lhs_in_closure(R, ID, ID2) :-
    fd(R, ID), fd(R, ID2),
    not missing_lhs(R, ID, ID2).

missing_lhs(R, ID, ID2) :-
    fd(R, ID), fd(R, ID2),
    fd_lhs(R, ID2, A),
    not in_closure(R, ID, A).

% --- Attribute closure for arbitrary attribute sets ---
% We use subset/2 to define attribute sets for closure computation
% closure_member(R, SetID, A): A is in the closure of attribute set SetID
closure_member(R, SetID, A) :- attr_set(R, SetID, A).

closure_member(R, SetID, A) :-
    attr_set(R, SetID, _),
    fd_rhs(R, FDID, A),
    fd(R, FDID),
    all_set_lhs_in_closure(R, SetID, FDID).

all_set_lhs_in_closure(R, SetID, FDID) :-
    attr_set(R, SetID, _),
    fd(R, FDID),
    not missing_set_lhs(R, SetID, FDID).

missing_set_lhs(R, SetID, FDID) :-
    attr_set(R, SetID, _),
    fd(R, FDID),
    fd_lhs(R, FDID, A),
    not closure_member(R, SetID, A).

% --- Superkey Detection ---
% A set of attributes is a superkey if its closure contains all attributes
is_superkey(R, SetID) :-
    attr_set(R, SetID, _),
    not missing_from_superkey(R, SetID).

missing_from_superkey(R, SetID) :-
    attr_set(R, SetID, _),
    attribute(R, A),
    not closure_member(R, SetID, A).

% --- FD determines: check if an FD's LHS is a superkey ---
fd_lhs_is_superkey(R, FDID) :-
    fd(R, FDID),
    not fd_lhs_missing_attr(R, FDID).

fd_lhs_missing_attr(R, FDID) :-
    fd(R, FDID),
    attribute(R, A),
    not in_closure(R, FDID, A).

% --- Trivial FD check ---
% A FD is trivial if all RHS attributes are also on LHS
trivial_fd(R, FDID) :-
    fd(R, FDID),
    not nontrivial_rhs(R, FDID).

nontrivial_rhs(R, FDID) :-
    fd(R, FDID),
    fd_rhs(R, FDID, A),
    not fd_lhs(R, FDID, A).

% --- BCNF Violation Detection ---
% A relation is not in BCNF if there exists a non-trivial FD whose LHS is not a superkey
bcnf_violation(R, FDID) :-
    fd(R, FDID),
    not trivial_fd(R, FDID),
    not fd_lhs_is_superkey(R, FDID).

in_bcnf(R) :- relation(R), not has_bcnf_violation(R).
has_bcnf_violation(R) :- bcnf_violation(R, _).

% --- 3NF Violation Detection ---
% A relation is not in 3NF if there exists a non-trivial FD X→A where:
%   - X is not a superkey, AND
%   - A is not part of any candidate key (not a prime attribute)
% For simplicity, we check: non-trivial FD with non-superkey LHS AND non-prime RHS

% An attribute is prime if it belongs to some candidate key
prime_attribute(R, A) :- candidate_key_member(R, _, A).

threenfv(R, FDID) :-
    fd(R, FDID),
    not trivial_fd(R, FDID),
    not fd_lhs_is_superkey(R, FDID),
    fd_rhs(R, FDID, A),
    not prime_attribute(R, A).

in_3nf(R) :- relation(R), not has_3nf_violation(R).
has_3nf_violation(R) :- threenfv(R, _).

% --- Show directives ---
#show in_closure/3.
#show is_superkey/2.
#show fd_lhs_is_superkey/2.
#show bcnf_violation/2.
#show in_bcnf/1.
#show threenfv/2.
#show in_3nf/1.
#show closure_member/3.
#show trivial_fd/2.
#show prime_attribute/2.
