CREATE TABLE `st_adm_tr_usuario_acceso` (
  `id_usuario_acceso` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `acceso_por` varchar(100) DEFAULT NULL,
  `tipo` enum('IP','MAC') DEFAULT 'IP',
  `estatus_acceso` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario_mod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_usuario_acceso`),
  KEY `fk_usuario_acceso_usuario_idx` (`id_usuario`),
  KEY `st_adm_tr_usuario_acceso_idx` (`id_empresa`),
  CONSTRAINT `fk_usuario_acceso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `st_adm_tr_usuario_acceso` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;
