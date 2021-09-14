CREATE TABLE `ic_gds_tr_vuelos_citypair` (
  `id_gds_vuelos_citypair` int(11) NOT NULL AUTO_INCREMENT,
  `id_gds_vuelos` int(11) DEFAULT NULL,
  `id_moneda` int(11) DEFAULT NULL,
  `clave_linea_aerea` char(2) DEFAULT NULL,
  `cve_aeropuerto_origen` char(4) DEFAULT NULL,
  `cve_aeropuerto_destino` char(4) DEFAULT NULL,
  `numero_segmento` smallint(2) DEFAULT NULL,
  `clase_reservada` char(1) DEFAULT NULL,
  `fare_basis` varchar(10) DEFAULT NULL,
  `tarifa_citypair` decimal(15,2) DEFAULT NULL,
  `millas_citypair` int(11) DEFAULT NULL,
  `nombre_ciudad_origen` varchar(30) DEFAULT NULL,
  `nombre_ciudad_destino` varchar(30) DEFAULT NULL,
  `ticket_designator` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_gds_vuelos_citypair`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
