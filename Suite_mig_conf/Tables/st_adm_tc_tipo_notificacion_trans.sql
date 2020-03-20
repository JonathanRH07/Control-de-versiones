CREATE TABLE `st_adm_tc_tipo_notificacion_trans` (
  `id_tipo_notificacion_trans` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_notificacion` int(11) NOT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_notificacion_trans`),
  KEY `fk_tipo_notificacion_trans_id_tipo_notificacion` (`id_tipo_notificacion`),
  KEY `fk_tipo_notificacion_trans_id_idioma` (`id_idioma`),
  CONSTRAINT `fk_tipo_notificacion_trans_id_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `st_adm_tc_idioma` (`id_idioma`) ON UPDATE CASCADE,
  CONSTRAINT `fk_tipo_notificacion_trans_id_tipo_notificacion` FOREIGN KEY (`id_tipo_notificacion`) REFERENCES `st_adm_tc_tipo_notificacion` (`id_tipo_notificacion`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
