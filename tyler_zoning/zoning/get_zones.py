
import geopandas as gpd
from shapely.geometry import Point
from pyproj import Proj, transform
import pyarrow.parquet as pq
import pandas as pd
from shapely.geometry import Point, Polygon

def get_zone(filename_in, file_out_name):

    # Load the GeoJSON file containing multipolygon geometries
    # this file only needs to be read once, to get the shapes of each zone in NYC
    nyc_zones_in = gpd.read_file(r'C:\Users\TylerWoodstock\week14_15_project\notes\zoning\files\taxi_zones.json')

    # Reproject the GeoDataFrame to EPSG:4326 (latitude-longitude)
    source_crs = {'init': 'epsg:2263'}  # New York State Plane Coordinate System
    target_crs = {'init': 'epsg:4326'}  # WGS84 (latitude/longitude)

    nyc_zones = nyc_zones_in.to_crs(epsg=4326)


    # Define the projection for LCC (replace these values with your specific projection parameters)
    ## THIS WORKS - CORRECT PROJECTION PARAMETERS
    lcc_proj = Proj(
        proj='lcc',           # Projection type: Lambert Conformal Conic
        datum='WGS84',        # Datum: World Geodetic System 1984
        lat_1=40.66666666,    # First standard parallel (approximately 40°39'59.99996"N)
        lat_2=41.03333333,    # Second standard parallel (approximately 41°02'00.00002"N)
        lat_0=40.16666666,    # Latitude of origin (approximately 40°10'00.00002"N)
        lon_0=-74.00000000,   # Central meridian (approximately 74°00'00.00000"W)
        x_0=300000,           # False Easting (meters)
        y_0=0,                # False Northing (meters)
        units='us-ft',        # Units: US Survey Feet
        ellps='GRS80',        # Ellipsoid: Geodetic Reference System 1980
        no_defs=True          # Don't use additional projection parameters from the Proj definition file
    )

    # kept constant
    wgs84_projection = Proj(proj='latlong', datum='WGS84', ellps='WGS84', no_defs=True)


    # # Define a function to extract latitude and longitude from a geometry
    def extract_lon_lat(row):

        if row.type == 'MultiPolygon':

            lon_lat_list = []

            # Iterate over each polygon in the MultiPolygon
            for polygon in row.geoms:
                # Access exterior coordinates of the polygon
                x_coords, y_coords = polygon.exterior.coords.xy
                
                # Convert the exterior coordinates to latitude and longitude using the projection
                lon_lat_list.extend([(x, y) for x, y in zip(x_coords, y_coords)])

            return [transform(lcc_proj, wgs84_projection, x, y) for x, y in lon_lat_list]
        else:
            lon, lat = row.exterior.coords.xy
            return [transform(lcc_proj, wgs84_projection, x, y) for x, y in zip(lon, lat)]

    # # Apply the function to the geometry column to get latitudes and longitudes
    nyc_zones['lon_lat'] = nyc_zones['geometry'].apply(extract_lon_lat)

    ## NOW HAVE A LIST OF NYC ZONES AND THEIR POLYGON COORDINATES 
    ## THIS IS USED FOR MAPPING EACH PICK UP AND DROP OFF coordinate










    ## read data from parquet file (this is repeated and iterated for all yellow files pre 2015?)
    trips = pq.read_table(filename_in)
    trips = trips.to_pandas()
    trips = trips[['Start_Lon', 'Start_Lat', 'End_Lon', 'End_Lat']]

    trips = trips.loc[0:5]






    ## now map each row in trips to a zone in nyc_zones

    # get start points for each trip
    start_points = []
    slat = list(trips['Start_Lat'])
    slon = list(trips['Start_Lon'])

    for lon, lat in zip(slon, slat):
        start_points.append(Point(lon, lat))

    # get end points for each trip
    end_points = []
    elat = list(trips['End_Lat'])
    elon = list(trips['End_Lon'])

    for lon, lat in zip(elon, elat):
        end_points.append(Point(lon, lat))



    # get pick up ids
    pu_ids = []
    pu_zones = []
    for pnt in start_points:
        for idx, zone in nyc_zones.iterrows():
            if pnt.within(Polygon(zone['lon_lat'])):
                pu_ids.append(zone['LocationID'])
                pu_zones.append(zone['zone'])
                break

            if idx == len(nyc_zones) - 1:
                pu_ids.append(None)
                pu_zones.append(None)
            


    # # get drop off ids
    do_ids = []
    do_zones = []
    for pnt in end_points:
        for idx, zone in nyc_zones.iterrows():
            if pnt.within(Polygon(zone['lon_lat'])):
                do_ids.append(zone['LocationID'])
                do_zones.append(zone['zone'])
                break

            if idx == len(nyc_zones) - 1:
                do_ids.append(None)
                do_zones.append(None)   

    # takes approx 1 min per 300 rows

    print(len(pu_ids))
    print(len(do_ids))
    print(len(trips))


    trips['pu_zone_id'] = pu_ids
    trips['pu_zone'] = pu_zones
    trips['do_zone_id'] = do_ids
    trips['do_zone'] = do_zones

    print(trips)

    df = pd.DataFrame(trips)

    df.to_csv(file_out_name)