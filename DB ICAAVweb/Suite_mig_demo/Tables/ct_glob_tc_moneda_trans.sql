CREATE TABLE `ct_glob_tc_moneda_trans` (
  `id_moneda` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion_moneda` varchar(100) DEFAULT NULL,
  `singular` varchar(45) DEFAULT NULL,
  `plural` varchar(45) DEFAULT NULL,
  KEY `idx_id_moneda` (`id_moneda`) USING BTREE,
  KEY `idx_id_idioma` (`id_idioma`) USING BTREE,
  CONSTRAINT `ct_glob_tc_moneda_trans_ibfk_1` FOREIGN KEY (`id_moneda`) REFERENCES `ct_glob_tc_moneda` (`id_moneda`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ct_glob_tc_moneda_trans_ibfk_2` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
