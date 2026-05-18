% =============================================================================
% Example: Four Overlapping Deadlock Cycles
% =============================================================================

% Five process & five resource
% Wait-for structure:
%
%        p1 <--------------- p4
%        ^  \             /   ^
%        |     \        /     |
%        |        v   v       |
%        |         p5         |
%        |        /   \       |
%        |      /       \     |
%        |   v             v  |
%        p2 ---------------> p3
%
% Equivalent edge list:
%   p2 -> p1
%   p2 -> p3
%   p3 -> p4
%   p4 -> p1
%   p4 -> p5
%   p5 -> p2
%   p1 -> p5
%   p5 -> p3
%
% There are multiple overlapping deadlock cycles:
%   Cycle 1: p2 -> p1 -> p5 -> p2
%   Cycle 2: p2 -> p3 -> p4 -> p5 -> p2
%   Cycle 3: p3 -> p4 -> p5 -> p3
%   Cycle 4: p1 -> p5 -> p3 -> p4 -> p1
%
% All cycles pass through p5.
% Minimum recovery size: 1 process.
% Terminating p5 can break all cycles.

% Processes
process(p1).
process(p2).
process(p3).
process(p4).
process(p5).

resource(r1).
resource(r2).
resource(r3).
resource(r4).
resource(r5).

allocated(p1, r1).
allocated(p2, r2).
allocated(p3, r3).
allocated(p4, r4).
allocated(p5, r5).


% p2 -> p1 and p2 -> p3 -> p4 -> p1
requesting(p2, r1).  % p2 waits for p1
requesting(p2, r3).  % p2 waits for p3
requesting(p3, r4).  % p3 waits for p4
requesting(p4, r1).  % p4 waits for p1

% p4 -> p5 -> p2
requesting(p4, r5).  % p4 waits for p5
requesting(p5, r2).  % p5 waits for p2

% Additional edge creating Cycle 1: p2 -> p1 -> p5 -> p2
requesting(p1, r5).  % p1 waits for p5

% Additional edge creating shorter cycles through p5 and p3
requesting(p5, r3).  % p5 waits for p3
