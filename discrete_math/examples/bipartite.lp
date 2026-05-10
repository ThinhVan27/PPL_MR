% =============================================================================
% Example: Bipartite Graph K_{3,3}
% =============================================================================
% K_{3,3} is a complete bipartite graph with partitions {1,2,3} and {4,5,6}.
% Chromatic number: 2 (bipartite graphs are always 2-colorable)
% Hamiltonian: Yes (K_{m,n} with m=n >= 2 has a Hamiltonian cycle)
%
% This demonstrates that ASP can efficiently find 2-colorings for bipartite
% graphs, which corresponds to the theoretical minimum.
% =============================================================================

vertex(1..6).

% Partition A = {1, 2, 3}, Partition B = {4, 5, 6}
% All edges between partitions
edge(1, 4). edge(1, 5). edge(1, 6).
edge(2, 4). edge(2, 5). edge(2, 6).
edge(3, 4). edge(3, 5). edge(3, 6).

% Chromatic number is 2
num_colors(2).

% For Hamiltonian path: directed arcs (both directions)
arc(U, V) :- edge(U, V).
arc(V, U) :- edge(U, V).

% Start from vertex 1
start(1).
total_v(6).
