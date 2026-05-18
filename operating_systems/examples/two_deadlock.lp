% =============================================================================
% Example: Two Deadlock Cycles Sharing One Vertex
% =============================================================================

% Seven process & eight resource
% Wait-for structure:
%
%
%       p1 ----> p2                    
%       ^        |    
%       |        v 
%       p3 <---- p4 ----> p5
%                ^         |
%                |         v
%                p7 <---- p6
%
% The two cycles share exactly one process: p4.
% Expected result: deadlock among p1, p2, p3, p4, p5, p6, and p7.
% Minimum recovery: terminate p4, the shared vertex.

process(p1).
process(p2).
process(p3).
process(p4).
process(p5).
process(p6).
process(p7).

resource(r1).
resource(r2).
resource(r3).
resource(r4).
resource(r5).
resource(r6).
resource(r7).
resource(r8).

allocated(p1, r1).
allocated(p2, r2).
allocated(p3, r3).
allocated(p4, r4).
allocated(p5, r5).
allocated(p6, r6).
allocated(p7, r7).

% Left rectangle: p1 -> p2 -> p4 -> p3 -> p1
requesting(p1, r2).
requesting(p2, r4).
requesting(p4, r3).
requesting(p3, r1).

% Right rectangle: p4 -> p5 -> p6 -> p7 -> p4
requesting(p4, r5).
requesting(p5, r6).
requesting(p6, r7).
requesting(p7, r4).
