CREATE TABLE `ic_cat_tc_formato` (
  `id_formato` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `tipo_formato` enum('ANALITICO','CONCENTRADO') DEFAULT NULL,
  `codigo` longtext,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_formato`),
  KEY `fk_empresa_formato_idx` (`id_grupo_empresa`),
  KEY `idx_tipo_formato` (`tipo_formato`) USING BTREE,
  CONSTRAINT `fk_empresa_formato` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
