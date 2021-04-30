CREATE TABLE `ic_fac_tr_razon_cancelacion_factura_trans` (
  `id_razon_cancelacion` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  KEY `fk_razon_cancelacion_fac_idx` (`id_razon_cancelacion`),
  KEY `fk_razon_cancelacion_fac_idioma_idx` (`id_idioma`),
  CONSTRAINT `fk_razon_cancelacion_fac` FOREIGN KEY (`id_razon_cancelacion`) REFERENCES `ic_fac_tr_razon_cancelacion_factura` (`id_razon_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_razon_cancelacion_fac_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
