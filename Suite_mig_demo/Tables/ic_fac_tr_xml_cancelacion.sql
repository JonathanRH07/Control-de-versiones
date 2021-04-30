CREATE TABLE `ic_fac_tr_xml_cancelacion` (
  `id_factura` int(11) NOT NULL,
  `xml_solicitud` text,
  `xml_reponse_solicitud` text,
  `xml_consulta` text,
  `xml_reponse_consulta` text,
  KEY `fk_xml_can_factura_idx` (`id_factura`),
  CONSTRAINT `fk_xml_can_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
