CREATE TABLE `ic_fac_tr_prove_imp_serv` (
  `id_prov_imp_serv` int(11) NOT NULL AUTO_INCREMENT,
  `id_prove_servicio` int(11) DEFAULT NULL,
  `id_impuesto` int(11) DEFAULT NULL,
  `tipo_valor_cantidad` char(1) DEFAULT NULL,
  `cantidad` decimal(16,6) DEFAULT NULL,
  `por_pagar` char(2) DEFAULT NULL,
  `base_valor` decimal(16,2) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_prov_imp_serv`),
  KEY `fk_prove_imp_idx` (`id_prove_servicio`),
  KEY `fk_prove_impuesto_idx` (`id_impuesto`),
  KEY `fk_prove_imp_serv_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_prove_imp_serv_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_prove_serv` FOREIGN KEY (`id_prove_servicio`) REFERENCES `ic_fac_tr_prove_servicio` (`id_prove_servicio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=utf8;
