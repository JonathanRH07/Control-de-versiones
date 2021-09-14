CREATE TABLE `ic_glob_tr_cxp_adjuntos` (
  `id_cxp_adjunto` int(11) NOT NULL AUTO_INCREMENT,
  `id_cxp` int(11) DEFAULT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_cxp_adjunto`),
  KEY `id_cxp_idx` (`id_cxp`),
  CONSTRAINT `id_cxp` FOREIGN KEY (`id_cxp`) REFERENCES `ic_glob_tr_cxp` (`id_cxp`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=latin1;
