from pymongo import MongoClient
import datetime
client = MongoClient("mongodb://localhost")

db = client['test']

def ex2():
    result = db.restaurants.insert_one({'address': {
                'building': '1480',
                'street': '2 Avenue',
                'zipcode': '10075',
                'coords': [-73.9557413, 40.7720266]
          },
        'borough': 'Manhattan',
        'cuisine': 'Italian',
        'name': 'Vella',
        'id': 41704620,
        'grades': [{'date': datetime.datetime(2014, 12, 22, 0, 0), 'grade': 'A', 'score': 10}]

    })

    print(result)

ex2()
