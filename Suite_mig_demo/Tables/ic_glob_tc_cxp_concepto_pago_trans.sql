CREATE TABLE `ic_glob_tc_cxp_concepto_pago_trans` (
  `id_concepto_pago` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(75) DEFAULT NULL,
  KEY `fk_id_idioma_idx` (`id_idioma`),
  KEY `fk_id_concepto_pago_idx` (`id_concepto_pago`),
  CONSTRAINT `fk_id_concepto_pago_trans` FOREIGN KEY (`id_concepto_pago`) REFERENCES `ic_glob_tc_cxp_concepto_pago` (`id_concepto_pago`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_idioma_concepto_pago` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
