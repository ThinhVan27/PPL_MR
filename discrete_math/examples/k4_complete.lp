% =============================================================================
% Example: Complete Graph K4
% =============================================================================
% K4 is the complete graph on 4 vertices (every pair connected).
% Chromatic number: 4 (need as many colors as vertices)
% Hamiltonian: Yes (e.g., 1 -> 2 -> 3 -> 4)
% =============================================================================

vertex(1..4).

% All edges (complete graph)
edge(1, 2). edge(1, 3). edge(1, 4).
edge(2, 3). edge(2, 4).
edge(3, 4).

% For coloring: need 4 colors
num_colors(4).

% For Hamiltonian: directed arcs (both directions for undirected graph)
arc(U, V) :- edge(U, V).
arc(V, U) :- edge(U, V).

% Start from vertex 1
start(1).
total_v(4).
