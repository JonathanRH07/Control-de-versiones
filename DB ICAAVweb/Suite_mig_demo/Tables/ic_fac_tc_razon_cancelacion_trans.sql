CREATE TABLE `ic_fac_tc_razon_cancelacion_trans` (
  `id_razon_cancelacion` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  KEY `fk_idioma_razon_cancelacion_idx` (`id_idioma`),
  KEY `fk_razon_cancelacion_trans` (`id_razon_cancelacion`),
  CONSTRAINT `fk_idioma_razon_cancelacion` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_razon_cancelacion_trans` FOREIGN KEY (`id_razon_cancelacion`) REFERENCES `ic_fac_tc_razon_cancelacion` (`id_razon_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
