CREATE TABLE `st_adm_tr_config_cfdi` (
  `id_config_cfdi` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_pac` int(11) DEFAULT '4',
  `series_electronica` char(1) DEFAULT 'N',
  `validar_email_vendedor` char(1) DEFAULT 'N',
  `asignar_impre_series_e` char(1) DEFAULT 'N',
  `enviar_email_cancela` char(1) DEFAULT 'S',
  `email_notificaciones` varchar(255) DEFAULT NULL,
  `metodo_pago` char(5) DEFAULT NULL,
  `uso_cfdi` char(5) DEFAULT NULL,
  `regimen_fiscal_sat` char(5) DEFAULT NULL,
  `enviar_factura` char(1) DEFAULT 'N',
  `validar_campos` char(1) DEFAULT 'N',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `archivo_certificado` varchar(255) DEFAULT NULL,
  `vigencia_desde` timestamp NULL DEFAULT NULL,
  `vigencia_hasta` timestamp NULL DEFAULT NULL,
  `avisame` decimal(15,2) DEFAULT NULL,
  `no_certificado` char(20) DEFAULT NULL,
  `archivo_llave` varchar(255) DEFAULT NULL,
  `contrasena` char(255) DEFAULT NULL,
  `rfc_eventuales` char(20) DEFAULT NULL,
  `rfc_extranjero` char(20) DEFAULT NULL,
  `certificado` text,
  `portal_timbrado_valida` char(1) DEFAULT 'N',
  `portal_timbrado_usuario` varchar(255) DEFAULT NULL,
  `portal_timbrado_pwd` varchar(255) DEFAULT NULL,
  `ambiente_timbrado` enum('Pruebas','Produccion') DEFAULT 'Pruebas' COMMENT 'Desarrollo y Produccion',
  `archivo_pfx` varchar(255) DEFAULT NULL,
  `fecha_sello` timestamp NULL DEFAULT NULL,
  `folio_sat` varchar(22) DEFAULT NULL,
  `usuario_cancelacion` varchar(50) DEFAULT NULL,
  `password_cancelacion` varchar(50) DEFAULT NULL,
  `email_vigencia_proxima` char(1) DEFAULT 'N',
  `email_vigencia_caduca` char(1) DEFAULT 'N',
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_config_cfdi`),
  UNIQUE KEY `id_grupo_empresa_UNIQUE` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_usuario_cfdi_idx` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_grupo_empresa_cfdi` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_cfdi` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
