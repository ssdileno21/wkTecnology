unit wkPedidos.model.factory.PedidosProdutos;

interface

uses
  wkPedidos.model.interfaces.PedidosProdutos, wkPedidos.model.PedidosProdutos;


type
  TPedidosProdutosFactory = class(TInterfacedObject,iPedidosProdutosFactory)
  private
    FPedidosProdutos : iPedidosProdutosModel;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iPedidosProdutosFactory;
    function PedidosProdutos : iPedidosProdutosModel;
  end;

implementation

{ TPedidosProdutosFactory }

constructor TPedidosProdutosFactory.Create;
begin
  FPedidosProdutos := TPedidosProdutosModel.New;
end;

destructor TPedidosProdutosFactory.Destroy;
begin

  inherited;
end;

class function TPedidosProdutosFactory.New: iPedidosProdutosFactory;
begin
  Result := Self.Create;

end;

function TPedidosProdutosFactory.PedidosProdutos: iPedidosProdutosModel;
begin
  Result := FPedidosProdutos;
end;

end.
