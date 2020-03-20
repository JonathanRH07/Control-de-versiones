CREATE TABLE `st_adm_tc_notificaciones_trans` (
  `id_notificaciones_trans` int(11) NOT NULL AUTO_INCREMENT,
  `id_notificaciones` int(11) NOT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion_email` varchar(250) DEFAULT NULL,
  `descripcion_alerta` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id_notificaciones_trans`),
  KEY `fk cat_notificaciones_trans_id_notificaciones` (`id_notificaciones`),
  KEY `fk_cat_notificaciones_trans_id_idioma` (`id_idioma`),
  CONSTRAINT `fk_cat_notificaciones_trans_id_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `st_adm_tc_idioma` (`id_idioma`) ON UPDATE NO ACTION,
  CONSTRAINT `fk_cat_notificaciones_trans_id_notificaciones` FOREIGN KEY (`id_notificaciones`) REFERENCES `st_adm_tc_notificaciones` (`id_notificaciones`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
