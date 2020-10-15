set serveroutput on
declare
 stmt varchar2(200);
begin
 SELECT 'begin dbms_shared_pool.purge('''||address||','||hash_value||''''||','||'''C''); end;' into stmt FROM   v$sqlarea where sql_id='&1';
 execute immediate stmt;
exception 
 when no_data_found then
  dbms_output.put_line('No cursor found.');
end;
/
exit;
