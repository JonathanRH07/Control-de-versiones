CREATE TABLE `st_adm_tr_config_emails` (
  `id_config_emails` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `email_facturacion_usuario` varchar(100) DEFAULT NULL,
  `email_facturacion_host` varchar(100) DEFAULT NULL,
  `email_facturacion_puerto` varchar(10) DEFAULT NULL,
  `email_facturacion_password` varchar(100) DEFAULT NULL,
  `email_cobranza_usuario` varchar(100) DEFAULT NULL,
  `email_cobranza_host` varchar(100) DEFAULT NULL,
  `email_cobranza_puerto` varchar(10) DEFAULT NULL,
  `email_cobranza_password` varchar(100) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_config_emails`),
  KEY `fk_grupo_empresa_config_emails_idx` (`id_grupo_empresa`),
  KEY `fk_usuario_config_emails_idx` (`id_usuario`),
  CONSTRAINT `fk_grupo_empresa_config_emails` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
