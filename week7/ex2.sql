CREATE TABLE IF NOT EXISTS Course
(
    courseId  integer PRIMARY KEY,
    courseName text NOT NULL,
    grade integer NOT NULL,

);


CREATE TABLE IF NOT EXISTS StudyPeriod
(
    studyPeriodId  integer PRIMARY KEY,
    courseId   integer    NOT NULL,
    teacherId integer NOU NULL,
    bookId integer NOT NULL,
    room text NOT NULL,

    FOREIGN KEY (book_id) REFERENCES Book (book_id)
);

CREATE TABLE IF NOT EXISTS Teacher
(
    teacherId    integer PRIMARY KEY,
    teacherName text    NOT NULL,
    schoolName text NOT NULL,

);

CREATE TABLE IF NOT EXISTS Book
(
    bookId    integer PRIMARY KEY,
    bookName text    NOT NULL,
    publisher text NOT NULL,
    loanDate date NOT NULL,


);
/*
CREATE TABLE IF NOT EXISTS AuthorPub
(
    author_id       integer NOT NULL,
    pub_id          integer NOT NULL,
    author_position text    NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Author (author_id),
    FOREIGN KEY (pub_id) REFERENCES Pub (pub_id)
);*/

INSERT INTO Course
VALUES (1, 'Logical thinking', 1),
       (2, 'Wrtting', 1),
       (3, 'Numerical Thinking', 1),
       (4, 'Claude', 'Shannon'),
       (5, 'Alan', 'Turing'),
       (6, 'Alonzo', 'Church'),
       (7, 'Perry', 'White'),
       (8, 'Moshe', 'Vardi'),
       (9, 'Roy', 'Batty')
ON CONFLICT DO NOTHING;

INSERT INTO Book
VALUES (1, 'CACM', 'April', 1960, 8),
       (2, 'CACM', 'July', 1974, 8),
       (3, 'BTS', 'July', 1948, 2),
       (4, 'MLS', 'November', 1936, 7),
       (5, 'Mind', 'October', 1950, null),
       (6, 'AMS', 'Month', 1941, null),
       (7, 'AAAI', 'July', 2012, 9),
       (8, 'NIPS', 'July', 2012, 9)
ON CONFLICT DO NOTHING;

INSERT INTO Pub
VALUES (1, 'LISP', 1),
       (2, 'Unix', 2),
       (3, 'Info Theory', 3),
       (4, 'Turing Machines', 4),
       (5, 'Turing Test', 5),
       (6, 'Lambda Calculus', 6)
ON CONFLICT DO NOTHING;

INSERT INTO AuthorPub
VALUES (1, 1, 1),
       (2, 2, 1),
       (3, 2, 2),
       (4, 3, 1),
       (5, 4, 1),
       (5, 5, 1),
       (6, 6, 1)
ON CONFLICT DO NOTHING;


-- Obtain for each of the schools, the number of books that have been loaned to each publishers.
SELECT schoolName, publisher, COUNT(bookId)
FROM StudyPeriod, Book, Teacher
GROUP BY publisher

-- For each school, find the book that has been on loan the longest and the teacher in charge of it.
SELECT


-- 1.
SELECT *
FROM Author
         JOIN Book ON author_id = editor;

-- 2.
SELECT first_name, last_name
FROM (
      (SELECT author_id
       FROM Author
       EXCEPT
       SELECT editor
       FROM Book) as A_except_E
         JOIN Author on A_except_E.author_id = Author.author_id
    );

-- 3.
SELECT author_id
FROM Author
EXCEPT
SELECT editor
FROM Book
