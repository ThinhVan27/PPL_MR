% =============================================================================
% Example: Student Database Schema
% =============================================================================
% Relation: enrollment(StudentID, StudentName, CourseID, CourseName, Grade)
%
% Functional Dependencies:
%   FD1: StudentID → StudentName
%   FD2: CourseID → CourseName
%   FD3: StudentID, CourseID → Grade
%
% Analysis: This schema has BCNF violations (FD1 and FD2 have non-superkey LHS)
% =============================================================================

relation(enrollment).

attribute(enrollment, student_id).
attribute(enrollment, student_name).
attribute(enrollment, course_id).
attribute(enrollment, course_name).
attribute(enrollment, grade).

% FD1: StudentID → StudentName
fd(enrollment, fd1).
fd_lhs(enrollment, fd1, student_id).
fd_rhs(enrollment, fd1, student_name).

% FD2: CourseID → CourseName
fd(enrollment, fd2).
fd_lhs(enrollment, fd2, course_id).
fd_rhs(enrollment, fd2, course_name).

% FD3: StudentID, CourseID → Grade
fd(enrollment, fd3).
fd_lhs(enrollment, fd3, student_id).
fd_lhs(enrollment, fd3, course_id).
fd_rhs(enrollment, fd3, grade).

% --- Candidate key analysis ---
% The candidate key is {StudentID, CourseID}
% We define attribute sets to check if they are superkeys
attr_set(enrollment, key1, student_id).
attr_set(enrollment, key1, course_id).

% Individual attributes (not superkeys)
attr_set(enrollment, single_sid, student_id).
attr_set(enrollment, single_cid, course_id).

% Candidate key membership (for prime attribute detection)
candidate_key_member(enrollment, key1, student_id).
candidate_key_member(enrollment, key1, course_id).
