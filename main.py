from flask import Flask
from elasticsearch import Elasticsearch
from flask import request
from flask import jsonify
import requests

def connect_elasticsearch():
    es_obj = Elasticsearch('http://elasticsearch-master:9200/')
    return es_obj


def test_elasticsearch():
    res = requests.get("http://elasticsearch-master:9200/_cluster/health")
    print (res.content)
    if res.status_code == 200:
        print ("ES Successful Connection")
    else:
        print ("ES Connection failed")

#Checking ES connection
test_elasticsearch()
es = connect_elasticsearch() 

app = Flask(__name__)

@app.route('/health')
def health():
	return 'OK'

@app.route('/add_city', methods=['POST'])
def add_city():
    city_id = request.form['id']
    city_name = request.form['cityname']
    population = request.form['population']

    user_obj = {
        'id': city_id,
        'city_name': '{}'.format(city_name),
        'population': '{}'.format(population)
    }
    result = es.index(index='population', id=city_id, body=user_obj, request_timeout=30)
    return jsonify(result)

@app.route('/search_city', methods=['POST'])
def search_user():
    keyword = request.form['keyword']

    query_body = {
        "query": {
            "match": {
                "city_name": keyword,
            }
        }
    }

    res = es.search(index="population", body=query_body)
    return jsonify(res['hits']['hits'])

@app.route('/all_city', methods=['GET'])
def all():
    all_body = {
		"_source": ["city_name","population"],
        "query": {
            "match_all": {}
        }
    }

    res = es.search(index="population", body=all_body)
    return jsonify(res['hits']['hits'])

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port='80')
