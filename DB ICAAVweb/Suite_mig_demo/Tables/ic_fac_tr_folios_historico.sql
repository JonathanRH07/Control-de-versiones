
CREATE TABLE `ic_fac_tr_folios_historico` (
  `id_folios` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `no_folios_comprados` int(11) NOT NULL DEFAULT '0',
  `no_folios_disponibles` int(11) NOT NULL DEFAULT '0',
  `no_folios_usados` int(11) NOT NULL DEFAULT '0',
  `no_folios_acumulados` int(11) NOT NULL DEFAULT '0',
  `metodo_pago` char(1) NOT NULL DEFAULT '0',
  `no_folios_facturas` int(11) NOT NULL DEFAULT '0',
  `no_folios_nc` int(11) NOT NULL DEFAULT '0',
  `no_folios_documentos` int(11) NOT NULL DEFAULT '0',
  `no_folios_documentos_credito` int(11) NOT NULL DEFAULT '0',
  `no_folios_comprobantes_cc` int(11) NOT NULL DEFAULT '0',
  `no_folios_comprobantes_sc` int(11) NOT NULL DEFAULT '0',
  `fecha` date NOT NULL DEFAULT '0000-00-00',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_folios`),
  KEY `fk_grupo_empresa_folios_idx` (`id_grupo_empresa`),
  CONSTRAINT `fk_grupo_empresa_folios` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=latin1;
