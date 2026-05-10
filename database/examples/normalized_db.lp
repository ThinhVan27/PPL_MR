% =============================================================================
% Example: Already Normalized Schema (in BCNF)
% =============================================================================
% This schema is already in BCNF. All non-trivial FDs have superkey LHS.
%
% Relation: student(StudentID, Name, Email)
%   FD: StudentID → Name, Email
%   Key: {StudentID}
%
% Relation: course(CourseID, Title, Credits)
%   FD: CourseID → Title, Credits
%   Key: {CourseID}
%
% Relation: takes(StudentID, CourseID, Semester, Grade)
%   FD: StudentID, CourseID, Semester → Grade
%   Key: {StudentID, CourseID, Semester}
% =============================================================================

% --- Relation: student ---
relation(student).
attribute(student, sid).
attribute(student, name).
attribute(student, email).

fd(student, fd1).
fd_lhs(student, fd1, sid).
fd_rhs(student, fd1, name).
fd_rhs(student, fd1, email).

attr_set(student, key1, sid).
candidate_key_member(student, key1, sid).

% --- Relation: course ---
relation(course).
attribute(course, cid).
attribute(course, title).
attribute(course, credits).

fd(course, fd1).
fd_lhs(course, fd1, cid).
fd_rhs(course, fd1, title).
fd_rhs(course, fd1, credits).

attr_set(course, key1, cid).
candidate_key_member(course, key1, cid).

% --- Relation: takes ---
relation(takes).
attribute(takes, sid).
attribute(takes, cid).
attribute(takes, semester).
attribute(takes, grade).

fd(takes, fd1).
fd_lhs(takes, fd1, sid).
fd_lhs(takes, fd1, cid).
fd_lhs(takes, fd1, semester).
fd_rhs(takes, fd1, grade).

attr_set(takes, key1, sid).
attr_set(takes, key1, cid).
attr_set(takes, key1, semester).
candidate_key_member(takes, key1, sid).
candidate_key_member(takes, key1, cid).
candidate_key_member(takes, key1, semester).
