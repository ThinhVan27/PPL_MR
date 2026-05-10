% =============================================================================
% Example: Schema with BCNF Violation but satisfying 3NF
% =============================================================================
% Relation: course_schedule(CourseID, Instructor, Department)
%
% Functional Dependencies:
%   FD1: CourseID → Instructor
%   FD2: CourseID → Department
%   FD3: Instructor → Department
%
% Analysis: 
%   - Candidate key: {CourseID}
%   - FD3 (Instructor → Department) violates BCNF because Instructor is not a superkey
%   - But FD3 does not violate 3NF because... let's check if Department is prime
%   - Actually Department is NOT prime (not part of any candidate key)
%   - So this violates both BCNF and 3NF
% =============================================================================

relation(course_sched).

attribute(course_sched, course_id).
attribute(course_sched, instructor).
attribute(course_sched, department).

% FD1: CourseID → Instructor
fd(course_sched, fd1).
fd_lhs(course_sched, fd1, course_id).
fd_rhs(course_sched, fd1, instructor).

% FD2: CourseID → Department
fd(course_sched, fd2).
fd_lhs(course_sched, fd2, course_id).
fd_rhs(course_sched, fd2, department).

% FD3: Instructor → Department (the problematic FD)
fd(course_sched, fd3).
fd_lhs(course_sched, fd3, instructor).
fd_rhs(course_sched, fd3, department).

% Candidate key: {CourseID}
attr_set(course_sched, key1, course_id).
candidate_key_member(course_sched, key1, course_id).

% =============================================================================
% Relation: exam_result(StudentID, ExamID, RoomID, Score)
%
% Functional Dependencies:
%   FD1: StudentID, ExamID → Score
%   FD2: StudentID, ExamID → RoomID
%   FD3: RoomID → ExamID  (a room is used for only one exam)
%
% Analysis:
%   - Candidate keys: {StudentID, ExamID} and {StudentID, RoomID}
%   - FD3: RoomID → ExamID violates BCNF (RoomID alone is not a superkey)
%   - But ExamID is prime (part of candidate key {StudentID, ExamID})
%   - So FD3 does NOT violate 3NF! (RHS is prime)
%   - This is a classic 3NF-but-not-BCNF example
% =============================================================================

relation(exam_result).

attribute(exam_result, student_id).
attribute(exam_result, exam_id).
attribute(exam_result, room_id).
attribute(exam_result, score).

% FD1: StudentID, ExamID → Score
fd(exam_result, fd1).
fd_lhs(exam_result, fd1, student_id).
fd_lhs(exam_result, fd1, exam_id).
fd_rhs(exam_result, fd1, score).

% FD2: StudentID, ExamID → RoomID
fd(exam_result, fd2).
fd_lhs(exam_result, fd2, student_id).
fd_lhs(exam_result, fd2, exam_id).
fd_rhs(exam_result, fd2, room_id).

% FD3: RoomID → ExamID
fd(exam_result, fd3).
fd_lhs(exam_result, fd3, room_id).
fd_rhs(exam_result, fd3, exam_id).

% Candidate keys
attr_set(exam_result, key1, student_id).
attr_set(exam_result, key1, exam_id).

attr_set(exam_result, key2, student_id).
attr_set(exam_result, key2, room_id).

candidate_key_member(exam_result, key1, student_id).
candidate_key_member(exam_result, key1, exam_id).
candidate_key_member(exam_result, key2, student_id).
candidate_key_member(exam_result, key2, room_id).
