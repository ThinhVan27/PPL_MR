% =============================================================================
% Discrete Mathematics Application: Hamiltonian Path
% =============================================================================
% Given a directed graph, find a Hamiltonian path -- a path that visits every
% vertex exactly once.
%
% Input facts:
%   - vertex(V): V is a vertex
%   - arc(U, V): directed edge from U to V
%   - start(V): designated start vertex
%   - total_v(N): total number of vertices
%
% This is another NP-complete problem naturally suited for ASP.
% =============================================================================

% --- Position assignment: each vertex gets a unique position in the path ---
{ position(V, 1..N) } = 1 :- vertex(V), total_v(N).

% --- Each position has exactly one vertex ---
:- position(V1, P), position(V2, P), V1 != V2.

% --- Start vertex must be at position 1 ---
:- start(V), not position(V, 1).

% --- Consecutive vertices in the path must be connected by an arc ---
:- position(U, P), position(V, P+1), not arc(U, V).

% --- Build the path ---
path_edge(U, V, P) :- position(U, P), position(V, P+1), arc(U, V).

% --- Show directives ---
#show position/2.
#show path_edge/3.
#show start/1.
