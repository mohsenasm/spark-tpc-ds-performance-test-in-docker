# Disclaimer

This is a work-in-progress project. (WIP)

# Usage

## 1. Build Docker Image
[![](https://images.microbadger.com/badges/image/mohsenasm/spark-tpc-ds-performance-test-in-docker.svg)](https://hub.docker.com/r/mohsenasm/spark-tpc-ds-performance-test-in-docker)

```
$ docker build . -t spark-tpc-ds
```

## 2. Create Docker Container

```
$ docker run -it -p 18080:18080 -p 4040:4040 spark-tpc-ds bash
```

## 3. Run history server

```
$ /usr/local/spark/sbin/start-history-server.sh
```

Now you can see history in browser at http://localhost:18080.

## 4. Run the Script

Perform the following steps to complete the execution of the script:

```
 $ cd spark-tpc-ds-performance-test
 $ bin/tpcdsspark.sh

==============================================
TPC-DS On Spark Menu
----------------------------------------------
SETUP
 (1) Create spark tables
RUN
 (2) Run a subset of TPC-DS queries
 (3) Run All (99) TPC-DS Queries
CLEANUP
 (4) Cleanup
 (Q) Quit
----------------------------------------------
Please enter your choice followed by [ENTER]:
```

### Setup Option: "(1) - Create Spark Tables"

This option creates the tables in the database name specified by `TPCDS_DBNAME` defined in `bin/tpcdsenv.sh`. The default name is `TPCDS` but can be changed if needed. The created tables are based on the pre-generated data.

The SQL statements to create the tables can be found in `src/ddl/individual`, and are created in parquet format for efficient processing.  

> Due to licensing restrictions, the TPCDS toolkit is not included as part of the code pattern. Instead, a pre-generated data set with 1GB scale factor is
  included in this pattern. If you want to work with a data set with larger scale factor or explore learning the full life sycle of setting up TPCDS, you can
  download the tool kit from [TPC-DS](http://www.tpc.org/tpcds) and compile in your development environment. Here are the instructions that describes how
  to compile the tool kit and generate data.


1. Compile the toolkit

   ```
   unzip <downloaded-tpc-ds-zipfile>
   cd <tpc-ds-toolkit-version>/tools
   make clean
   make OS=<platform>
   # (platform can be 'macos' or 'linux').
   ```

2. Generate the data.

   ```
   cd <tpc-ds-toolkit-version>/src/toolkit/tools
   ./dsdgen -dir <data_gen_dir> -scale <scale_factor>  -verbose y -terminate n
   # data_gen_dir => The output directory where data will be generated at.
   # scale_factor => The scale factor of data.

3. Generate the queries.

   The `dsqgen` utility in the tpcds toolkit may be used to generate the queries. Appropiate options should be passed to this utility. A typical example of its usage is:

   ```
   cd <tpc-ds-toolkit-version>/tools
   ./dsqgen -VERBOSE Y -DIALECT <dialectname> -DIRECTORY <query-template-dir> -SCALE <scale-factor> -OUTPUT_DIR <output-dir>
   ```

Below is example output for when this option is chosen.

```
==============================================
TPC-DS On Spark Menu
----------------------------------------------
SETUP
 (1) Create spark tables
RUN
 (2) Run a subset of TPC-DS queries
 (3) Run All (99) TPC-DS Queries
CLEANUP
 (4) Cleanup
 (Q) Quit
----------------------------------------------
Please enter your choice followed by [ENTER]: 1
----------------------------------------------

INFO: Creating tables. Will take a few minutes ...
INFO: Progress : [########################################] 100%
INFO: Spark tables created successfully..
Press any key to continue
```

### Run Option: "(2) - Run a subset of TPC-DS queries"

A comma separated list of queries can be specified in this option. The result of each query in the supplied list is generated in `TPCDS_WORK_DIR`, with a default directory location of `work`. The format of the result file is `query<number>.res`.

A summary file named `run_summary.txt` is also generated. It contains information about query number, execution time and number of rows returned.

*Note:*  The query number is a two digit number, so for query 1 the results will be in `query01.res`.

*Note:*  If you are debugging and running queries using this option, make sure to save `run_summary.txt` after each of your runs.

```
==============================================
TPC-DS On Spark Menu
----------------------------------------------
SETUP
 (1) Create spark tables
RUN
 (2) Run a subset of TPC-DS queries
 (3) Run All (99) TPC-DS Queries
CLEANUP
 (4) Cleanup toolkit
 (Q) Quit
----------------------------------------------
Please enter your choice followed by [ENTER]: 2
----------------------------------------------

Enter a comma separated list of queries to run (ex: 1, 2), followed by [ENTER]:
1,2
INFO: Checking pre-reqs for running TPC-DS queries. May take a few seconds..
INFO: Checking pre-reqs for running TPC-DS queries is successful.
INFO: Running TPCDS queries. Will take a few minutes depending upon the number of queries specified..
INFO: Progress : [########################################] 100%
INFO: TPCDS queries ran successfully. Below are the result details
INFO: Individual result files: spark-tpc-ds-performance-test/work/query<number>.res
INFO: Summary file: spark-tpc-ds-performance-test/work/run_summary.txt
Press any key to continue
```

### Run Option: "(3) - Run all (99) TPC-DS queries"

The only difference between this and option `(5)` is that all 99 TPC-DS queries are run instead of a subset.

*Note:* If you are running this on your laptop, it can take a few hours to run all  99 TPC-DS queries.

```
==============================================
TPC-DS On Spark Menu
----------------------------------------------
SETUP
 (1) Create spark tables
RUN
 (2) Run a subset of TPC-DS queries
 (3) Run All (99) TPC-DS Queries
CLEANUP
 (4) Cleanup toolkit
 (Q) Quit
----------------------------------------------
Please enter your choice followed by [ENTER]: 3
----------------------------------------------
INFO: Checking pre-reqs for running TPC-DS queries. May take a few seconds..
INFO: Checking pre-reqs for running TPC-DS queries is successful.
INFO: Running TPCDS queries. Will take a few minutes depending upon the number of queries specified..
INFO: Progress : [########################################] 100%
INFO: TPCDS queries ran successfully. Below are the result details
INFO: Individual result files: spark-tpc-ds-performance-test/work/query<number>.res
INFO: Summary file: spark-tpc-ds-performance-test/work/run_summary.txt
Press any key to continue
```

### Cleanup option: "(4) - Cleanup"

This will clean up all of the files generated during option steps 1, 2, and 3. If you use this option, make sure to run the setup steps (1) before running queries using option 2 and 3.

### Cleanup option: "(Q) - Quit"

This will exit the script.
