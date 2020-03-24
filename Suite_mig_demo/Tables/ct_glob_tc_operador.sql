CREATE TABLE `ct_glob_tc_operador` (
  `id_operador` int(11) NOT NULL AUTO_INCREMENT,
  `clave` char(2) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_operador`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
