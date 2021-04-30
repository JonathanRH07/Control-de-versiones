CREATE TABLE `ic_glob_tc_cxp_categoria_concepto_trans` (
  `id_categoria_concepto` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(75) DEFAULT NULL,
  KEY `fk_id_idioma_idx` (`id_idioma`),
  KEY `fk_id_categoria_concepto_idx` (`id_categoria_concepto`),
  CONSTRAINT `fk_id_categoria_concepto_trans` FOREIGN KEY (`id_categoria_concepto`) REFERENCES `ic_glob_tc_cxp_categoria_concepto` (`id_categoria_concepto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_idioma_trans` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
