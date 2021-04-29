CREATE TABLE `st_adm_tr_alertas_usuarios` (
  `id_alerta_usuarios` int(11) NOT NULL AUTO_INCREMENT,
  `id_alerta` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `leido` char(1) NOT NULL DEFAULT 'N',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alerta_usuarios`),
  KEY `fk_usuario_receptor_idx` (`id_usuario`),
  KEY `fk_alerta_idx` (`id_alerta`),
  CONSTRAINT `fk_alerta` FOREIGN KEY (`id_alerta`) REFERENCES `st_adm_tr_alertas` (`id_alertas`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11490 DEFAULT CHARSET=latin1;
