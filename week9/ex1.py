import psycopg2
conn = psycopg2.connect(dsn)
cur = conn.cursor()
cur.callproc('function', ("11", 400, 600))

