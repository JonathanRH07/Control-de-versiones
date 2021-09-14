CREATE TABLE `ic_gds_tr_forma_pago_emp` (
  `id_gds_forma_pago_emp` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_gds_forma_pago` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_gds_forma_pago_emp`),
  KEY `fk_forma_pago_emp_grupo_empr_idx` (`id_grupo_empresa`),
  KEY `fk_forma_pago_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_forma_pago_emp_grup_empr` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_forma_pago_empr_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
