CREATE TABLE `ic_fac_tr_factura_cfdi` (
  `id_cfdi` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) DEFAULT NULL,
  `numero_certificado` varchar(20) DEFAULT NULL,
  `cadena_original` text,
  `sello_digital` text,
  `certificado` text,
  `genera_xml` char(1) DEFAULT 'N',
  `factura_xml` longtext,
  `genera_pdf` char(1) DEFAULT 'N',
  `factura_pdf` longblob,
  `fecha_envio_email` datetime DEFAULT NULL,
  `timbre_cfdi` text,
  `version_timbrado` varchar(4) DEFAULT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `fecha_timbrado` datetime DEFAULT NULL,
  `numero_certificado_sat` varchar(20) DEFAULT NULL,
  `sello_sat` text,
  `cadena_timbre` text,
  `cfdi_timbrado` char(1) DEFAULT NULL,
  `confirma_cancelacion_cfdi` text,
  `archivo_addenda` text,
  PRIMARY KEY (`id_cfdi`),
  KEY `fk_cfdi_factura_idx` (`id_factura`),
  CONSTRAINT `fk_cfdi_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5064 DEFAULT CHARSET=utf8;
