CREATE TABLE `ic_gds_tc_corporativa` (
  `id_tc_corporativa` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `no_tarjeta` char(20) DEFAULT NULL,
  `id_operador` int(11) DEFAULT NULL,
  `id_sat_bancos` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `vencimiento` char(7) DEFAULT NULL,
  `dia_corte` tinyint(4) DEFAULT NULL,
  `dia_pago` tinyint(4) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_tc_corporativa`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
