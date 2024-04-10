from get_zones import get_zone

## FUNCTION FILE CURRENTLY ONLY READS 5 ROWS (SEE LINE 82)
## NEEDS TO BE CHANGED TO READ ENTIRE FILE WHEN READY


# before running this, needs to be in a format containing trip ids
# for each trip
# then can filter in line 80:
# trips = trips[['trip_id', 'Start_Lon', 'Start_Lat', 'End_Lon', 'End_Lat']]
# this will speed the script up massively



file_in = r'C:\Users\TylerWoodstock\week14_15_project\notes\zoning\files\yellow_tripdata_2009-01.parquet'
file_out = r'C:\Users\TylerWoodstock\week14_15_project\notes\zoning\yellow_zones_2009-01.csv'

get_zone(file_in, file_out)



