@echo off
setlocal EnableDelayedExpansion

:: Database connection details
set "DB_NAME=tpch"
set "DB_USER=SA"
set "DB_PASS="
set "DB_URL=jdbc:hsqldb:hsql://localhost/tpch"

:: Directories for queries and results
set "QUERY_DIR=C:\Users\qasim\Downloads\queries"
set "RESULTS_DIR=C:\Users\qasim\Downloads\queriesresults"

:: Check if results directory exists, if not, create it
if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"

:: Check if query directory exists, if not, create it
if not exist "%QUERY_DIR%" mkdir "%QUERY_DIR%"

:: Initialize total execution time
set "TOTAL_EXEC_TIME=0"

:: Total number of queries
set /a TOTAL_QUERIES=22

:: Classpath for HSQLDB
set "CLASSPATH=C:\databases\hsqldb\lib\hsqldb.jar;C:\databases\hsqldb\lib\sqltool.jar"

:: Initialize total execution time
set /a TOTAL_EXEC_TIME=0

:: Loop through all query files
for /L %%i in (1, 1, 22) do (
    echo Executing Query %%i...

    :: Capture start time using PowerShell
    for /f "delims=" %%a in ('powershell -Command "(Get-Date).ToUniversalTime().Subtract([datetime]::Parse('1970-01-01')).TotalSeconds"') do set "START_TIME=%%a"
    echo Start Time: !START_TIME!

    :: Execute the query and save the result in the specific folder
    java -cp "!CLASSPATH!" org.hsqldb.cmdline.SqlTool --inlineRc=url=!DB_URL!,username=!DB_USER!,password=!DB_PASS! "!QUERY_DIR!\%%i.sql" > "!RESULTS_DIR!\result%%i.txt"

    :: Capture end time using PowerShell
    for /f "delims=" %%b in ('powershell -Command "(Get-Date).ToUniversalTime().Subtract([datetime]::Parse('1970-01-01')).TotalSeconds"') do (
        set "END_TIME=%%b"
        echo End Time: !END_TIME!

        :: Calculate execution time in seconds
        set /a EXEC_TIME=0
        if defined END_TIME if defined START_TIME set /a EXEC_TIME=END_TIME - START_TIME
        
	set /a EXEC_TIME=END_TIME - START_TIME

        :: Add execution time to total
        set /a TOTAL_EXEC_TIME+=EXEC_TIME

        :: Log execution time in the results folder
        echo Query %%i execution time: !EXEC_TIME! s >> "!RESULTS_DIR!\query_times.log"
    )
)

:: Optionally display the total execution time
echo Total Execution Time: !TOTAL_EXEC_TIME! s


:: Log total execution time
echo Total execution time: !TOTAL_EXEC_TIME! seconds >> "!RESULTS_DIR!\query_times.log"

:: Calculate throughput (queries per second)
if !TOTAL_EXEC_TIME! neq 0 (
    set /a THROUGHPUT=!TOTAL_QUERIES! / !TOTAL_EXEC_TIME!
) else (
    set "THROUGHPUT=0"
)
echo Throughput: !THROUGHPUT! queries per second >> "!RESULTS_DIR!\query_times.log"

echo All queries executed. Check %RESULTS_DIR%\query_times.log for execution times.

endlocal
