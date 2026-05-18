% =============================================================================
% Example: Two Wait Chains Without Deadlock
% =============================================================================

% Eight process & ten resource
% Wait-for structure:
%
%   Chain 1:
%     p1 --> p2 --> p3 --+
%                        |
%                        v
%                       p7 --> p8 --> r10 (available)
%                        ^
%                        |
%   Chain 2:             |
%     p4 --> p5 --> p6 --+
%
% p3 and p6 both wait for p7, so the chains merge.
% Both chains eventually request an available resource, so there is no cycle.
% Expected result: no deadlock.

process(p1).
process(p2).
process(p3).
process(p4).
process(p5).
process(p6).
process(p7).
process(p8).

resource(r1).
resource(r2).
resource(r3).
resource(r4).
resource(r5).
resource(r6).
resource(r7).
resource(r8).
resource(r9).
resource(r10).

allocated(p1, r1).
allocated(p2, r2).
allocated(p3, r3).
allocated(p4, r4).
allocated(p5, r5).
allocated(p6, r6).
allocated(p7, r7).
allocated(p8, r8).

% Chain 1: p1 -> p2 -> p3, then p3 waits for an available resource.
requesting(p1, r2).
requesting(p2, r3).
requesting(p3, r7).

% Chain 2: p4 -> p5 -> p6 -> p7 -> p8, then p8 waits for an available resource.
requesting(p4, r5).
requesting(p5, r6).
requesting(p6, r7).
requesting(p7, r8).
requesting(p8, r10).
