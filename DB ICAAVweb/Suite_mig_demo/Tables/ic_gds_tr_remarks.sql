CREATE TABLE `ic_gds_tr_remarks` (
  `id_remarks` int(11) NOT NULL AUTO_INCREMENT,
  `cve_gds` char(2) DEFAULT NULL,
  `remark` varchar(10) DEFAULT NULL,
  `descripcion` varchar(40) DEFAULT NULL,
  `entrada` varchar(30) DEFAULT NULL,
  `valor_remark` varchar(30) DEFAULT NULL,
  `obligatorio` char(1) DEFAULT 'N',
  `id_stat` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `item` int(11) DEFAULT NULL,
  `separador` char(1) DEFAULT NULL,
  `permite_obligatorio` char(1) DEFAULT 'N',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_remarks`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8;
