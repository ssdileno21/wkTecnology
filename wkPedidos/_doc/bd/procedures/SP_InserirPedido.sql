USE wkdb;
DELIMITER $$
DROP PROCEDURE IF exists SP_InserirPedido $$
CREATE PROCEDURE SP_InserirPedido(
	in 	pNumeroPedido int, 		
        pCodigoCliente int,
        pVlrTotal Decimal(10,2)        
)
begin
	INSERT INTO tbpedidosdadosgerais (NumeroPedido, CodigoCliente, VlrTotal)
		Select 
			pNumeroPedido, 
            pCodigoCliente, 
            (	SELECT SUM(ValorTotal) 
				FROM tbpedidosprodutos p
                where P.NumeroPedido = pNumeroPedido
			);
end $$

DELIMITER ;
