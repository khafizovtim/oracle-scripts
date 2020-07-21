select kglnaobj,kglobt03 from X$KGLCURSOR_CHILD_SQLID  where 
instr(kglnahsv,ltrim(lower(to_char(&&sql_id_from_hanganalyze,'XXXXXXXX'))))<>0;
exit
