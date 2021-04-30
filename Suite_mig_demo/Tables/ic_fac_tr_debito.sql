CREATE TABLE `ic_fac_tr_debito` (
  `id_debito` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `importe` decimal(13,2) DEFAULT NULL,
  `concepto` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_debito`),
  KEY `fk_debito_grupo_empresa_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_debito_pago_idx` (`id_pago`) USING BTREE,
  KEY `fk_debito_factura_idx` (`id_factura`) USING BTREE,
  CONSTRAINT `fk_debito_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_debito_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_debito_pago` FOREIGN KEY (`id_pago`) REFERENCES `ic_fac_tr_pagos` (`id_pago`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
