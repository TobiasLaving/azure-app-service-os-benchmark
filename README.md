# Azure App Service Linux vs Windows performance
This is a small project I put together to see if I could see any difference between the two offerings
The program was deployed on different app service plans and tested using the `scripts/run.sh`
There is also a small `scripts/read.sh` script to compare the results a bit easier.



The various test_{NUMBER} folders in `scripts` contains the output as well as some info on what app service plan was used during the test.

## Results
### Table:
| App Service Plan | Test | Linux | Windows |
|--|--|--|--|
|Premium v2 P1V2| test_1 | 
| | **1 kb** | |
| | Total time [seconds] | 22.526 | 30.670
| | Requests per seconds | 221.97 | 163.02
| | Time per request (mean) [ms] | 675.767 | 920.109
| | Time per request (mean, across all concurrent requests) [ms] | 4.505 | 6.134
| | **10 kb** | |
| | Total time [seconds] | 24.062 | 31.063
| | Requests per seconds | 207.80 | 160.96
| | Time per request (mean) [ms] | 721.865 | 931.904
| | Time per request (mean, across all concurrent requests) [ms] | 4.812 | 6.213
| | **100 kb** | |
| | Total time [seconds] | 30.379 | 28.871
| | Requests per seconds | 164.59 | 173.18
| | Time per request (mean) [ms] | 911.355 | 866.142
| | Time per request (mean, across all concurrent requests) [ms] | 6.076 | 5.774
|Premium v3 P0V3| test_2 | 
| | **1 kb** | |
| | Total time [seconds] | 20.261 | 21.256
| | Requests per seconds | 246.79 | 235.23
| | Time per request (mean) [ms] | 607.815 | 637.671
| | Time per request (mean, across all concurrent requests) [ms] | 4.052 | 4.251
| | **10 kb** | |
| | Total time [seconds] | 23.299 | 21.984
| | Requests per seconds | 214.60 | 227.44
| | Time per request (mean) [ms] | 698.962 | 659.515
| | Time per request (mean, across all concurrent requests) [ms] | 4.660 | 4.397
| | **100 kb** | |
| | Total time [seconds] | 29.629 | 34.393
| | Requests per seconds | 168.75 | 145.38
| | Time per request (mean) [ms] | 888.884 | 1031.791
| | Time per request (mean, across all concurrent requests) [ms] | 5.926 | 6.879
|Premium v3 P1V3| test_3_2 | 
| | **1 kb** | |
| | Total time [seconds] | 21.159 | 20.204
| | Requests per seconds | 236.31 | 247.48
| | Time per request (mean) [ms] | 634.759 | 606.117
| | Time per request (mean, across all concurrent requests) [ms] | 4.232 | 4.041
| | **10 kb** | |
| | Total time [seconds] | 22.901 | 21.190
| | Requests per seconds | 218.33 | 235.96
| | Time per request (mean) [ms] | 687.043 | 635.698
| | Time per request (mean, across all concurrent requests) [ms] | 4.580 | 4.238
| | **100 kb** | |
| | Total time [seconds] | 31.310 | 32.906
| | Requests per seconds | 159.69 | 151.95
| | Time per request (mean) [ms] | 939.301 | 987.193
| | Time per request (mean, across all concurrent requests) [ms] | 6.262 | 6.581


### Summary
As seen in the table above, the difference in performance is for the most part very small and can probably be accounted for by simple "luck". The table does not contain test_3 but rather test_3_2 as test_3 had a timeout during the linux test. Looking at the results however, we can see that only 1% of the linux requests had the timeout. Similar issues was seen with windows, sadly I did not keep that particular run.

As such I believe that both platforms suffer from azure jitter but when performing "properly" they perform similar.

## Notes
- The tests were done towards http rather than https endpoints

