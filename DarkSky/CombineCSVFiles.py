import csv

#Loop thought the historic years
for year in range(2016,2018):
    fout = open(f"./Output/DarkSkyTimeMachine-{year}.csv", "w")
    csv_write_file = csv.writer(fout, lineterminator='\n', delimiter=',')
    #Loop though the months
    for month in range(1 ,13):
        read_file_name = f"./Output/DarkSkyTimeMachine-{year}-{month}.csv"
        print(f"Reading : {read_file_name}")
        #If month 1 then output the CSV Headings
        if month ==1:
            with open(read_file_name, mode='rt')  as read_file:  # utf8
                csv_read_file = csv.reader(read_file,
                                           delimiter=',')  # CSVREADER READS FILE AS 1 LIST PER ROW. SO WHEN WRITIN TO ANOTHER  CSV FILE WITH FUNCTION WRITEROWS, IT INTRODUCES ANOTHER NEW LINE '\N' CHARACTER. SO TO AVOID DOUBLE NEWLINES , WE SET NEWLINE AS '' WHEN WE OPEN CSV WRITER OBJECT
                csv_write_file.writerows(csv_read_file)
        else:
        #Not 1st month so skip the headings
            with open(read_file_name, mode='rt')  as read_file:  # utf8
                csv_read_file = csv.reader(read_file,
                                           delimiter=',')  # CSVREADER READS FILE AS 1 LIST PER ROW. SO WHEN WRITIN TO ANOTHER  CSV FILE WITH FUNCTION WRITEROWS, IT INTRODUCES ANOTHER NEW LINE '\N' CHARACTER. SO TO AVOID DOUBLE NEWLINES , WE SET NEWLINE AS '' WHEN WE OPEN CSV WRITER OBJECT
                next(csv_read_file)  # ignore header
                csv_write_file.writerows(csv_read_file)

    #Close the file
    fout.close()


