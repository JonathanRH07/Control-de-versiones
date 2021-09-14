CREATE TABLE `ic_rep_tr_acumulado_pagos_detalle` (
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `id_cxc` int(11) DEFAULT NULL,
  `importe` decimal(15,2) DEFAULT NULL,
  `importe_usd` decimal(15,2) DEFAULT NULL,
  `importe_eur` decimal(15,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `fecha_act` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
