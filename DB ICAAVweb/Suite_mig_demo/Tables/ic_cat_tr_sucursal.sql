CREATE TABLE `ic_cat_tr_sucursal` (
  `id_sucursal` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `id_direccion` int(11) NOT NULL,
  `id_zona_horaria` int(11) DEFAULT NULL,
  `tipo` enum('CORPORATIVO','SUCURSAL','INPLANT') DEFAULT NULL,
  `cve_sucursal` varchar(30) DEFAULT NULL,
  `nombre` varchar(90) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  `iva_local` double DEFAULT NULL,
  `iata_nacional` varchar(20) DEFAULT NULL,
  `iata_internacional` varchar(20) DEFAULT NULL,
  `matriz` char(1) DEFAULT NULL,
  `pertenece` int(11) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_sucursal`),
  KEY `ic_cat_tr_sucursal_ibfk_1_idx` (`id_direccion`) USING BTREE,
  KEY `fk_sucursal_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_sucursal_zona_horaria_idx` (`id_zona_horaria`) USING BTREE,
  KEY `fk_sucursal_grupo_empresa_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_cve_sucursal` (`cve_sucursal`) USING BTREE,
  CONSTRAINT `fk_sucursal_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sucursal_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sucursal_zona_horaria` FOREIGN KEY (`id_zona_horaria`) REFERENCES `ct_glob_zona_horaria` (`id_zona_horaria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ic_cat_tr_sucursal_ibfk_1` FOREIGN KEY (`id_direccion`) REFERENCES `ct_glob_tc_direccion` (`id_direccion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;