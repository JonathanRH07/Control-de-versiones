CREATE TABLE `ic_gds_tr_arrendadoras` (
  `id_gds_arrendadoras` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_arrendadora` char(2) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id_gds_arrendadoras`),
  KEY `fk_arrendadora_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `idx_cve_arrendadora` (`cve_arrendadora`) USING BTREE,
  CONSTRAINT `fk_arrendadora_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;
