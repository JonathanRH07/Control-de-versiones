CREATE TABLE `ic_fac_tr_folios_historico_uso_mensual` (
  `id_folios_historico_uso` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `no_folios_facturas` int(11) NOT NULL DEFAULT '0',
  `no_folios_nc` int(11) NOT NULL DEFAULT '0',
  `no_folios_documentos` int(11) NOT NULL DEFAULT '0',
  `no_folios_documentos_credito` int(11) NOT NULL DEFAULT '0',
  `no_folios_comprobantes_cc` int(11) NOT NULL DEFAULT '0',
  `no_folios_comprobantes_sc` int(11) NOT NULL DEFAULT '0',
  `fecha` date NOT NULL,
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_folios_historico_uso`),
  KEY `fk_grupo_empresa_his_uso_men_idx` (`id_grupo_empresa`),
  CONSTRAINT `fk_grupo_empresa_his_uso_men` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;
