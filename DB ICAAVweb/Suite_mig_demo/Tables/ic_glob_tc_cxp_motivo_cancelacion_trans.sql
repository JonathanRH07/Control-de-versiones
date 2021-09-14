CREATE TABLE `ic_glob_tc_cxp_motivo_cancelacion_trans` (
  `id_motivo_cancelacion` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(75) DEFAULT NULL,
  KEY `fk_id_idioma_idx` (`id_idioma`),
  KEY `fk_id_motivo_cancelacion_idx` (`id_motivo_cancelacion`),
  CONSTRAINT `fk_id_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_motivo_cancelacion` FOREIGN KEY (`id_motivo_cancelacion`) REFERENCES `ic_glob_tc_cxp_motivo_cancelacion` (`id_motivo_cancelacion`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
