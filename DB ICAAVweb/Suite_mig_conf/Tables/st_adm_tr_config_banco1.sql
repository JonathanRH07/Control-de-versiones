CREATE TABLE `st_adm_tr_config_banco1` (
  `id_config_banco` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `cve_banco` varchar(50) DEFAULT NULL,
  `nom_cta_bancaria` varchar(200) DEFAULT NULL,
  `num_cta_bancaria` varchar(30) DEFAULT NULL,
  `num_cta_clabe` varchar(30) DEFAULT NULL,
  `num_sucursal` int(11) DEFAULT NULL,
  `id_moneda` int(11) DEFAULT NULL,
  `num_requisicion` int(11) DEFAULT NULL,
  `id_sat_bancos` int(11) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_config_banco`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
