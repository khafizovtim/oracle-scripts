set lines 100
set pages 10000
set heading off termout off echo off feedback off tab off  trimspool on
spool events.txt
select event#,name from v$event_name;
exit;
