CREATE TABLE `ic_fac_tr_pagos_detalle` (
  `id_pago_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_pago` int(11) DEFAULT NULL,
  `id_cxc` int(11) DEFAULT NULL,
  `importe_moneda_base` decimal(13,2) DEFAULT NULL,
  `importe_pago` decimal(13,2) DEFAULT NULL,
  `saldo_act` decimal(13,2) DEFAULT NULL,
  `saldo_ant` decimal(13,2) DEFAULT NULL,
  `no_parcialidad` int(11) DEFAULT NULL,
  `importe_usd` decimal(13,4) DEFAULT NULL,
  `importe_eur` decimal(13,4) DEFAULT NULL,
  `tipo_cambio_dr` decimal(13,4) DEFAULT NULL,
  PRIMARY KEY (`id_pago_detalle`),
  KEY `fk_detalle_pago_idx` (`id_pago`),
  CONSTRAINT `fk_detalle_pago` FOREIGN KEY (`id_pago`) REFERENCES `ic_fac_tr_pagos` (`id_pago`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5601 DEFAULT CHARSET=latin1;
