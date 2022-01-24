CREATE TABLE `st_adm_tr_usuario_recuperacion` (
  `id_usuario_recuperacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `correo` char(50) NOT NULL,
  `token` varchar(255) NOT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_limite` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario_recuperacion`),
  KEY `fk_usuario_usuario_recuperacion_idx` (`id_usuario`),
  CONSTRAINT `fk_usuario_usuario_recuperacion` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;
