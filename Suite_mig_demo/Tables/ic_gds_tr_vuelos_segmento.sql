CREATE TABLE `ic_gds_tr_vuelos_segmento` (
  `id_gds_vuelos_segmento` int(11) NOT NULL AUTO_INCREMENT,
  `id_gds_vuelos` int(11) DEFAULT NULL,
  `id_acred` int(11) DEFAULT NULL,
  `clave_linea_area` char(2) DEFAULT NULL,
  `boleto` varchar(15) DEFAULT NULL,
  `numero_vuelo` bigint(11) DEFAULT NULL,
  `cve_airport_origen` char(4) DEFAULT NULL,
  `cve_airport_destino` char(4) DEFAULT NULL,
  `nombre_ciudad_origen` varchar(30) DEFAULT NULL,
  `nombre_ciudad_destino` varchar(30) DEFAULT NULL,
  `tarifa_regular` decimal(15,2) DEFAULT NULL,
  `tarifa_ofrecida` decimal(15,2) DEFAULT NULL,
  `codigo_razon` varchar(10) DEFAULT NULL,
  `cve_origen` char(4) DEFAULT NULL,
  `cve_destino` varchar(4) DEFAULT NULL,
  `cve_clase_reserva` char(1) DEFAULT NULL,
  `cve_clase_equiva` char(1) DEFAULT NULL,
  `intdom` char(1) DEFAULT NULL,
  `consecutivo` int(11) DEFAULT NULL,
  `fecha_salida` date DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `hora_llegada` time DEFAULT NULL,
  `servicio_comida` char(3) DEFAULT NULL,
  `equipo` char(3) DEFAULT NULL,
  `millas` bigint(11) DEFAULT NULL,
  `millas_pax_frecuente` bigint(11) DEFAULT NULL,
  `no_escalas` char(1) DEFAULT NULL,
  `cambio_fecha_llegada` char(1) DEFAULT NULL,
  `tarifa_segmento` decimal(18,6) DEFAULT NULL,
  `numero_segmento` bigint(20) DEFAULT NULL,
  `conexion` char(1) DEFAULT NULL,
  `cargo_combustible` decimal(15,2) DEFAULT NULL,
  `cargo_seguridad` decimal(15,2) DEFAULT NULL,
  `terminal_salida` varchar(26) DEFAULT NULL,
  `puerta_salida` char(4) DEFAULT NULL,
  `terminal_llegada` varchar(26) DEFAULT NULL,
  `puerta_llegada` char(4) DEFAULT NULL,
  `asiento` char(4) DEFAULT NULL,
  `duracion_vuelo` char(8) DEFAULT NULL,
  `pnr_la` char(8) DEFAULT NULL,
  `year` char(5) DEFAULT NULL,
  `fare_basis` varchar(10) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_gds_vuelos_segmento`),
  KEY `fk_vuelo_segmento_idx` (`id_gds_vuelos`),
  KEY `fk_vuelos_segmento_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_vuelo_segmento` FOREIGN KEY (`id_gds_vuelos`) REFERENCES `ic_gds_tr_vuelos` (`id_gds_vuelos`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_vuelos_segmento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8467 DEFAULT CHARSET=utf8;