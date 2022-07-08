# City Population Tracker

Architecture Diagram:

![alt text](diagram.jpg)

This Python Flask application is keep track of list of cities and their population. The backend database is used in this demo application is Elasticsearch.

API Endpoints:

/add_city : This API endpoint is accept a POST request along with data ('id' 'cityname' 'population') and data will be insert into Elasticsearch's population indice

/search_city : This API endpoint is accept a POST request along with data ('cityname') and query the Elasticsearch and return the data

/all_city : This API endpoint is accept a GET request return all the data from Elasticsearch indice population

/health : This API used to check wheather the application is up or not by returing mesaage : OK and it is checked by kubernetes readiness and livenesss probes.