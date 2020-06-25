col sqltext for a80
set lines 160 pages 300
with 
function sleep return number is
begin
 dbms_lock.sleep(&&seconds);
 return 0;
end;
t1 as (select   hsecs from v$timer),
m1 as (select   sql_id,executions,CPU_TIME,sql_text,buffer_gets from v$sqlarea ),
s as (select  sleep*count(*) one from dual),
m2 as (select  sql_id,executions,CPU_TIME,sql_text,buffer_gets from v$sqlarea ),
t2  as (select   hsecs from v$timer)
select * from(
select /*+ ORDERED */ m2.cpu_time-m1.cpu_time cpu_time,m2.sql_id sql_id,translate(substr(m2.sql_text,1,80), chr(10) || chr(13) || chr(09), ' ') sqltext,m2.executions-m1.executions executions,m2.buffer_gets-m1.buffer_gets gets,(t2.hsecs-t1.hsecs+one)/100 seconds from t1,m1,s,m2,t2
where m1.sql_id=m2.sql_id union all
select    m2.cpu_time cpu_time,m2.sql_id sql_id,translate(substr(m2.sql_text,1,80), chr(10) || chr(13) || chr(09), ' ') sqltext,m2.executions executions,m2.buffer_gets gets,(t2.hsecs-t1.hsecs+one)/100 seconds  from t1,s,m2,t2 where m2.sql_id not in (select sql_id from  m1))
order by 1 desc fetch first &&number_of_queries rows only
/
