set @pr_affect_rows = 0;
set @pr_inserted_id = 0;
set @pr_message = '0';
call suite_mig_r2d2.sp_adm_insert_empresa('suite_mig_r2d2', @pr_affect_rows, @pr_inserted_id, @pr_message);
select @pr_affect_rows, @pr_inserted_id, @pr_message;
