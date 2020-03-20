CREATE TABLE `st_adm_tr_estilo_empresa` (
  `id_estilo_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) DEFAULT NULL,
  `id_estilo` int(11) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  PRIMARY KEY (`id_estilo_empresa`),
  KEY `idx_id_empresa` (`id_empresa`) USING BTREE,
  KEY `idx_id_estilo` (`id_estilo`) USING BTREE,
  CONSTRAINT `fk_empresa_estilo` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=latin1;
