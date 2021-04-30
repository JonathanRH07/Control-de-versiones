CREATE TABLE `ic_glob_tr_forma_pago_detalle` (
  `id_usuario` int(11) NOT NULL,
  `id_forma_pago_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_forma_pago` int(11) NOT NULL,
  `id_cuenta_contable` int(11) DEFAULT NULL,
  `id_moneda` int(11) NOT NULL,
  `estatus_forma_pago_detalle` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_forma_pago_det` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_forma_pago_detalle`),
  KEY `fk_ic_glob_tr_forma_pago_detalle_ic_glob_tc_forma_pago_idx` (`id_forma_pago`),
  KEY `fk_ic_glob_tr_forma_pago_detalle_ct_glob_tc_moneda1_idx` (`id_moneda`),
  KEY `fk_pago_detalle_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_forma_pago_detalle` FOREIGN KEY (`id_forma_pago`) REFERENCES `ic_glob_tr_forma_pago` (`id_forma_pago`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pago_detalle_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8;
