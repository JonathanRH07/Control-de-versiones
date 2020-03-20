CREATE TABLE `st_adm_tc_zona_horaria` (
  `id_zona_horaria` int(11) NOT NULL,
  `UTC` varchar(20) DEFAULT NULL,
  `zona_horaria` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_zona_horaria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
