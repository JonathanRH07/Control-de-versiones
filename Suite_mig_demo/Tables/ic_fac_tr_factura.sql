CREATE TABLE `ic_fac_tr_factura` (
  `id_factura` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_centro_costo_n1` varchar(2000) DEFAULT NULL,
  `id_centro_costo_n2` varchar(2000) DEFAULT NULL,
  `id_centro_costo_n3` varchar(2000) DEFAULT NULL,
  `id_vendedor_tit` int(11) DEFAULT NULL,
  `id_vendedor_aux` int(11) DEFAULT NULL,
  `id_moneda` int(11) DEFAULT NULL,
  `id_razon_cancelacion` int(11) DEFAULT NULL,
  `id_status_cancelacion` int(11) DEFAULT NULL,
  `razon_social` varchar(300) DEFAULT NULL,
  `nombre_comercial` varchar(256) DEFAULT NULL,
  `id_direccion` int(11) DEFAULT NULL,
  `rfc` char(20) DEFAULT NULL,
  `tel` char(30) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_origen` int(11) DEFAULT NULL,
  `id_unidad_negocio` int(11) DEFAULT NULL,
  `id_cuenta_contable` int(11) DEFAULT NULL,
  `id_grupo_fit` int(11) DEFAULT NULL,
  `fac_numero` int(13) DEFAULT NULL,
  `fecha_factura` date DEFAULT NULL,
  `hora_factura` time DEFAULT NULL,
  `tipo_cambio` decimal(15,4) DEFAULT NULL,
  `solicito_cliente` varchar(100) DEFAULT NULL,
  `total_moneda_facturada` decimal(13,2) DEFAULT NULL,
  `total_moneda_base` decimal(16,2) DEFAULT NULL,
  `nota` varchar(100) DEFAULT NULL,
  `total_descuento` decimal(13,2) DEFAULT NULL,
  `globalizador` char(6) DEFAULT NULL,
  `descripcion_exten` longtext,
  `estatus` enum('ACTIVO','CANCELADA') DEFAULT 'ACTIVO',
  `motivo_cancelacion` varchar(256) DEFAULT NULL,
  `aplica_contabilidad` int(1) DEFAULT '0',
  `fecha_cancelacion` datetime DEFAULT NULL,
  `fecha_solicitud_cancelacion` date DEFAULT NULL,
  `hora_solicitud_cancelacion` time DEFAULT NULL,
  `id_usuario_cancelacion` int(11) DEFAULT NULL,
  `fecha_refacturacion` date DEFAULT NULL,
  `hora_refacturacion` time DEFAULT NULL,
  `tipo_refacturacion` enum('REFACTURACION','COPIA') DEFAULT NULL,
  `id_usuario_refacturacion` int(11) DEFAULT NULL,
  `id_factura_original` varchar(45) DEFAULT NULL,
  `envio_electronico` char(1) DEFAULT NULL,
  `tipo_formato` char(2) DEFAULT NULL,
  `id_pnr_consecutivo` int(11) DEFAULT NULL,
  `pnr` char(6) DEFAULT NULL,
  `confirmacion_pac` char(5) DEFAULT NULL,
  `email_envio` varchar(256) DEFAULT NULL,
  `c_MetodoPago` char(3) DEFAULT NULL,
  `c_UsoCFDI` char(3) DEFAULT NULL,
  `config_tipo_descu` char(1) DEFAULT NULL,
  `cve_tipo_cfdi_ingreso` char(2) DEFAULT NULL,
  `tipo_cfdi` char(1) DEFAULT NULL,
  `cve_tipo_serie` char(4) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tipo_cambio_usd` decimal(15,4) DEFAULT NULL,
  `tipo_cambio_eur` decimal(15,4) DEFAULT NULL,
  `email_vendedor` varchar(256) DEFAULT NULL,
  `NumRegldTrib` varchar(40) DEFAULT NULL,
  `id_virtuoso` varchar(50) DEFAULT NULL,
  `nota_factura` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  KEY `fk_fact_dir_idx` (`id_direccion`) USING BTREE,
  KEY `fk_factura_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_sucursal_factura_idx` (`id_sucursal`) USING BTREE,
  KEY `fk_serie_factura_idx` (`id_serie`) USING BTREE,
  KEY `fk_cliente_factura_idx` (`id_cliente`) USING BTREE,
  KEY `fk_status_cancelacion_idx` (`id_status_cancelacion`) USING BTREE,
  KEY `fk_razon_cancelacion_idx` (`id_razon_cancelacion`) USING BTREE,
  KEY `fk_factura_grupo_empresa_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_factura_moneda_idx` (`id_moneda`) USING BTREE,
  KEY `fk_factura_grupo_fit_factura_idx` (`id_grupo_fit`),
  CONSTRAINT `fk_cliente_factura` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_dir` FOREIGN KEY (`id_direccion`) REFERENCES `ct_glob_tc_direccion` (`id_direccion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_grupo_fit_factura` FOREIGN KEY (`id_grupo_fit`) REFERENCES `ic_fac_tc_grupo_fit` (`id_grupo_fit`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_moneda` FOREIGN KEY (`id_moneda`) REFERENCES `ct_glob_tc_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_razon_cancelacion` FOREIGN KEY (`id_razon_cancelacion`) REFERENCES `ic_fac_tr_razon_cancelacion_factura` (`id_razon_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_serie_factura` FOREIGN KEY (`id_serie`) REFERENCES `ic_cat_tr_serie` (`id_serie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_status_cancelacion` FOREIGN KEY (`id_status_cancelacion`) REFERENCES `ic_fac_tc_factura_estatus_cancelacion` (`id_estatus_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sucursal_factura` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7244 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
