#!/bin/bash
sqlplus "/ as sysdba"<<EOF
drop tablespace data including contents and datafiles;
create smallfile tablespace data datafile '/kti2/data.dbf' size 16m autoextend on;
declare
 i pls_integer;
begin
for i in 1..16 loop
execute immediate 'create table instest'||i||' (n char(2000))  tablespace data';
end loop;
end; 
/
EOF
echo 'Start load'
for ((i=1;i<16;i++))
do
sqlplus "/ as sysdba" <<EOF &
set serveroutput on
declare
k pls_integer;
begin
for k in 1..100000
loop
  execute immediate 'insert into instest$i'||' values('||chr(39)||'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'||chr(39)||')';
end loop;
end;
/
EOF
done

