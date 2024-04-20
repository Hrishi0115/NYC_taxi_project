import json


def json_url_writer(taxi_colour, start_year, end_year, start_month, end_month):
    with open(f'json_files/{taxi_colour}_lookup.json', 'w') as f:
        url_list = []

        base_url = f'https://d37ci6vzurychx.cloudfront.net/trip-data/'


        if start_year == end_year:
            months = list((f'{month:02d}' for month in range(start_month,end_month+1)))
        elif start_year < end_year:
            months = list((f'{month:02d}' for month in range(start_month,12+1)))
        else:
            raise ValueError('start year must be less than or equal to end year')

        year = start_year

        while year <= end_year:
            for month in months:
                info = {}
                
                info['fullUrl'] = f'{base_url}{taxi_colour}_tripdata_{year}-{month}.parquet'
                info['relativeUrl'] = f'{taxi_colour}_tripdata_{year}-{month}.parquet'
                info['sink_filename'] = f'{taxi_colour}_taxi_{year}-{month}.parquet'

                url_list.append(info)
            
            year += 1
            if year == end_year:
                months = list((f'{month:02d}' for month in range(1,end_month+1)))


        json.dump(url_list, f)



