CREATE TABLE `st_adm_tr_mensajes_usuarios` (
  `id_mensaje_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `id_mensaje` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `leido` char(1) NOT NULL DEFAULT 'N',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mensaje_usuario`),
  KEY `idx_mensajes_usuarios_id_usuario` (`id_usuario`),
  KEY `idx_mensajes_usuarios_id_mensaje` (`id_mensaje`),
  CONSTRAINT `fk_mensajes_usuarios_id_mensaje` FOREIGN KEY (`id_mensaje`) REFERENCES `st_adm_tr_mensajes` (`id_mensaje`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_mensajes_usuarios_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
