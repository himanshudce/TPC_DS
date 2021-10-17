# TPC_DS MariaDB Benchmarking 
Data warehouse project @ ULB-2021 

### Linux
### 1. install supporting tools:
Ubuntu:
```
sudo apt-get install gcc make flex bison byacc git
```

### 2. clone the repo and build the tools using make:
```
git clone https://github.com/himanshudce/TPC_DS
cd tpcds_kit/tools
make OS=LINUX
```

### 3.Generate data 
```
cd tpcds_kit/tools
./dsdgen -scale 1 -dir {$path to save data}
```

### 4.Define table schema and load table data
a.] remove root password and run
```
sh ./load_data.sh
```

### 5.Run all queries 
```
python3 run_all_queries.py
```
