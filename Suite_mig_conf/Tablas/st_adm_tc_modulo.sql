CREATE TABLE `st_adm_tc_modulo` (
  `id_modulo` int(11) NOT NULL AUTO_INCREMENT,
  `id_sistema` int(11) NOT NULL,
  `nombre_modulo` varchar(60) DEFAULT NULL,
  `id_tipo_paquete` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_modulo`),
  KEY `idx_id_sistema` (`id_sistema`) USING BTREE,
  KEY `fk_st_adm_tc_modulo_id_tipo_paquete_idx` (`id_tipo_paquete`),
  CONSTRAINT `fk_id_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `st_adm_tr_sistema` (`id_sistema`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_st_adm_tc_modulo_id_tipo_paquete` FOREIGN KEY (`id_tipo_paquete`) REFERENCES `st_adm_tc_tipo_paquete` (`id_tipo_paquete`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
