select col.column_id,
       col.owner as schema_name,
       col.table_name,
   --    gm.AD,
       col.column_name,
       col.data_type,
       col.data_length,
       col.data_precision,
       col.data_scale,
       col.nullable
from sys.all_tab_columns col
inner join sys.all_tables t on col.owner = t.owner
                              and col.table_name = t.table_name
--inner join GEN_MODUL gm on substr(col.TABLE_NAME,1,3) = gm.MODUL_UZANTISI
-- excluding some Oracle maintained schemas
where col.owner in ('GONSON') AND COL.COLUMN_NAME LIKE '%SICIL_KOD%' AND COL.TABLE_NAME LIKE 'TMS%'
order by col.owner, col.table_name, col.column_id;


,2798,2895,3179,3342,3595,3809