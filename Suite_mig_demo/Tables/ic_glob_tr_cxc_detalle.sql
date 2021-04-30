CREATE TABLE `ic_glob_tr_cxc_detalle` (
  `id_cxc_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_cxc` int(11) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `id_poliza` int(11) DEFAULT NULL,
  `id_moneda` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `concepto` varchar(150) DEFAULT NULL,
  `importe` decimal(15,2) DEFAULT NULL,
  `importe_moneda_base` decimal(15,2) DEFAULT NULL,
  `tipo_cambio` decimal(17,4) DEFAULT NULL,
  `importe_usd` decimal(17,4) DEFAULT NULL,
  `importe_eur` decimal(17,4) DEFAULT NULL,
  `referencia_origen` varchar(50) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cxc_detalle`),
  KEY `fk_cxc_idx` (`id_cxc`),
  KEY `idx:_fecha` (`fecha`),
  CONSTRAINT `fk_detalle_cxc` FOREIGN KEY (`id_cxc`) REFERENCES `ic_glob_tr_cxc` (`id_cxc`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=205458 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
