CREATE TABLE `st_adm_tr_usuario_sesion` (
  `id_usuario_sesion` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `session_id` varchar(60) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `datos_session` json DEFAULT NULL,
  PRIMARY KEY (`id_usuario_sesion`),
  KEY `fk_usuario_sesion_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_usuario_sesion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4105 DEFAULT CHARSET=latin1;
