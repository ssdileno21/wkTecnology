use wkdb;

CREATE TABLE `tbpedidosprodutos` (
  `Autoincrem` int NOT NULL COMMENT 'Identificador do item do pedido',
  `NumeroPedido` int DEFAULT NULL COMMENT 'Numero do pedido',
  `CodigoProduto` int DEFAULT NULL COMMENT 'Codigo do produto',
  `Quantidade` int DEFAULT NULL COMMENT 'Quantidade do produto selecionado',
  `VlrUnitario` decimal(10,2) DEFAULT NULL COMMENT 'Valor unitario do produto',
  `VlrTotal` decimal(10,2) DEFAULT NULL COMMENT 'Valor total do produto',
  PRIMARY KEY (`Autoincrem`),
  KEY `fk_tbpedidosgerais_tbpedidosprodutos_idx` (`NumeroPedido`),
  KEY `fk_tbprodutos_tbpedidosprodutos_idx` (`CodigoProduto`),
  CONSTRAINT `fk_tbpedidosgerais_tbpedidosprodutos` FOREIGN KEY (`NumeroPedido`) REFERENCES `tbpedidosdadosgerais` (`NumeroPedido`),
  CONSTRAINT `fk_tbprodutos_tbpedidosprodutos` FOREIGN KEY (`CodigoProduto`) REFERENCES `tbprodutos` (`Codigo`)
) 
