CREATE TABLE `ic_fac_tr_prove_cta_bancaria` (
  `id_prove_cta_bancaria` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_banco` int(11) DEFAULT NULL,
  `numero_cuenta` varchar(20) DEFAULT NULL,
  `cuenta_clabe` varchar(20) DEFAULT NULL,
  `sucursal` varchar(30) DEFAULT NULL,
  `plaza` char(5) DEFAULT NULL,
  `forma_pago` char(1) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_prove_cta_bancaria`),
  KEY `fk_proveedor_bancaria_idx` (`id_proveedor`),
  KEY `fk_proveedor_banco_idx` (`id_banco`),
  KEY `fk_cta_bancaria_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_cta_bancaria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedor_bancaria` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_proveedor_banco` FOREIGN KEY (`id_banco`) REFERENCES `sat_bancos` (`id_sat_bancos`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
