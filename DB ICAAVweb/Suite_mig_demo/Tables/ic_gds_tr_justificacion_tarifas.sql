CREATE TABLE `ic_gds_tr_justificacion_tarifas` (
  `id_gds_justificacion_tarifas` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_justificacion` char(10) DEFAULT NULL,
  `desc_corta` varchar(50) DEFAULT NULL,
  `desc_larga` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_gds_justificacion_tarifas`),
  KEY `fk_justificacion_tarifas_grup_empre_idx` (`id_grupo_empresa`),
  CONSTRAINT `fk_justificacion_tarifas_grup_empre` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
