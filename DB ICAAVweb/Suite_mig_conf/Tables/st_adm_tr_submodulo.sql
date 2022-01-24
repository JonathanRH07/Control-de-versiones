CREATE TABLE `st_adm_tr_submodulo` (
  `id_submodulo` int(11) NOT NULL AUTO_INCREMENT,
  `id_modulo` int(11) NOT NULL,
  `clave_submodulo` char(20) NOT NULL,
  `nombre_submodulo` varchar(60) DEFAULT NULL,
  `traduccion` varchar(255) DEFAULT NULL,
  `id_default_api_controller` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_submodulo`),
  KEY `idx_id_modulo` (`id_modulo`) USING BTREE,
  KEY `fk_id_default_controller_idx` (`id_default_api_controller`),
  CONSTRAINT `fk_submodulo_modulo` FOREIGN KEY (`id_modulo`) REFERENCES `st_adm_tc_modulo` (`id_modulo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
