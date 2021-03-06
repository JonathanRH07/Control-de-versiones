CREATE TABLE `ic_gds_tr_general` (
  `id_gds_generall` int(11) NOT NULL AUTO_INCREMENT,
  `cve_gds` char(2) DEFAULT NULL,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `record_localizador` varchar(10) DEFAULT NULL,
  `fecha_reservacion` date DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `cve_centro_costo` varchar(10) DEFAULT NULL,
  `cve_depto` varchar(10) DEFAULT NULL,
  `cla_pax` varchar(20) DEFAULT NULL,
  `nombre_pax` varchar(30) DEFAULT NULL,
  `fecha_viaje` date DEFAULT NULL,
  `id_analisis_cliente` int(11) DEFAULT NULL,
  `cve_vendedor_tit` varchar(10) DEFAULT NULL,
  `cve_vendedor_aux` varchar(10) DEFAULT NULL,
  `comis_tit` decimal(15,2) DEFAULT NULL,
  `comis_aux` decimal(15,2) DEFAULT NULL,
  `numero_pax_frecuente` varchar(20) DEFAULT NULL,
  `tipo_pax` char(3) DEFAULT NULL,
  `cve_cliente` varchar(20) DEFAULT NULL,
  `cl_ciudad` varchar(80) DEFAULT NULL,
  `cl_codigo` varchar(5) DEFAULT NULL,
  `cl_nombre` varchar(100) DEFAULT NULL,
  `cl_rfc` varchar(20) DEFAULT NULL,
  `cl_tel` varchar(30) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `fac_numero` int(11) DEFAULT NULL,
  `texto_pnr` text,
  `fecha_recepcion` datetime DEFAULT NULL,
  `cancelado` char(1) DEFAULT NULL,
  `id_serie_cxs` int(11) DEFAULT NULL,
  `fac_numero_cxs` int(11) DEFAULT NULL,
  `fecha_boleteo` date DEFAULT NULL,
  `num_hot` int(11) DEFAULT '0',
  `num_aut` int(11) DEFAULT '0',
  `num_vue` int(11) DEFAULT '0',
  `pseudocity_reserva` varchar(10) DEFAULT NULL,
  `pseudocity_boletea` varchar(10) DEFAULT NULL,
  `cve_agente_reserva` varchar(10) DEFAULT NULL,
  `cve_agente_boletea` varchar(10) DEFAULT NULL,
  `cl_calle` varchar(100) DEFAULT NULL,
  `cl_num_exterior` varchar(45) DEFAULT NULL,
  `cl_num_interior` varchar(45) DEFAULT NULL,
  `cl_colonia` varchar(100) DEFAULT NULL,
  `cl_municipio` varchar(100) DEFAULT NULL,
  `cl_estado` varchar(80) DEFAULT NULL,
  `cl_pais` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_gds_generall`),
  KEY `fk_general_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_general_sucursal_idx` (`id_sucursal`),
  KEY `fk_general_serie_idx` (`id_serie`),
  CONSTRAINT `fk_general_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_general_serie` FOREIGN KEY (`id_serie`) REFERENCES `ic_cat_tr_serie` (`id_serie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_general_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3092 DEFAULT CHARSET=utf8;
