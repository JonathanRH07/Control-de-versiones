DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_carga_gds_c`(
	IN  pr_id_grupo_empresa INT,
    OUT pr_rows_tot_table	INT,
	OUT pr_message			VARCHAR(5000)
)
BEGIN

	SELECT
		id_grupo_empresa,
		UNCOMPRESS(host_bd),
        UNCOMPRESS(usuario_bd),
        UNCOMPRESS(password_bd),
        UNCOMPRESS(base_bd),
        UNCOMPRESS(puerto_bd),
        UNCOMPRESS(carpeta)
    FROM st_adm_tc_config_carga_gds
    WHERE id_grupo_empresa = pr_id_grupo_empresa;

END$$
DELIMITER ;
