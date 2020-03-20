CREATE TABLE `st_adm_tc_notificaciones` (
  `id_notificaciones` int(11) NOT NULL AUTO_INCREMENT,
  `clave` varchar(45) DEFAULT NULL,
  `id_tipo_notificacion` int(11) NOT NULL,
  PRIMARY KEY (`id_notificaciones`),
  KEY `fk_cat_notificaciones_id_tipo_notificacion_idx` (`id_tipo_notificacion`),
  CONSTRAINT `fk_cat_notificaciones_id_tipo_notificacion` FOREIGN KEY (`id_tipo_notificacion`) REFERENCES `st_adm_tc_tipo_notificacion` (`id_tipo_notificacion`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
