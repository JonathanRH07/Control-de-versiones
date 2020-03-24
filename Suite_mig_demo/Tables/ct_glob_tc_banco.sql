CREATE TABLE `ct_glob_tc_banco` (
  `id_banco` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_banco` varchar(255) DEFAULT NULL,
  `cve_institucion` varchar(25) DEFAULT NULL,
  `num_institucion` varchar(25) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_banco`),
  KEY `idx_cve_institucion` (`cve_institucion`),
  KEY `idx_estatus` (`estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
