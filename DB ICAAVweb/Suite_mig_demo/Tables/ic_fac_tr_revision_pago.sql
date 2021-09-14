CREATE TABLE `ic_fac_tr_revision_pago` (
  `id_revision_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `cve_periodicidad` enum('DÍA','FECHA') DEFAULT NULL,
  `cve_tipo_dia` enum('PAGO','REVISIÓN') DEFAULT NULL,
  `dia_semana` enum('LUNES','MARTES','MIÉRCOLES','JUEVES','VIERNES','SÁBADO','DOMINGO') DEFAULT NULL,
  `dia_no` tinyint(4) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_revision_pago`),
  KEY `fk_revision_pago_usuario_idx` (`id_usuario`),
  KEY `fk_revision_pago_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_revision_pago_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tr_revision_pago_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
