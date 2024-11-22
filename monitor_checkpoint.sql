select TRACEFILE  from v$process where addr=(select paddr from v$session where sid=sys_context('USERENV','SID'));
declare
 db_block_changes1 number;
 ckpt_block_writes1 number;
 writes_mttr1 number;
 writes_logfile_size1 number;
 writes_log_checkpoint_settings1 number;
 write_other_settings1 number;
 writes_autotune1 number;
 writes_full_thread_ckpt1 number;
 DBWR_checkpoint_buffers_written1 number;
 DBWR_undo_block_writes1 number; 
 redo_size_1 number;
 physical_write_bytes_1 number;
 physical_write_total_bytes_1 number;
 flashback_log_write_bytes_1 number;
 
 db_block_changes2 number;
 ckpt_block_writes2 number;
 writes_mttr2 number;
 writes_logfile_size2 number;
 writes_log_checkpoint_settings2 number;
 write_other_settings2 number;
 writes_autotune2 number;
 writes_full_thread_ckpt2 number;
 DBWR_checkpoint_buffers_written2 number;
 DBWR_undo_block_writes2 number; 
 redo_size_2 number;
 physical_write_bytes_2 number;  
 physical_write_total_bytes_2 number;
 flashback_log_write_bytes_2 number;
 seconds_wait number:=&1;
 seconds number;
 tracefile varchar2(513);
 time1 number;
 time2 number;
 rba_seq number;
 rba_bno number; 
begin
 SYS.DBMS_SYSTEM.KSDWRT(1,'Timestamp db_block_changes ckpt_block_writes writes_mttr writes_logfile_size writes_log_checkpoint_settings writes_other_settings writes_autotune writes_full_thread_ckpt physical_write_bytes DBWR_checkpoint_buffers_written DBWR_undo_block_writes redo_size flashback_log_write_bytes physical_write_total_bytes rba_seq rba_bno');
 select value into db_block_changes1 from v$sysstat where name='db block changes';
 select CKPT_BLOCK_WRITES,WRITES_MTTR,WRITES_LOGFILE_SIZE,WRITES_LOG_CHECKPOINT_SETTINGS,WRITES_OTHER_SETTINGS,WRITES_AUTOTUNE,WRITES_FULL_THREAD_CKPT 
   into ckpt_block_writes1, writes_mttr1, writes_logfile_size1, writes_log_checkpoint_settings1, write_other_settings1, writes_autotune1, writes_full_thread_ckpt1 from v$instance_recovery;
 select value into physical_write_bytes_1 from v$sysstat where name='physical write bytes';
 select value into physical_write_total_bytes_1 from v$sysstat where name='physical write total bytes';
 select value into redo_size_1 from v$sysstat where name='redo size'; 
 select value into flashback_log_write_bytes_1 from v$sysstat where name='flashback log write bytes';
 select value into DBWR_checkpoint_buffers_written1 from v$sysstat where name='DBWR checkpoint buffers written';
 select value into DBWR_undo_block_writes1 from v$sysstat where name='DBWR undo block writes';
 select hsecs into time1 from v$timer;
 loop
  dbms_session.sleep(seconds_wait);
  select value into db_block_changes2 from v$sysstat where name='db block changes';
  select CKPT_BLOCK_WRITES,WRITES_MTTR,WRITES_LOGFILE_SIZE,WRITES_LOG_CHECKPOINT_SETTINGS,WRITES_OTHER_SETTINGS,WRITES_AUTOTUNE,WRITES_FULL_THREAD_CKPT 
  into ckpt_block_writes2, writes_mttr2, writes_logfile_size2, writes_log_checkpoint_settings2, write_other_settings2, writes_autotune2, writes_full_thread_ckpt2 from v$instance_recovery;
  select value into physical_write_bytes_2 from v$sysstat where name='physical write bytes'; 
  select value into physical_write_total_bytes_2 from v$sysstat where name='physical write total bytes'; 
  select value into redo_size_2 from v$sysstat where name='redo size'; 
  select value into flashback_log_write_bytes_2 from v$sysstat where name='flashback log write bytes';
  select value into DBWR_checkpoint_buffers_written2 from v$sysstat where name='DBWR checkpoint buffers written';
  select value into DBWR_undo_block_writes2 from v$sysstat where name='DBWR undo block writes';
  select hsecs into time2 from v$timer;
  seconds:=(time2-time1)/100;
  --SYS.DBMS_SYSTEM.KSDWRT(1,'CKPT_STATS for '||seconds||'s '||--
  select cplrba_seq ,cplrba_bno into rba_seq,rba_bno  from x$kcccp where cpdrt<>0;
  SYS.DBMS_SYSTEM.KSDWRT(1,to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||' '||--
trunc((db_block_changes2-db_block_changes1)/seconds                          )||' '||--                                           
trunc((ckpt_block_writes2-ckpt_block_writes1)*8192/1048576/seconds                          )||' '||--
                        		   trunc((writes_mttr2-writes_mttr1)*8192/1048576/seconds                                      )||' '||--
                                           trunc((writes_logfile_size2-writes_logfile_size1)*8192/1048576/seconds                      )||' '||--
                                           trunc((writes_log_checkpoint_settings2-writes_log_checkpoint_settings1)*8192/1048576/seconds)||' '||--
                                           trunc((write_other_settings2-write_other_settings1)*8192/1048576/seconds                    )||' '||--
                                           trunc((writes_autotune2-writes_autotune1)*8192/1048576/seconds                              )||' '||--
                                           trunc((writes_full_thread_ckpt2-writes_full_thread_ckpt1)*8192/1048576/seconds              )||' '||--
                                           trunc((physical_write_bytes_2-physical_write_bytes_1)/1048576/seconds                       )||' '||--
                                           trunc((DBWR_checkpoint_buffers_written2-DBWR_checkpoint_buffers_written1)*8192/1048576/seconds   )||' '||--  
                                           trunc((DBWR_undo_block_writes2-DBWR_undo_block_writes1)*8192/1048576/seconds                     )||' '||--  
                                           trunc((redo_size_2-redo_size_1)/1048576/seconds                                             )||' '||--
                                           trunc((flashback_log_write_bytes_2-flashback_log_write_bytes_1)/1048576/seconds             )||' '||--
                                           trunc((physical_write_total_bytes_2-physical_write_total_bytes_1)/1048576/seconds)||' '||
                                           rba_seq||' '||
                                           rba_bno    
);
 db_block_changes1:=db_block_changes2;
 ckpt_block_writes1:=ckpt_block_writes2;
 writes_mttr1:=writes_mttr2;
 writes_logfile_size1:=writes_logfile_size2;
 writes_log_checkpoint_settings1:=writes_log_checkpoint_settings2;
 write_other_settings1:=write_other_settings2;
 writes_autotune1:=writes_autotune2;
 writes_full_thread_ckpt1:=writes_full_thread_ckpt2;
 physical_write_bytes_1:=physical_write_bytes_2;
 physical_write_total_bytes_1:=physical_write_total_bytes_2;
 DBWR_checkpoint_buffers_written1:=DBWR_checkpoint_buffers_written2;
 DBWR_undo_block_writes1:=DBWR_undo_block_writes2;
 flashback_log_write_bytes_1:=flashback_log_write_bytes_2;
 redo_size_1:=redo_size_2;
 time1:=time2;
 end loop;
end;
/
