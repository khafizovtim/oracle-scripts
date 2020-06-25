create global temporary table ktipro (n number,PROGRAM VARCHAR2(48),CPU_USED number);

begin
insert into ktipro select 1,program,CPU_USED from v$process where BACKGROUND='1';
dbms_lock.sleep(10);
insert into ktipro select 2,program,CPU_USED from v$process where BACKGROUND='1';
end;
/
select k2.program,k2.CPU_USED- k1.CPU_USED
from (select * from ktipro  where n=1) k1, (select * from ktipro  where n=2) k2 where k1.program=k2.program order by 2;

commit;
