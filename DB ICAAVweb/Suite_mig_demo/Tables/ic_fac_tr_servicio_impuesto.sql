CREATE TABLE `ic_fac_tr_servicio_impuesto` (
  `id_servicio_impuesto` int(11) NOT NULL AUTO_INCREMENT,
  `id_servicio` int(11) NOT NULL,
  `id_impuesto` int(11) NOT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_servicio_impuesto`),
  KEY `fk_servicio_id_idx` (`id_servicio`),
  KEY `fk_impuesto_id_idx` (`id_impuesto`),
  KEY `fk_servicio_impuesto_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_servicio_id` FOREIGN KEY (`id_servicio`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tr_servicio_impuesto_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8;
