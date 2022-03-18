use wkdb;

CREATE TABLE `tbpedidosdadosgerais` (
  `NumeroPedido` int NOT NULL COMMENT 'Numero do pedido',
  `DataEmissao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da emissao',
  `CodigoCliente` int DEFAULT NULL COMMENT 'Codigo do cliente',
  `ValorTotal` decimal(10,2) DEFAULT NULL COMMENT 'Valor total do pedido',
  PRIMARY KEY (`NumeroPedido`),
  KEY `fk_tbclientes_tbpedidosdadosgerais_idx` (`CodigoCliente`),
  CONSTRAINT `fk_tbclientes_tbpedidosdadosgerais` FOREIGN KEY (`CodigoCliente`) REFERENCES `tbclientes` (`Codigo`)
)
