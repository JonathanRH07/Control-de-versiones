USE suite_mig_demo;

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

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

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

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 233;
SET @pr_id_servicio			= 148;
SET @pr_cantidad			= 1;
SET @pr_monto				= 5000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;


/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 186;
SET @pr_id_servicio			= 146;
SET @pr_cantidad			= 1;
SET @pr_monto				= 5000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 50;
SET @pr_utilidad_porc		= 1.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 7;
SET @pr_id_vendedor			= 1674;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 194;
SET @pr_id_servicio			= 145;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2500;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 25;
SET @pr_utilidad_porc		= 1.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2500;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2500;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;/**/
SET @pr_utilidad_mont		= 600;
SET @pr_utilidad_porc		= 23.08;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 1000;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 50;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;
/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 35;
SET @pr_id_servicio			= 6;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2850;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2392;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 2;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 230;
SET @pr_utilidad_porc		= 10.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 4200;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 10;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 1050;
SET @pr_utilidad_porc		= 25.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2504;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 2;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 240;
SET @pr_utilidad_porc		= 10.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 4800;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 2880.00;
SET @pr_utilidad_porc		= 60;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 3800;
SET @pr_monto_tit_2			= 80.00;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 380;
SET @pr_utilidad_porc		= 10.00;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2800;
SET @pr_monto_tit_2			= 500;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 2240.00;
SET @pr_utilidad_porc		= 80;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 4800;
SET @pr_monto_tit_2			= 80;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 480;
SET @pr_utilidad_porc		= 10.0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2300;
SET @pr_monto_tit_2			= 150.00;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 200;
SET @pr_utilidad_porc		= 10.0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2800;
SET @pr_monto_tit_2			= 80;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 280;
SET @pr_utilidad_porc		= 10.0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 26;
SET @pr_id_servicio			= 124;
SET @pr_cantidad			= 1;
SET @pr_monto				= 2800;
SET @pr_monto_tit_2			= 0;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 280;
SET @pr_utilidad_porc		= 10.0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

/* ------------------------------------- */

SET @pr_id_grupo_empresa	= 1;
SET @pr_id_vendedor			= 1661;
SET @pr_id_vendedor_aux		= 0;
SET @pr_id_proveedor		= 89;
SET @pr_id_servicio			= 5;
SET @pr_cantidad			= 1;
SET @pr_monto				= 4200;
SET @pr_monto_tit_2			= 350;
SET @pr_porcentaje_tit_2	= 0;
SET @pr_monto_aux_2			= 0;
SET @pr_porcentaje_aux_2    = 0;
SET @pr_utilidad_mont		= 0;
SET @pr_utilidad_porc		= 0;

CALL suite_mig_demo.sp_fac_calcula_comision(@pr_id_grupo_empresa, @pr_id_vendedor, @pr_id_vendedor_aux, @pr_id_proveedor, @pr_id_servicio, @pr_cantidad, @pr_monto, @pr_monto_tit_2, @pr_porcentaje_tit_2, @pr_monto_aux_2, @pr_porcentaje_aux_2, @pr_utilidad_mont, @pr_utilidad_porc, @pr_message);
-- SELECT @pr_message;

SELECT *
FROM ic_cat_tr_plan_comision_fac
WHERE id_plan_comision = 68;

SELECT *
FROM tmp_calculo_comis_tit;