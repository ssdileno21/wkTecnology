USE wkdb;
DELIMITER $$
DROP PROCEDURE IF exists SP_InserirPedidoProduto $$
CREATE PROCEDURE SP_InserirPedidoProduto(
	in 	pAutoincrem int, 
		pNumeroPedido int,
        pCodigoProduto int,
        pQuantidade int,
        pVlrUnitario Decimal(10,2),
        pVlrTotal Decimal(10,2)        
)
begin
	INSERT INTO tbpedidosprodutos (Autoincrem, NumeroPedido, CodigoProduto, Quantidade, VlrUnitario, VlrTotal)
		Select IFNULL(Autoincrem,1), pNumeroPedido, pCodigoProduto, pQuantidade, pVlrUnitario, (IFNULL(pQuantidade,0) * IFNULL(pVlrUnitario,0.00));
end $$

DELIMITER ;
