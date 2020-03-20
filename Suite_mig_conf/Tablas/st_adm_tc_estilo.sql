CREATE TABLE `st_adm_tc_estilo` (
  `id_estilo` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_estilo`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
