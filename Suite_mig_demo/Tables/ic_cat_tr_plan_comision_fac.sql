CREATE TABLE `ic_cat_tr_plan_comision_fac` (
  `id_plan_comision_fac` int(11) NOT NULL AUTO_INCREMENT,
  `id_plan_comision` int(11) DEFAULT NULL,
  `id_tipo_proveedor` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_serivicio` int(11) DEFAULT NULL,
  `prioridad` int(11) DEFAULT NULL,
  `tipo` char(1) DEFAULT NULL,
  `porc_monto` char(1) DEFAULT NULL,
  `valor` decimal(13,2) DEFAULT NULL,
  `fecha_ini` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_plan_comision_fac`),
  KEY `fk_comision_fac_idx` (`id_plan_comision`),
  KEY `fk_comision_fac_tipo_idx` (`id_tipo_proveedor`),
  KEY `fk_comision_fac_prove_idx` (`id_proveedor`),
  KEY `fk_comision_fac_serv_idx` (`id_serivicio`),
  KEY `fk_comision_fac_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_comision_fac` FOREIGN KEY (`id_plan_comision`) REFERENCES `ic_cat_tr_plan_comision` (`id_plan_comision`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comision_fac_prove` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comision_fac_serv` FOREIGN KEY (`id_serivicio`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON UPDATE CASCADE,
  CONSTRAINT `fk_comision_fac_tipo` FOREIGN KEY (`id_tipo_proveedor`) REFERENCES `ic_cat_tc_tipo_proveedor` (`id_tipo_proveedor`) ON UPDATE CASCADE,
  CONSTRAINT `fk_comision_fac_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8;
