from pymongo import MongoClient

client = MongoClient("mongodb://localhost")

db = client['test']

def ex1_1():
      cursor = db.restaurants.find({'cuisine':'Indian'})
      for document in cursor:
            print(document)

def ex1_2():
      cursor = db.restaurants.find({
          "$or": [{
              "cuisine": 'Indian'
          }, {
              "cuisine": 'Thai'
          }]
      })
      for document in cursor:
            print(document)

def ex1_3():
      cursor = db.restaurants.find({
            'address.building': '1115',
            'address.street': 'Rogers Avenue',
            'address.zipcode': '11226'
      })

      for document in cursor:
            print(document)

ex1_1()
# ex1_2()
# ex1_3()
