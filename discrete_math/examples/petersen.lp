% =============================================================================
% Example: Petersen Graph
% =============================================================================
% The Petersen graph is a famous graph in discrete mathematics.
% It has 10 vertices and 15 edges, is 3-regular, and has chromatic number 3.
% It is NOT Hamiltonian (no Hamiltonian cycle exists).
%
% Outer cycle: 1-2-3-4-5-1
% Inner star:  6-8-10-7-9-6
% Spokes: 1-6, 2-7, 3-8, 4-9, 5-10
% =============================================================================

% Vertices
vertex(1..10).

% Outer cycle
edge(1, 2). edge(2, 3). edge(3, 4). edge(4, 5). edge(5, 1).

% Inner star (pentagram)
edge(6, 8). edge(8, 10). edge(10, 7). edge(7, 9). edge(9, 6).

% Spokes
edge(1, 6). edge(2, 7). edge(3, 8). edge(4, 9). edge(5, 10).

% Number of colors to try
num_colors(3).
