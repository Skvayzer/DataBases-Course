

CREATE TABLE IF NOT EXISTS Publisher (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);
CREATE TABLE IF NOT EXISTS Book (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL,
  	publisherId integer NOT NULL,
    FOREIGN KEY (publisherId) REFERENCES Publisher(id)
);
CREATE TABLE IF NOT EXISTS School (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);
CREATE TABLE IF NOT EXISTS Room (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);
CREATE TABLE IF NOT EXISTS Teacher (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL,
    schoolId integer NOT NULL REFERENCES school(id),
    roomId integer NOT NULL REFERENCES room(id),
    grade smallint NOT NULL
);
CREATE TABLE IF NOT EXISTS Course (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);
CREATE TABLE IF NOT EXISTS Loan (
    id serial NOT NULL PRIMARY KEY,
    teacherId integer NOT NULL REFERENCES teacher(id),
    courseId integer NOT NULL REFERENCES course(id),
    bookId integer NOT NULL REFERENCES book(id),
    loanDate date NOT NULL
);

INSERT INTO Publisher (name)
VALUES ('BOA Editions'),
    ('Taylor & Francis Publishing'),
    ('Prentice Hall'),
    ('McGraw Hill');
INSERT INTO Book (name, publisherId)
VALUES ('Learning and teaching in early childhood', 1),
    ('Preschool,N56', 2),
    ('Early Childhood Education N9', 3),
    ('Know how to educate: guide for Parents', 4);
INSERT INTO School (name)
VALUES ('Horizon Education Institute'),
    ('Bright Institution');
INSERT INTO Room (name)
VALUES ('1.A01'),
    ('1.B01'),
    ('2.B01');
INSERT INTO Teacher (name, schoolId, roomId, grade)
VALUES ('Chad Russell', 1, 1, 1),
    ('E.F.Codd', 1, 2, 1),
    ('Jones Smith', 1, 1, 2),
    ('Adam Baker', 2, 3, 1);
INSERT INTO Course (name)
VALUES ('Logical thinking'),
    ('Wrtting'),
    ('Numerical Thinking'),
    ('Spatial, Temporal and Causal Thinking'),
    ('English');
INSERT INTO Loan (teacherId, courseId, bookId, loanDate)
VALUES (1, 1, 1, TO_DATE('09/09/2010','DD/MM/YYYY')),
    (1, 2, 2, TO_DATE('05/05/2010','DD/MM/YYYY')),
    (1, 3, 1, TO_DATE('05/05/2010','DD/MM/YYYY')),
    (2, 4, 3, TO_DATE('06/05/2010','DD/MM/YYYY')),
    (2, 3, 1, TO_DATE('06/05/2010','DD/MM/YYYY')),
    (3, 2, 1, TO_DATE('09/09/2010','DD/MM/YYYY')),
    (3, 5, 4, TO_DATE('05/05/2010','DD/MM/YYYY')),
    (4, 1, 4, TO_DATE('05/05/2010','DD/MM/YYYY')),
    (4, 3, 1, TO_DATE('05/05/2010','DD/MM/YYYY'));


--Obtain for each of the schools, the number of books that have been loaned to each publishers.
SELECT s.name AS School,
    p.name AS Publisher,
    COUNT(*)
FROM Loan as l, Teacher as t, School as s, Book as b, Publisher as p
	Where t.id = l.teacherId And s.id = t.schoolId and b.id = l.bookId and p.id = b.publisherId
GROUP BY (s.id, p.id);


-- For each school, find the books that have been on loan the longest and the teacher in charge of it.
SELECT s.name AS school,
    b.name AS book,
    t.name AS teacher
FROM Loan as l
    JOIN Teacher AS t ON t.id = l.teacherId
    JOIN School AS s ON s.id = t.schoolId
    JOIN Book AS b ON b.id = l.bookId
    JOIN Publisher AS p ON p.id = b.publisherId
    JOIN (
        SELECT s.id,
            MIN(l.loanDate)
        FROM Loan as l, Teacher as t, School as s
            where t.id = l.teacherId and s.id = t.schoolId
        GROUP BY s.id
    ) AS m ON m.id = s.id
WHERE l.loanDate = m.min;
