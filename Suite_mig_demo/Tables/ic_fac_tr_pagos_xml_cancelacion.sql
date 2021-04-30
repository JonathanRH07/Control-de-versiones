CREATE TABLE `ic_fac_tr_pagos_xml_cancelacion` (
  `id_pago` int(11) NOT NULL,
  `xml_solicitud` blob,
  `xml_response_solicitud` blob,
  `solicitud_error` char(1) DEFAULT 'N',
  `acuse` blob,
  `xml_consulta` blob,
  `xml_response_consulta` blob,
  `fecha_consulta` datetime DEFAULT NULL,
  `consulta_error` char(1) DEFAULT 'N',
  KEY `fk_xml_can_pago_idx` (`id_pago`),
  CONSTRAINT `fk_xml_can_pago` FOREIGN KEY (`id_pago`) REFERENCES `ic_fac_tr_pagos` (`id_pago`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
