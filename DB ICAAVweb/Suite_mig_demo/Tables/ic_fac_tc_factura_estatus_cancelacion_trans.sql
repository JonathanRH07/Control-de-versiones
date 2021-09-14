CREATE TABLE `ic_fac_tc_factura_estatus_cancelacion_trans` (
  `id_estatus_cancelacion` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  KEY `fk_idioma_cancelacion_fac_idx` (`id_idioma`),
  KEY `fk_estatus_cancelacion_fac_idx` (`id_estatus_cancelacion`),
  CONSTRAINT `fk_estatus_cancelacion_fac` FOREIGN KEY (`id_estatus_cancelacion`) REFERENCES `ic_fac_tc_factura_estatus_cancelacion` (`id_estatus_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_idioma_cancelacion_fac` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
