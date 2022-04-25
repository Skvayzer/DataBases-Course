import psycopg2

con = psycopg2.connect(database="Week11", user="postgres",
                       password="postgres", host="127.0.0.1", port="5432")
con.autocommit = False
cur = con.cursor()
print("Database opened successfully, no autocommit mode.")

cur.execute("DROP TABLE IF EXISTS account")
cur.execute("DROP TABLE IF EXISTS Ledger")
con.commit()

com = """CREATE TABLE account (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    credit VARCHAR(50),
    currency INT
);"""
cur.execute(com)
con.commit()

com = """CREATE TABLE Ledger (
    id SERIAL PRIMARY KEY,
    from_ INT NOT NULL,
    to_ INT NOT NULL,
    fee INT NOT NULL,
    amount INT NOT NULL,
    transaction_date_time date NOT NULL
);"""
cur.execute(com)
con.commit()

names = ['Ivan', "Anna", "Maruf"]

for i in range(len(names)):
    com1 = f"""INSERT INTO account (id, name, credit, currency)
            VALUES ({i + 1}, '{names[i]}', 'RUB', 1000); """
    cur.execute(com1)
    con.commit()

cur.execute("SELECT * FROM account;")
print(cur.fetchall())

trans_sums = [500, 700, 100]
trans_from_to = [(1, 3), (2, 1), (2, 3)]
trans_list = []

for sum, dest in zip(trans_sums, trans_from_to):
    trans_list.append(f"""
                        UPDATE account
                            SET currency = currency - {sum}
                            WHERE id = {dest[0]};
                        
                        UPDATE account
                            SET currency = currency + {sum}
                            WHERE id = {dest[1]}; 
                        
                        INSERT INTO Ledger (from_, to_, fee, amount, transaction_date_time) 
                        VALUES (
                            {dest[0]}, 
                            {dest[1]}, 
                            {0}, 
                            {sum}, 
                            (SELECT CURRENT_DATE)
                        );
                        """)
for i, trans in zip(range(len(trans_list)), trans_list):
    cur.execute("BEGIN;")
    cur.execute(f"SAVEPOINT T{i};")
    cur.execute(trans)

    print('-' * 60)
    print("Accounts currency:")
    cur.execute("SELECT currency from account ORDER BY id;")
    print(cur.fetchall())

    print('-' * 40)
    print("Ledger entries:")
    cur.execute("SELECT from_, to_, fee, amount  FROM Ledger;")

    output = cur.fetchall()
    for line in output:
        print(line)

    cur.execute(f"ROLLBACK TO T{i}")

    cur.execute("COMMIT;")

# Adding new column
cur.execute("""ALTER TABLE account ADD COLUMN BankName VARCHAR(50);""")
con.commit()

banks_names = ["Sber", "Tinkoff", "Sber"]
for i in range(3):
    cur.execute(f"""UPDATE account SET BankName = '{banks_names[i]}' WHERE id = {i + 1};""")
    con.commit()

cur.execute("INSERT INTO account (id, name, credit, currency) VALUES (4, 'sber_to_tink', 'USD', '30')")
con.commit()

print('~'*60)
print("Database with Bank names:")
cur.execute("SELECT * FROM account;")
for row in cur.fetchall():
    print(row)

trans_list = []
for sum, dest in zip(trans_sums, trans_from_to):
    trans_list.append(f"""
                        SAVEPOINT rollback;
                        
                        UPDATE account
                            SET currency = currency - {sum}
                             WHERE id = {dest[0]};
                  
                        UPDATE account AS acc
                            SET currency = acc.currency - fee.currency
                            FROM account AS fee 
                            WHERE acc.id = {dest[0]} 
                                AND fee.id = {4} 
                                AND acc.BankName NOT IN (SELECT BankName FROM account WHERE id = {dest[1]});
                        
                        UPDATE account
                            SET currency = currency + {sum}
                            WHERE id = {dest[1]};  
                        
                        INSERT INTO Ledger (from_, to_, fee, amount, transaction_date_time) 
                        VALUES (
                            {dest[0]}, 
                            {dest[1]}, 
                            CASE 
                                WHEN (SELECT BankName FROM account WHERE id = {dest[0]}) != (SELECT BankName FROM account WHERE id = {dest[1]})
                                    THEN (SELECT currency FROM account WHERE id = {4})
                                ELSE 0
                            END,
                            {sum}, 
                            (SELECT CURRENT_DATE)
                        );""")

for i, trans in zip(range(len(trans_list)), trans_list):
    cur.execute("BEGIN;")
    cur.execute(f"SAVEPOINT T{i};")
    cur.execute(trans)

    print('-' * 60)
    print("Accounts currency:")
    cur.execute("SELECT currency from account ORDER BY id;")
    print(cur.fetchall())

    print('-' * 40)
    print("Ledger entries:")
    cur.execute("SELECT from_, to_, fee, amount  FROM Ledger;")

    output = cur.fetchall()
    for line in output:
        print(line)

    cur.execute(f"ROLLBACK TO T{i}")

    cur.execute("COMMIT;")

print('-' * 60)
