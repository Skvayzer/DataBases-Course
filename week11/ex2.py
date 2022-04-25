import psycopg2

con = psycopg2.connect(database="Week11", user="postgres",
                       password="postgres", host="127.0.0.1", port="5432")
con.autocommit = False
cur = con.cursor()
print("Database opened successfully, no autocommit mode.")


cur.execute("DROP TABLE IF EXISTS accounts")
con.commit()

cur.execute("""CREATE TABLE accounts (
                    username VARCHAR(50) PRIMARY KEY,
                    fullname VARCHAR(50) NOT NULL,
                    balance INTEGER DEFAULT 0,
                    group_id INT NOT NULL DEFAULT 0
                );
                COMMIT;""")

data = [('jones', 'Alice Jones', 82, 1),
        ('bitdiddl', 'Ben Bitdiddle', 65, 1),
        ('mike', 'Michael Dole', 73, 2),
        ('alysaa', 'Alyssa P. Hacker', 79, 3),
        ('bbrown', 'Bob Brown', 100, 3)]

for entry in data:
    cur.execute(f"""INSERT INTO accounts (username, fullname, balance, group_id)
                    VALUES(
                        '{entry[0]}',
                        '{entry[1]}',
                        {entry[2]},
                        {entry[3]}    
                    );
                    COMMIT;""")

cur.execute("SELECT * FROM accounts;")
output = cur.fetchall()
for line in output:
    print(line)
