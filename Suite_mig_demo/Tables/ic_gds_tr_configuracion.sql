CREATE TABLE `ic_gds_tr_configuracion` (
  `id_gds_configuracion` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_gds` varchar(2) DEFAULT NULL,
  `ventit_de` varchar(15) DEFAULT NULL,
  `venaux_de` varchar(15) DEFAULT NULL,
  `imprimir_fac` char(1) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `tpo_serie` char(2) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_moneda_nac` int(11) DEFAULT NULL,
  `id_moneda_int` int(11) DEFAULT NULL,
  `id_tipser_bolint` int(11) DEFAULT NULL,
  `id_tipser_bolnac` int(11) DEFAULT NULL,
  `lencli` int(11) DEFAULT NULL,
  `finpnr` int(11) DEFAULT NULL,
  `separa` char(1) DEFAULT NULL,
  `id_tipo_proveedor` int(11) DEFAULT NULL,
  `id_serie_pseudo_inexistente` int(11) DEFAULT NULL,
  `id_tipser_lowcost` int(11) DEFAULT NULL,
  `dec_lowcost` char(1) DEFAULT 'N',
  `tipserv_fac_bi` varchar(10) DEFAULT NULL,
  `tipserv_fac_bn` varchar(10) DEFAULT NULL,
  `id_tipser_lowcost_int` int(11) DEFAULT NULL,
  `genera_layout` char(1) DEFAULT NULL,
  `envio_error_mail_vendedor` char(1) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT NULL,
  `id_moneda_lowcost_int` int(11) DEFAULT NULL,
  `id_moneda_lowcost_nac` int(11) DEFAULT NULL,
  `boleto_lowcost_inicial` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_gds_configuracion`),
  KEY `fk_configuracion_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_configuracion_serie_idx` (`id_serie`),
  KEY `fk_configuracion_sucursal_idx` (`id_sucursal`),
  KEY `fk_configuracion_tipo_proveedor_idx` (`id_tipo_proveedor`),
  KEY `fk_configuracion_usuario_idx` (`id_usuario`),
  KEY `fk_servicio_int_idx` (`id_tipser_bolint`),
  KEY `fk_servicio_nac_idx` (`id_tipser_bolnac`),
  KEY `fk_servicio_lowcost_nac_idx` (`id_tipser_lowcost`),
  KEY `fk_servicio_lowcost_int_idx` (`id_tipser_lowcost_int`),
  KEY `fk_id_moneda_nac_idx` (`id_moneda_nac`),
  KEY `fk_id_moneda_int_idx` (`id_moneda_int`),
  KEY `fk_id_moneda_lowcost_nac_idx` (`id_moneda_lowcost_nac`),
  KEY `fk_id_moneda_lowcost_int_idx` (`id_moneda_lowcost_int`),
  CONSTRAINT `fk_configuracion_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_serie` FOREIGN KEY (`id_serie`) REFERENCES `ic_cat_tr_serie` (`id_serie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_tipo_proveedor` FOREIGN KEY (`id_tipo_proveedor`) REFERENCES `ic_cat_tc_tipo_proveedor` (`id_tipo_proveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_moneda_int` FOREIGN KEY (`id_moneda_int`) REFERENCES `suite_mig_conf`.`st_adm_tr_config_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_moneda_lowcost_int` FOREIGN KEY (`id_moneda_lowcost_int`) REFERENCES `suite_mig_conf`.`st_adm_tr_config_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_moneda_lowcost_nac` FOREIGN KEY (`id_moneda_lowcost_nac`) REFERENCES `suite_mig_conf`.`st_adm_tr_config_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_moneda_nac` FOREIGN KEY (`id_moneda_nac`) REFERENCES `suite_mig_conf`.`st_adm_tr_config_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicio_int` FOREIGN KEY (`id_tipser_bolint`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicio_lowcost_int` FOREIGN KEY (`id_tipser_lowcost_int`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicio_lowcost_nac` FOREIGN KEY (`id_tipser_lowcost`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicio_nac` FOREIGN KEY (`id_tipser_bolnac`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
