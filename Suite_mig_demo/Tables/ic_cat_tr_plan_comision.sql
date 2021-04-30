CREATE TABLE `ic_cat_tr_plan_comision` (
  `id_plan_comision` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_plan_comision` char(15) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `cuota_minima` char(1) DEFAULT NULL,
  `cuota_minima_monto` decimal(13,2) DEFAULT NULL,
  `comisiones_por` char(1) DEFAULT NULL,
  `fecha_ini` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_plan_comision`),
  KEY `fk_plan_comision_usuario_idx` (`id_usuario`),
  KEY `fk_plan_comision_grupo_empre_idx` (`id_grupo_empresa`),
  KEY `idx_cve_plan_comision` (`cve_plan_comision`,`descripcion`),
  CONSTRAINT `fk_plan_comision_grupo_empre` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_plan_comision_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;