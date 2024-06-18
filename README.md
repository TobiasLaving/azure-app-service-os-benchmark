# Azure App Service OS Benchmark
Is Windows or Linux best for running C# projects in Azure App Services?
This is a small project I put together to see if I could see any difference between the two offerings.
The program was, WebServer, deployed on different app service plans and tested using `scripts/run.sh`.

The various `scripts/test_{NUMBER}` folders in `scripts` contains all the collected output as well as some info on the app services and run info.

## TLDR
The difference is usually small and choosing the best price (linux) should work well for most workloads that is similar to this basic app.

Note that the libraries used by the application can have very different performance depending on os which this basic application and test do not [capture] (https://stackoverflow.com/questions/63447218/performance-issues-in-running-net-core-apis-in-azure-app-services-for-linux)

## Methodolgy
- The tests was carried out by deploying the application on otherwise empty app service plans using the 'Code' deployment method. I did not build my own container for the linux service. 

- The tests was done using 1, 10, 100 kb response body size configured used query parameters.

- The idea is to measure how effective the web server is, testing downline performance such as databases or external services is not in scope.

- All tests were done by performing 5000 requests over 150 threads.

- The tests were running from my work machine towards the azure over wifi

Local machine tooling:
```
[tobias@tobias-expertbook Benchmark]$ dotnet --info
.NET SDK:
 Version:           8.0.204
 Commit:            c338c7548c
 Workload version:  8.0.200-manifests.9f663350

Runtime Environment:
 OS Name:     manjaro
 OS Version:
 OS Platform: Linux
 RID:         linux-x64
 Base Path:   /home/tobias/.dotnet/sdk/8.0.204/

.NET workloads installed:
There are no installed workloads to display.

Host:
  Version:      8.0.4
  Architecture: x64
  Commit:       2d7eea2529

.NET SDKs installed:
  8.0.201 [/home/tobias/.dotnet/sdk]
  8.0.204 [/home/tobias/.dotnet/sdk]

.NET runtimes installed:
  Microsoft.NETCore.App 8.0.2 [/home/tobias/.dotnet/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 8.0.4 [/home/tobias/.dotnet/shared/Microsoft.NETCore.App]

Other architectures found:
  None

Environment variables:
  DOTNET_ROOT       [/home/tobias/.dotnet]

global.json file:
  Not found

Learn more:
  https://aka.ms/dotnet/info

Download .NET:
  https://aka.ms/dotnet/download

```
```
[tobias@tobias-expertbook Benchmark]$ pamac info apache | grep Version
Version               : 2.4.59-1
```

## Results

### Premium v2 P1V2
VCPU: 1
Memory: 3.5
Linux price/month: 83.95 USD
Windows price/month: 146.00 USD

| Response size (kB) | Measurement | Linux | Windows
|--|--|--|--|
| **1 kb** | |
| | Total time [seconds] | 2.945 | 1.980
| | Requests per seconds [#/sec]| 1698.01 | 2525.00
| | Mean time per request [ms] | 88.339 | 59.406
| **10 kb** | |
| | Total time [seconds] | 6.426 | 6.360
| | Requests per seconds [#/sec]| 778.12 | 786.17
| | Mean time per request [ms] | 192.772 | 190.798
| **100 kb** | |
| | Total time [seconds] | 46.563 | 46.706
| | Requests per seconds [#/sec]| 107.38 | 107.05
| | Mean time per request [ms] | 1396.882 | 1401.193

### Premium v3 P0V3
VCPU: 1
Memory: 4
Linux price/month: 84.68 USD
Windows price/month: 156.95 USD

| Response size (kB) | Measurement | Linux | Windows
|--|--|--|--|
| **1 kb** | |
| | Total time [seconds] | 2.043 | 1.819
| | Requests per seconds [#/sec]| 2447.61 | 2748.15
| | Mean time per request [ms] | 61.284 | 54.582
| **10 kb** | |
| | Total time [seconds] | 6.434 | 6.958
| | Requests per seconds [#/sec]| 777.10 | 718.57
| | Mean time per request [ms] | 193.024 | 208.748
| **100 kb** | |
| | Total time [seconds] | 47.700 | 47.158
| | Requests per seconds [#/sec]| 104.82 | 106.03
| | Mean time per request [ms] | 1431.004 | 1414.733

### Premium v3 P1V3
VCPU: 2
Memory: 8
Linux price/month: 129.94 USD
Windows price/month: 246.74 USD

| Response size (kB) | Measurement | Linux | Windows
|--|--|--|--|
| **1 kb** | |
| | Total time [seconds] | 2.243 | 1.955
| | Requests per seconds [#/sec]| 2229.06 | 2558.03
| | Mean time per request [ms] | 67.293 | 58.639
| **10 kb** | |
| | Total time [seconds] | 6.506 | 6.186
| | Requests per seconds [#/sec]| 768.54 | 808.33
| | Mean time per request [ms] | 195.176 | 185.568
| **100 kb** | |
| | Total time [seconds] | 46.993 | 46.129
| | Requests per seconds [#/sec]| 106.40 | 108.39
| | Mean time per request [ms] | 1409.804 | 1383.870


### CPU graph
Below is pictures of the cpu graph recorded by azure. Note that this is the graph over the entire test run meaning the app service plan was updated etc.

#### Linux
Cpu
![Linux average cpu](/azure-app-service-os-benchmark/assets/asp-benchmark-linux-cpu.png)
Memory
![Linux average memory](/azure-app-service-os-benchmark/assets/asp-benchmark-linux-memory.png)
#### Windows
Cpu
![Windows average cpu](/azure-app-service-os-benchmark/assets/asp-benchmark-windows-cpu.png)
Memory
![Windows average memory](/azure-app-service-os-benchmark/assets/asp-benchmark-windows-memory.png)

The most interesting aspect is the spike in linux cpu usage around 08:53
This was relative early and the server was under any "great" load at the time. I have tried to recreate it without success which makes me lean towards thinking it was issues with the underlying Azure service rather than the app.


### Summary
As seen in the tests above the difference is mostly small. The windows machines seems to have a slight edge, especially on smaller response bodies. For me personally the difference is not big enough to warrant the price of windows services which is almost the double.

Across all tests, both windows and linux would choke every now and again resulting in very poor performance. I chalked it poor luck and issues in Azure infrastructure out of my control. When this happened, the test was repeated.

While both env was having this issues, I believe linux _might_ be more prone. Another set of tests would need to be made to confirm this though.

## Notes
- The tests were done towards http rather than https endpoints
- Inspired by [this](https://robertoprevato.github.io/Comparing-Linux-hosted-to-Windows-hosted-ASP-NET-Core-applications-in-Azure-Application-Service-Plan/)
