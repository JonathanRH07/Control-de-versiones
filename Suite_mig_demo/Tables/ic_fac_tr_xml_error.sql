CREATE TABLE `ic_fac_tr_xml_error` (
  `id_factura` int(11) NOT NULL,
  `xml_response` text,
  KEY `fk_xml_error_factura_idx` (`id_factura`),
  CONSTRAINT `fk_xml_error_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
