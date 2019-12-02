DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cxc_cliente`(
	IN  pr_grupo_empresa INT,
    IN  pr_fecha_ini	DATE,
    IN  pr_fecha_fin	DATE,
    IN  pr_id_cliente	INT,
    IN  pr_id_moneda	INT,
    IN  pr_id_sucursal	INT,
    OUT pr_message		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_cxc_cliente
	@fecha: 		04/05/2018
	@descripción: 	Sp para obtenber resportes de cxc por cliente
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE lo_fecha_actual			DATE;
    DECLARE lo_ter_cursor    		INTEGER DEFAULT 0;
    DECLARE lo_id_cliente			INT;
    /*JSON*/
    -- DECLARE lo_json_fac				TEXT DEFAULT '';
    /*total*/
    DECLARE lo_mont_tot				DECIMAL(15,2);
    DECLARE lo_no_facturas			INT;
    /*totales por vencimiento*/
    DECLARE lo_clave_ven			VARCHAR(25);
    DECLARE lo_nom_dia_ven 			VARCHAR(25);
    DECLARE lo_mon_tot_ven			DECIMAL(15,2);
    DECLARE lo_facturas				INT;
    /*totales por vencimiento a 7 dias*/
    DECLARE lo_clave_ven_7			VARCHAR(25);
    DECLARE lo_nom_dia_ven_7 		VARCHAR(25);
    DECLARE lo_mon_tot_ven_7		DECIMAL(15,2);
    DECLARE lo_facturas_7			INT;
    /*totales por vencimiento a 21 dias*/
    DECLARE lo_clave_ven_21			VARCHAR(25);
    DECLARE lo_nom_dia_ven_21 		VARCHAR(25);
    DECLARE lo_mon_tot_ven_21		DECIMAL(15,2);
    DECLARE lo_facturas_21			INT;
    /*totales por vencimiento más 21 dias*/
    DECLARE lo_clave_ven_n			VARCHAR(25);
    DECLARE lo_nom_dia_ven_n 		VARCHAR(25);
    DECLARE lo_mon_tot_ven_n		DECIMAL(15,2);
    DECLARE lo_facturas_n			INT;
    /*Cursor para detalle por cliente*/
    DECLARE lo_id_cliente_rep		INT;
    DECLARE lo_cve_cliente_rep		INT;
    DECLARE lo_nom_come_rep			VARCHAR(255);
    DECLARE lo_mon_tot_rep		DECIMAL(15,2);
    DECLARE lo_mon_tot_ven_rep		DECIMAL(15,2);
    DECLARE lo_mon_tot_ven_7_rep 	DECIMAL(15,2);
    DECLARE lo_mon_tot_ven_21_rep	DECIMAL(15,2);
    DECLARE lo_mon_tot_ven_n_rep	DECIMAL(15,2);

    DECLARE lo_cu_cliente CURSOR FOR
	SELECT id_cliente
    FROM ic_cat_tr_cliente
    WHERE id_grupo_empresa = pr_grupo_empresa
    AND   id_cliente = pr_id_cliente;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxc_cliente';
	END ;

    -- Inicia cursor
	DECLARE CONTINUE HANDLER FOR
	NOT FOUND SET lo_ter_cursor = 1;

	OPEN lo_cu_cliente;
	lp_loop : LOOP

		FETCH lo_cu_cliente INTO lo_id_cliente;

		IF lo_ter_cursor = 1 THEN
			LEAVE lp_loop;
		END IF;

		    SELECT
				cte.id_cliente,
                cte.cve_cliente,
                cte.nombre_comercial,
                SUM(cxc.cantidad)
			INTO
				lo_id_cliente_rep,
                lo_cve_cliente_rep,
                lo_nom_come_rep,
                lo_mon_tot_rep
			FROM ic_glob_tr_cxc cxc
			JOIN ic_cat_tr_cliente cte ON
				cxc.id_cliente = cte.id_cliente
			AND  cte.id_grupo_empresa
			WHERE cxc.id_cliente = lo_id_cliente;

            SELECT
				IFNULL(SUM(cantidad),0) monto_total_ven
			INTO
				lo_mon_tot_ven_rep
			FROM ic_glob_tr_cxc
			WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -7 DAY)
			AND   fecha_emision <= DATE_FORMAT(NOW(),'%Y-%m-%d')
			AND   id_cliente 	 = pr_id_cliente
			AND   id_moneda 	 = pr_id_moneda
			AND   id_sucursal 	 = pr_id_sucursal
			AND   id_grupo_empresa = pr_grupo_empresa;

            SELECT
				IFNULL(SUM(cantidad),0) monto_total_ven
			INTO
				lo_mon_tot_ven_7_rep
			FROM ic_glob_tr_cxc
			WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
			AND   fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -7 DAY)
			AND   id_cliente 	 = pr_id_cliente
			AND   id_moneda 	 = pr_id_moneda
			AND   id_sucursal 	 = pr_id_sucursal
			AND   id_grupo_empresa = pr_grupo_empresa;

            SELECT
				IFNULL(SUM(cantidad),0) monto_total_ven
			INTO
				lo_mon_tot_ven_21_rep
			FROM ic_glob_tr_cxc
			WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -31 DAY)
			AND   fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
			AND   id_cliente 	 = pr_id_cliente
			AND   id_moneda 	 = pr_id_moneda
			AND   id_sucursal 	 = pr_id_sucursal
			AND   id_grupo_empresa = pr_grupo_empresa;

            SELECT
				IFNULL(SUM(cantidad),0) monto_total_ven
			INTO
				lo_mon_tot_ven_n_rep
			FROM ic_glob_tr_cxc
			WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
			-- AND   cxc.fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
			AND   id_cliente 	 = pr_id_cliente
			AND   id_moneda 	 = pr_id_moneda
			AND   id_sucursal 	 = pr_id_sucursal
			AND   id_grupo_empresa = pr_grupo_empresa;

            /*****************************************************************************************/
			BEGIN

				DECLARE lo_ter_cursor_det		INTEGER DEFAULT 0;
                DECLARE lo_id_factura			INT;
                DECLARE lo_json_fac				TEXT DEFAULT '';
                /*Cursor para detalle por factura*/
				DECLARE lo_cve_serie_fac		INT;
				DECLARE lo_fac_numero_fac		INT;
				DECLARE lo_fecha_emi_fac		DATE;
                DECLARE	lo_dias_vencidos_fac	INT;
                DECLARE lo_fecha_ven_fac		DATE;
				DECLARE lo_mon_tot_fac			DECIMAL(15,2);
				DECLARE lo_mon_tot_ven_fac		DECIMAL(15,2);
				DECLARE lo_mon_tot_ven_7_fac 	DECIMAL(15,2);
				DECLARE lo_mon_tot_ven_21_fac	DECIMAL(15,2);
				DECLARE lo_mon_tot_ven_n_fac	DECIMAL(15,2);


                DECLARE lo_cu_factura CURSOR FOR
				SELECT
					id_factura
				FROM ic_glob_tr_cxc
                WHERE id_cliente 	   = pr_id_cliente
                AND   id_grupo_empresa = pr_grupo_empresa
                AND   fecha_emision   >= pr_fecha_ini
                AND   fecha_emision   <= pr_fecha_fin
                AND   id_moneda 	   = pr_id_moneda
				AND   id_sucursal 	   = pr_id_sucursal;

                DECLARE CONTINUE HANDLER FOR
				NOT FOUND SET lo_ter_cursor_det = 1;

				OPEN lo_cu_factura;
				lp_loop_fac : LOOP

					FETCH lo_cu_factura INTO lo_id_factura;

					IF lo_ter_cursor_det = 1 THEN
						LEAVE lp_loop_fac;
					END IF;

					SELECT
						cve_serie,
						fac_numero,
						fecha_emision,
						cantidad,
						fecha_vencimiento,
						datediff(now(),fecha_vencimiento)
					INTO
						lo_cve_serie_fac,
                        lo_fac_numero_fac,
                        lo_fecha_emi_fac,
                        lo_mon_tot_fac,
                        lo_fecha_ven_fac,
                        lo_dias_vencidos_fac
					FROM ic_glob_tr_cxc
                    WHERE id_factura = lo_id_factura;
		  /*********************************************************/
          -- SELECT lo_cve_serie_fac,lo_fac_numero_fac,lo_fecha_emi_fac,lo_mon_tot_fac,lo_fecha_ven_fac,lo_dias_vencidos_fac;
          /*********************************************************/



					SET lo_json_fac = CONCAT(lo_json_fac,'{"serie": "',lo_cve_serie_fac,'","factura": "',lo_fac_numero_fac,'","fecha_emision": "',
											 lo_fecha_emi_fac,'","importe": "',lo_mon_tot_fac,'","fecha_vencimiento": "',lo_fecha_ven_fac,
                                             '","dias_vencidos": "',lo_fecha_ven_fac,'","dias_vencidos": "',lo_dias_vencidos_fac,'"},'
                    );
				SELECT lo_json_fac;
				END LOOP lp_loop_fac;
				CLOSE lo_cu_factura;
            END;

            -- SELECT lo_json_fac;
			/*****************************************************************************************/
    END LOOP lp_loop;
	CLOSE lo_cu_cliente;

	/*Obtiene fecha actual*/
	SELECT
		DATE_FORMAT(NOW(),'%Y-%m-%d')
	INTO
		lo_fecha_actual;

    /*Obtiene monto total y numero de facturas totales*/
    SELECT
		SUM(cantidad),
        COUNT(id_factura)
	INTO
		lo_mont_tot,
        lo_no_facturas
	FROM ic_glob_tr_cxc
	WHERE fecha_emision >= pr_fecha_ini -- '2018-01-01'
	AND   fecha_emision <= pr_fecha_fin -- '2018-04-28'
	AND   id_cliente = pr_id_cliente -- 799
	AND   id_moneda = pr_id_moneda -- 100
	AND   id_sucursal = pr_id_sucursal  -- 3
    AND   id_grupo_empresa = pr_grupo_empresa;

    /*Obtiene datos por vencer*/
    SELECT
		'por_vencer'  clave,
		'Por Vencer'  nombre_dia,
		IFNULL(SUM(cantidad),0) monto_total_ven,
		COUNT(id_factura) facturas_ven
	INTO
		lo_clave_ven,
		lo_nom_dia_ven,
		lo_mon_tot_ven,
		lo_facturas
	FROM ic_glob_tr_cxc
	WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -7 DAY)
	AND   fecha_emision <= DATE_FORMAT(NOW(),'%Y-%m-%d')
	AND   id_cliente 	 = pr_id_cliente
	AND   id_moneda 	 = pr_id_moneda
	AND   id_sucursal 	 = pr_id_sucursal
    AND   id_grupo_empresa = pr_grupo_empresa;

    /*Obtiene datos por vencer a 7 dias*/
    SELECT
		'por_vencer'  clave,
		'Por Vencer'  nombre_dia,
		IFNULL(SUM(cantidad),0) monto_total_ven,
		COUNT(id_factura) facturas_ven
	INTO
		lo_clave_ven_7,
		lo_nom_dia_ven_7,
		lo_mon_tot_ven_7,
		lo_facturas_7
	FROM ic_glob_tr_cxc
	WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
	AND   fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -7 DAY)
	AND   id_cliente 	 = pr_id_cliente
	AND   id_moneda 	 = pr_id_moneda
	AND   id_sucursal 	 = pr_id_sucursal
	AND   id_grupo_empresa = pr_grupo_empresa;

    /*Obtiene datos por vencer a 21 dias*/
    SELECT
		'por_vencer'  clave,
		'Por Vencer'  nombre_dia,
		IFNULL(SUM(cantidad),0) monto_total_ven,
		COUNT(id_factura) facturas_ven
	INTO
		lo_clave_ven_21,
		lo_nom_dia_ven_21,
		lo_mon_tot_ven_21,
		lo_facturas_21
	FROM ic_glob_tr_cxc
	WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -31 DAY)
	AND   fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
	AND   id_cliente 	 = pr_id_cliente
	AND   id_moneda 	 = pr_id_moneda
	AND   id_sucursal 	 = pr_id_sucursal
    AND   id_grupo_empresa = pr_grupo_empresa;

    /*Obtiene datos por vencer más 21 dias*/
    SELECT
		'por_vencer'  clave,
		'Por Vencer'  nombre_dia,
		IFNULL(SUM(cantidad),0) monto_total_ven,
		COUNT(id_factura) facturas_ven
	INTO
		lo_clave_ven_n,
		lo_nom_dia_ven_n,
		lo_mon_tot_ven_n,
		lo_facturas_n
	FROM ic_glob_tr_cxc
	WHERE fecha_emision >= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
	-- AND   cxc.fecha_emision <= DATE_ADD(DATE_FORMAT(NOW(),'%Y-%m-%d'), INTERVAL -21 DAY)
	AND   id_cliente 	 = pr_id_cliente
	AND   id_moneda 	 = pr_id_moneda
	AND   id_sucursal 	 = pr_id_sucursal
	AND   id_grupo_empresa = pr_grupo_empresa;


END$$
DELIMITER ;
