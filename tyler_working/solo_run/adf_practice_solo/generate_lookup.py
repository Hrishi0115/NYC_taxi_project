from json_lookup_writer import json_url_writer


# choose year range to generate relative urls for data source base url:
# (https://d37ci6vzurychx.cloudfront.net/trip-data/)

json_url_writer('green', 2014, 2019, 8, 1)
json_url_writer('yellow', 2009, 2019, 1, 1)
