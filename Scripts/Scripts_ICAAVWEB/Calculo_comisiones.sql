/* ------------------CASO 1------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 194;
SET @pr_id_servicio			= 145;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_porcentaje_tit_2, @pr_porcentaje_aux_2,@pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
SELECT @pr_message;

/* ------------------CASO 2------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 194;
SET @pr_id_servicio			= 145;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 5;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_porcentaje_tit_2, @pr_porcentaje_aux_2,@pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
SELECT @pr_message;

/* ------------------CASO 3------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 194;
SET @pr_id_servicio			= 145;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2000;
SET @pr_monto_tit_2			= 100;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2 ,@pr_porcentaje_tit_2, @pr_porcentaje_aux_2,@pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
SELECT @pr_message;