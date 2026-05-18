% =============================================================================
% Operating Systems Application: Deadlock Detection & Recovery Suggestions
% =============================================================================
% This ASP program analyzes a single-instance resource allocation snapshot.
% It derives the wait-for graph, detects deadlock cycles, and suggests a minimum
% set of deadlocked processes to terminate so all cycles are broken.
%
% Input facts:
%   - process(P): P is a process
%   - resource(R): R is a single-instance resource
%   - allocated(P, R): process P currently holds resource R
%   - requesting(P, R): process P is waiting for resource R
% =============================================================================

% --- Resource availability ---
held(R) :- allocated(_, R).
available(R) :- resource(R), not held(R).

% --- Blocked process detection ---
% A process is blocked if it requests a resource currently held by another
% process. Since resources are single-instance, one holder is enough to block.
blocked(P, R) :-
    requesting(P, R),
    allocated(Q, R),
    P != Q.

% --- Wait-for graph construction ---
% P1 waits for P2 through resource R if P1 requests R and P2 holds R.
waits_for(P1, P2, R) :-
    requesting(P1, R),
    allocated(P2, R),
    P1 != P2.

% --- Deadlock detection via reachability ---
reachable(P1, P2) :- waits_for(P1, P2, _).
reachable(P1, P3) :- reachable(P1, P2), waits_for(P2, P3, _).

deadlocked(P) :- reachable(P, P).
deadlock_exists :- deadlocked(_).

% --- Recovery suggestion ---
% Choose any subset of processes that are part of an original deadlock cycle.
{ terminate(P) } :- deadlocked(P).

% Simulate the wait-for graph after terminating the chosen processes.
alive(P) :- process(P), not terminate(P).

remaining_waits_for(P1, P2, R) :-
    waits_for(P1, P2, R),
    alive(P1),
    alive(P2).

remaining_reachable(P1, P2) :- remaining_waits_for(P1, P2, _).
remaining_reachable(P1, P3) :-
    remaining_reachable(P1, P2),
    remaining_waits_for(P2, P3, _).

remaining_deadlocked(P) :- alive(P), remaining_reachable(P, P).

% A valid recovery plan must break every remaining wait-for cycle.
:- deadlock_exists, remaining_deadlocked(_).

% Find a minimum-size set of vertices whose removal breaks all cycles.
#minimize { 1,P : terminate(P) }.

% --- Show directives ---
#show available/1.
#show blocked/2.
#show waits_for/3.
#show deadlocked/1.
#show deadlock_exists/0.
#show terminate/1.
