
CREATE TABLE `ic_fac_tr_prove_cta_ingreso` (
  `id_prove_cta_ingreso` int(11) NOT NULL AUTO_INCREMENT,
  `id_prove_servicio` int(11) DEFAULT NULL,
  `id_num_cta_conta` int(11) DEFAULT NULL,
  `id_num_cta_conta_resul` int(11) DEFAULT NULL,
  `id_num_cta_conta_costos` int(11) DEFAULT NULL,
  `id_num_cta_conta_pasivo` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_prove_cta_ingreso`),
  KEY `fk_prove_cta_idx` (`id_prove_servicio`),
  KEY `fk_cta_ingreso_usuario_idx` (`id_usuario`),
  KEY `fk_prove_cta_eing_sucursal_idx` (`id_sucursal`),
  CONSTRAINT `fk_cta_ingreso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_prove_cta` FOREIGN KEY (`id_prove_servicio`) REFERENCES `ic_fac_tr_prove_servicio` (`id_prove_servicio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prove_cta_eing_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
