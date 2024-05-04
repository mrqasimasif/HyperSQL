# CS505-001: Intermediate Topics in Database Systems (Spring 2024)
## Project: Performance benchmarking | HyperSQL 2.7.2

### About HyperSQL
HyperSQL DB is an open-source, relational database management system written in Java. It has JDBC and supports a large subset of SQL 92, 2008, 2011, and 2016 standards. It offers a fast, small database engine that offers both in-memory and disk-based tables. Both embedded and server modes are available. 

HSQLDB is available under a BSD license. It is used as a database and persistence engine in many open-source software projects, such as descendants of OpenOffice.org. HSQLDB has three transaction control modes. It supports read committed and serializable transaction isolation levels with table-level locks with multi-version concurrency control (MVCC), or a combination of locks and MVCC. 


## Prerequisites for installation
- Ubuntu 20.04
- Java (we used OpenJDK 11)
- CMake

## Installation instructions
- We followed the instruction provided by official site in collaboration with Tutorials point:
``` sh
https://www.tutorialspoint.com/hsqldb/hsqldb_installation.htm
```

## Clone the project
``` sh
git clone git@github.com:mrqasimasif/HyperSQL.git
cd hyper
```

## Download and prepare TPC-H data
``` sh
git clone https://github.com/electrum/tpch-dbgen.git
cd tpch-dbgen
make
./dbgen -s 1
```
These commands will download TPC-H dataset and generate a number of ``.tbl`` files, whose data will be imported at the end of databse set up and initialization.

## Prepare database
- Start Hyper in Server mode
``` sh
java -cp .\lib\hsqldb.jar org.hsqldb.Server --database.0 file:hsqldb/tpch --dbname.0 tpch
```
- Create a database in Hyper
``` sh
In another terminal window, connect to Hyper server and create and database.
java -cp "C:\databases\hsqldb\lib\hsqldb.jar;C:\databases\hsqldb\lib\sqltool.jar" org.hsqldb.cmdline.SqlTool --inlineRc=url=jdbc:hsqldb:hsql://localhost/tpch,username=SA,password=

```
- Now we need to create the required tables for populating TPC-H data
``` sh
The required table structures are present in the hyper/tables directory.
Execute them in hyper command line interface connected in last step.
```
- Next, we need to import the TPC-H data (as prepared above) into the database.
--We can wither use command line SQL instructions or a databse browser for this task. In our case we used **SQuirreL SQL client**. It can be accessed in the following location.
``` sh
http://www.squirrelsql.org/index.php?page=translations
```

## Run Tests
- Onec our databse is installed and TPC-H data loaded, we can run the queries from ``hyper/queries/``.
- We prepared a bash script for this task. It can be executed from the ``/hyper/`` directory of this project.
- Update the queries and results file path accordingly.
``` sh
cd hyper
./linux-run.sh or ./windows-run.bat
```

- Or you can pass the files indidually using 
``` sh
java -cp "C:\databases\hsqldb\lib\hsqldb.jar;C:\databases\hsqldb\lib\sqltool.jar" org.hsqldb.cmdline.SqlTool --inlineRc=url=jdbc:hsqldb:hsql://localhost/tpch,username=SA,password= !FILE.sql!
```
- The results of the test will be generated in ``results`` directory. The system stats will also be generated as ``vmstat_output.txt``.

