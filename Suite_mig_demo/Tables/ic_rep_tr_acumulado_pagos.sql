CREATE TABLE `ic_rep_tr_acumulado_pagos` (
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `id_moneda` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `numero` varchar(45) DEFAULT NULL,
  `tpo_cambio` decimal(10,4) DEFAULT NULL,
  `total_pago` decimal(15,2) DEFAULT NULL,
  `monto_moneda_base` decimal(15,2) DEFAULT NULL,
  `monto_usd` decimal(15,2) DEFAULT NULL,
  `monto_eur` decimal(15,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `fecha_act` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
