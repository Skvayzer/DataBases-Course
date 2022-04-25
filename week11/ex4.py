
from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost")

db = client['test']

def ex4():
    result = db.restaurants.find({'address.street': 'Rogers Avenue'})
    for document in result:
        count=0
        for grade in document['grades']:
            if grade['grade'] == 'C':
                count+=1
        if count > 1:
            result = db.restaurants.delete_one({'_id': document['_id']})
        else:
            result = db.restaurants.find_one_and_update({'_id': document['_id']},
                                 {"$push": {'grades': {
                                     'date': datetime.datetime.today(),
                                     'grade': 'C',
                                     'score': '1'
                                 }}})
        print(document)


ex4()


