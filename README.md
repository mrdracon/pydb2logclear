EMC networker does not clear unnecessary transaction (Write-ahead) logs after DB2 backup. 
They pile up and take limited place. To fix space problem, i schedule with
puppet a cron task to periodically run clearing script.

Python script does the following:

1. Gets config for specific database - DB2 log directory and required log days-to-keep.
2. Forms a list of logs, calculate cutoff value to find old ones.
3. Removes old logs.