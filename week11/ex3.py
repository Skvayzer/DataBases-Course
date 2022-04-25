 

from pymongo import MongoClient
client = MongoClient("mongodb://localhost")

db = client['test']

def ex3_1():
    result = db.restaurants.delete_one({'borough': 'Manhattan'})
    print(result)
def ex3_2():
    result = db.restaurants.delete_many({'cuisine': 'Thai'})
    print(result)
ex3_1()
# ex3_2()
