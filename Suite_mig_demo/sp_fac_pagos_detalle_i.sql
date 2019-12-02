DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_detalle_i`(
	IN  pr_id_pago 			    INT(11),
	IN  pr_id_cxc 	            INT(11),
	IN  pr_importe_moneda_base	DECIMAL(13,2),
	IN  pr_importe_pago		    DECIMAL(13,2),
	-- IN  pr_no_parcialidad      INT(11),
	-- IN  pr_importe_usd         INT(11),
	-- IN  pr_importe_eur         INT(11),
    IN  pr_saldo_act		    DECIMAL(13,2),
    IN  pr_saldo_ant		    DECIMAL(13,2),
  --  IN  pr_comit                char(1)  ,
    OUT pr_inserted_id		    INT,
    OUT pr_affect_rows          INT,
    OUT pr_message 	            VARCHAR(500),
    OUT pr_parcialidad          INT)
BEGIN
/*
	@nombre: 		naranjas naranjeras
	@fecha: 		14/09/2017
	@descripcion: 	SP para inseratr en ic_fac_tr_pagos_detalle
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_no_parcialidad 	INT DEFAULT 0;
    DECLARE lo_no_parc_increm 	INT DEFAULT 0;
    DECLARE ld_tipo_cambio_usd 	DECIMAL(15,4);
    DECLARE ld_tipo_cambio_eur 	DECIMAL(15,4);
    DECLARE ld_importe_usd 		DECIMAL(13,4);
    DECLARE ld_importe_eur 		DECIMAL(13,4);
    DECLARE ld_tpo_cambio_cxc	DECIMAL(15,4);
	DECLARE ld_tpo_cambio_pr	DECIMAL(15,4);
    DECLARE ld_moneda_pago		LONG;
    DECLARE ld_moneda_cxc		LONG;
    DECLARE ld_id_gpo_emp		LONG;
    DECLARE ld_mn_cxc            CHAR(1);
    DECLARE ld_mn_pago           CHAR(1);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_pagos_detalle_i';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

    -- START TRANSACTION;

    SELECT
		IFNULL(MAX(no_parcialidad),0)
	INTO
		lo_no_parcialidad
    FROM ic_fac_tr_pagos_detalle
    JOIN ic_fac_tr_pagos  ON
         ic_fac_tr_pagos_detalle.id_pago =  ic_fac_tr_pagos.id_pago
    WHERE id_cxc = pr_id_cxc
		AND estatus = 'ACTIVO';

    SET lo_no_parc_increm = lo_no_parcialidad + 1;


    SELECT
		tipo_cambio_usd,tipo_cambio_eur ,id_moneda,id_grupo_empresa
    INTO
		ld_tipo_cambio_usd,ld_tipo_cambio_eur ,ld_moneda_pago,ld_id_gpo_emp
    FROM ic_fac_tr_pagos
    WHERE id_pago = pr_id_pago;


    SET ld_importe_usd = pr_importe_moneda_base / ld_tipo_cambio_usd;
    SET ld_importe_eur =  pr_importe_moneda_base / ld_tipo_cambio_eur;
    -- 	START TRANSACTION;

	SELECT
    tipo_cambio ,id_moneda
    INTO
     ld_tpo_cambio_cxc,ld_moneda_cxc
    FROM ic_glob_tr_cxc
    WHERE ic_glob_tr_cxc.id_cxc = pr_id_cxc;

    SELECT moneda_nacional
    INTO  ld_mn_cxc
	FROM suite_mig_conf.st_adm_tr_config_moneda
    WHERE  id_moneda = ld_moneda_cxc and id_grupo_empresa = ld_id_gpo_emp;

	SELECT moneda_nacional
    INTO  ld_mn_pago
	FROM suite_mig_conf.st_adm_tr_config_moneda
    WHERE  id_moneda = ld_moneda_pago and id_grupo_empresa = ld_id_gpo_emp;

    IF ld_mn_cxc = 'N' and ld_mn_pago = 'N' THEN
     SET ld_tpo_cambio_pr = ( ( pr_importe_moneda_base / ld_tpo_cambio_cxc) / pr_importe_pago );
    else
      SET ld_tpo_cambio_pr = ld_tpo_cambio_cxc;
	END IF;
	INSERT INTO ic_fac_tr_pagos_detalle(
		id_pago,
		id_cxc,
		importe_moneda_base,
		importe_pago,
        saldo_act,
        saldo_ant,
		no_parcialidad,
        importe_usd,
        importe_eur,
        tipo_cambio_dr
		)
	VALUE
		(
		pr_id_pago,
		pr_id_cxc,
		pr_importe_moneda_base,
		pr_importe_pago,
        pr_saldo_act,
        pr_saldo_ant,
		lo_no_parc_increm,
	    ld_importe_usd,
        ld_importe_eur,
        ld_tpo_cambio_pr
		);

    set pr_parcialidad    = lo_no_parcialidad ;
	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

-- 	 IF pr_comit = 'S' then
       -- COMMIT;
-- 	  END if;
END$$
DELIMITER ;
