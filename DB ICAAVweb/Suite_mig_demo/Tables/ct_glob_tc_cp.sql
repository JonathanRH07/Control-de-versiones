CREATE TABLE `ct_glob_tc_cp` (
  `id_cp` int(11) NOT NULL,
  `codigo` char(10) DEFAULT NULL,
  `asentamiento` varchar(100) DEFAULT NULL,
  `tipo_asentamiento` varchar(100) DEFAULT NULL,
  `municipio` varchar(100) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `zona` varchar(100) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cp`),
  KEY `idx_codigo` (`codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
