#!/usr/bin/python
import psycopg2
from geopy.geocoders import Nominatim

def function(address_contains, city_id_from, city_id_to):
    """ get parts provided by a vendor specified by the vendor_id """
    conn = None
    try:
        # read database configuration
        # connect to the PostgreSQL database
        conn =psycopg2.connect(
            host="127.0.0.1",
            database="dvdrental",
            user="root",
            password="root", port="5433", connect_timeout=3)
        # create a cursor object for execution
        cur = conn.cursor()
        # another way to call a function
        #cur.execute("SELECT * FROM get_parts_by_vendor( %s); ",(vendor_id,))
        #cur.execute("SELECT * FROM address")

        cur.callproc('ex1', (address_contains, city_id_from, city_id_to))
        # process the result set
        #row = cur.fetchall()
        return cur.fetchall()

        #while row is not None:
            #print(row)
            #row = cur.fetchone()
        # close the communication with the PostgreSQL database server
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, "AAA")
    finally:
        if conn is not None:
            conn.close()




if __name__ == '__main__':
    addresses = function("11", 400, 600)
    print(addresses)

    conn =psycopg2.connect(
        host="127.0.0.1",
        database="dvdrental",
        user="root",
        password="root", port="5433", connect_timeout=3)
    # create a cursor object for execution
    cur = conn.cursor()
    for address in addresses:
        try:
            geolocator = Nominatim(user_agent="postgres")
            location = geolocator.geocode(address)
            print((location.latitude, location.longitude))
            cur.execute(
                "UPDATE address SET address2=(%s)"
                " WHERE address = (%s)",
                ("("+str(location.latitude) + ","+str(location.longitude)+")", address,));
        except (Exception) as error:
            print(error)
            cur.execute(
                "UPDATE address SET address2=(%s)"
                " WHERE address = (%s)",
                ("(0,0)", address,));
        #print(location.address)
        #print(location.raw)
    conn.commit()
    cur.close()
    conn.close()
