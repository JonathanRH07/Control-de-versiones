CREATE TABLE `ic_cat_tr_impuesto_provee_unidad` (
  `id_grupo_empresa` int(11) NOT NULL,
  `id_impuesto` int(11) NOT NULL,
  `c_ClaveProdServ` char(10) DEFAULT NULL,
  `id_unidad` int(11) NOT NULL,
  KEY `fk_empresa_impuesto_provee_unidad_idx` (`id_grupo_empresa`),
  KEY `fk_impuesto_impuesto_provee_unidad_idx` (`id_impuesto`),
  KEY `fk_impuesto_unidad_provee_unidad_idx` (`id_unidad`),
  KEY `idx_c_ClaveProdServ` (`c_ClaveProdServ`),
  CONSTRAINT `fk_empresa_impuesto_provee_unidad` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_impuesto_impuesto_provee_unidad` FOREIGN KEY (`id_impuesto`) REFERENCES `ic_cat_tr_impuesto` (`id_impuesto`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
