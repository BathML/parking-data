## Dark Sky datasets

* `DarkSkyTimeMachine-YYYY.csv`: comma-delimited files of historical forecast data from Dark Sky API
* `Time_machine_data_fetcher.py`: script for processing consuming Dark Sky API.  A manually specified Year range is required in the script.  To support re-starts, individual CSV are produced for each month for the given year period. 
* `Combine_Csv_Files.py`: Script for combining the individual month CSV files into year CSV files.

As specified in the Dark Sky FAQ, any use of this data should include the reference to being powered to Dark Sky as per the details below: 

Powered by Dark Sky - https://darksky.net/poweredby/

For further information regards the use of the data please refer to the following : https://darksky.net/dev/docs/terms
