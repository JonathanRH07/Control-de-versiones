CREATE TABLE `ic_cat_tr_impuesto` (
  `id_impuesto` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pais` char(3) DEFAULT NULL,
  `cve_impuesto` char(10) NOT NULL,
  `desc_impuesto` char(40) NOT NULL,
  `valor_impuesto` decimal(16,6) DEFAULT NULL,
  `cve_impuesto_cat` char(10) NOT NULL,
  `tipo_valor_impuesto` enum('T','C','E') DEFAULT NULL,
  `por_pagar_impuesto` enum('SI','NO') DEFAULT 'NO',
  `tipo` enum('F','L') DEFAULT NULL,
  `clase` enum('T','R') DEFAULT NULL,
  `estatus_impuesto` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_impuesto` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_impuesto`),
  KEY `fk_impuesto_usuario_idx` (`id_usuario`),
  KEY `idx_cve` (`cve_pais`,`cve_impuesto`,`cve_impuesto_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
