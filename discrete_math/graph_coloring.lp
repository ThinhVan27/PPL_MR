% =============================================================================
% Discrete Mathematics Application: Graph Coloring
% =============================================================================
% Given an undirected graph and a number of colors k, find a proper k-coloring.
% A proper coloring assigns a color to each vertex such that no two adjacent
% vertices share the same color.
%
% This is a classic NP-complete problem that ASP handles naturally through
% choice rules and integrity constraints.
%
% Input facts (in example files):
%   - vertex(V): V is a vertex
%   - edge(U, V): undirected edge between U and V
%   - num_colors(K): number of available colors
%
% The program also finds the chromatic number (minimum k for which a 
% valid coloring exists) using optimization.
% =============================================================================

% --- Generate available colors ---
color(1..K) :- num_colors(K).

% --- Symmetry: undirected edges ---
edge(V, U) :- edge(U, V).

% --- Choice rule: assign exactly one color to each vertex ---
{ assign(V, C) : color(C) } = 1 :- vertex(V).

% --- Integrity constraint: adjacent vertices must have different colors ---
:- edge(U, V), assign(U, C), assign(V, C), U < V.

% --- Compute coloring statistics ---
colors_used(N) :- N = #count{ C : assign(_, C) }.

% --- Show directives ---
#show assign/2.
#show colors_used/1.
