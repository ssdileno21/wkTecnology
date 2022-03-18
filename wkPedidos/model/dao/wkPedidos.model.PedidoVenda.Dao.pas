unit wkPedidos.model.PedidoVenda.Dao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, Vcl.Forms, Vcl.Dialogs, uWkUtils,

  wkPedidos.model.interfaces.PedidosDadosGerais,
  wkPedidos.model.interfaces.PedidosProdutos
  ;

type
  TPedidoVendaDao = class(TDataModule)
    FDQuery1: TFDQuery;
    MemPedido: TFDMemTable;
    DataSource1: TDataSource;
    MemPedidoProdutos: TFDMemTable;
    FDStoredProc1: TFDStoredProc;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    MemPedidoNumeroPedido: TIntegerField;
    MemPedidoDataEmissao: TDateTimeField;
    MemPedidoCodigoCliente: TIntegerField;
    MemPedidoValorTotal: TFloatField;
    MemPedidoProdutosAutoincrem: TIntegerField;
    MemPedidoProdutosNPedido: TIntegerField;
    MemPedidoProdutosCodigoProduto: TIntegerField;
    MemPedidoProdutosQuantidade: TIntegerField;
    MemPedidoProdutosVlrUnitario: TFloatField;
    MemPedidoProdutosVlrTotal: TFloatField;
    MemPedidoProdutosDescricao: TStringField;
    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutaComando(Value : string; pTipo : Integer=0);
    procedure InserirPedido;
    procedure InserirProduto;
    procedure GravarPedido;
  public
    { Public declarations }
    function ExistePedido : Boolean;
    function ExistemPedidoItens : Boolean;
    procedure ProximoCodigoPedido(Value : iPedidosDadosGeraisModel);
    procedure ProximoCodigoItem(Value : iPedidosProdutosModel);
    procedure AbrirPedido(Value : iPedidosDadosGeraisModel; pNumeroPedido :
      Integer);
    procedure GravaPedidoTemp(Value : iPedidosDadosGeraisModel);
    procedure GravaPedidoProdutosTemp(Value : iPedidosProdutosModel);
    procedure BuscarCliente(Value : iPedidosDadosGeraisModel);
    procedure DeletarProduto(Value : iPedidosProdutosModel);
    procedure BuscarProduto(Value : iPedidosProdutosModel);



  end;

var
  PedidoVendaDao: TPedidoVendaDao;
{
  case pTipo of
    0 : mess := 'executar processo.';
    1 : mess := 'abrir pedido.';
    2 : mess := 'deletar produto.';
    3 : mess := 'gravar pedido.';
    4 : mess := 'buscar cliente.';
    5 : mess := 'buscar produto.';
    6 : mess := 'gerar n�mero pedido.';
    7 : mess := 'gerar sequencial do produto no pedido.';
  end;
 }

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TPedidoVendaDao.AbrirPedido(Value: iPedidosDadosGeraisModel;
  pNumeroPedido: Integer);
begin

end;

procedure TPedidoVendaDao.BuscarCliente(Value: iPedidosDadosGeraisModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_BuscaCliente';
    FDStoredProc1.Prepare;
    if Value.CodigoCliente > 0 then
      FDStoredProc1.ParamByName('pCodigo').AsInteger := Value.CodigoCliente;
    if Value.NomeCliente <> '' then
      FDStoredProc1.ParamByName('pNome').AsString := Value.NomeCliente;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
    begin
      Value.CodigoCliente(FDStoredProc1.FieldByName('Codigo').AsInteger);
      Value.NomeCliente(FDStoredProc1.FieldByName('Nome').AsString);
    end;
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.BuscarProduto(Value: iPedidosProdutosModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_BuscaProduto';
    FDStoredProc1.Prepare;
    if Value.CodigoProduto > 0 then
      FDStoredProc1.ParamByName('pCodigo').AsInteger := Value.CodigoProduto;
    if Value.DescricaoProduto <> '' then
      FDStoredProc1.ParamByName('pDescricao').AsString :=
        Value.DescricaoProduto;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
    begin
      Value.CodigoProduto(FDStoredProc1.FieldByName('Codigo').AsInteger);
      Value.DescricaoProduto(FDStoredProc1.FieldByName('Descricao').AsString);
    end;
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.DeletarProduto(Value: iPedidosProdutosModel);
begin

end;

procedure TPedidoVendaDao.ExecutaComando(Value: string; pTipo : Integer);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Text := Value;

    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;

end;

function TPedidoVendaDao.ExistemPedidoItens : Boolean;
begin
  Result := (NOT MemPedidoProdutos.IsEmpty);
end;

function TPedidoVendaDao.ExistePedido: Boolean;
begin
  Result := (NOT MemPedidoProdutos.IsEmpty);
end;

procedure TPedidoVendaDao.FDConnection1BeforeConnect(Sender: TObject);
begin
  FDPhysMySQLDriverLink1.VendorLib :=
    ExtractFilePath(Application.ExeName) + 'libmysql.dll';
end;

procedure TPedidoVendaDao.GravaPedidoProdutosTemp(Value: iPedidosProdutosModel);
begin
  try
    MemPedidoProdutos.Close;
    MemPedidoProdutos.Open;
    with MemPedidoProdutos do
    begin
      Append;
      FieldByName('Autoincrem').AsInteger := Value.Autoincrem;
      FieldByName('NumeroPedido').AsInteger := Value.NumeroPedido;
      FieldByName('CodigoProduto').AsInteger := Value.CodigoProduto;
      FieldByName('Quantidade').AsInteger := Value.Quantidade;
      FieldByName('VlrUnitario').AsFloat := Value.VlrUnitario;
      FieldByName('VlrTotal').AsFloat := Value.VlrTotal;
      Post;
    end;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
end;

procedure TPedidoVendaDao.GravaPedidoTemp(Value : iPedidosDadosGeraisModel);
begin
  try
    MemPedido.Close;
    MemPedido.Open;
    with MemPedido do
    begin
      Append;
      FieldByName('NumeroPedido').AsInteger := Value.NumeroPedido;
      FieldByName('CodigoCliente').AsInteger := Value.CodigoCliente;
      FieldByName('ValorTotal').AsFloat := Value.ValorTotal;
      Post;
    end;

  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
end;

procedure TPedidoVendaDao.GravarPedido;
begin

end;

procedure TPedidoVendaDao.InserirPedido;
begin

end;

procedure TPedidoVendaDao.InserirProduto;
begin
{  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_InserirPedidoProduto';
    FDStoredProc1.Prepare;
    FDStoredProc1.ParamByName('pAutoincrem').AsInteger := Value.Autoincrem;
    FDStoredProc1.ParamByName('pNumeroPedido').AsInteger := Value.NumeroPedido;
    FDStoredProc1.ParamByName('pCodigoProduto').AsInteger
      := Value.CodigoProduto;
    FDStoredProc1.ParamByName('pQuantidade').AsInteger := Value.Quantidade;
    FDStoredProc1.ParamByName('pVlrUnitario').AsFloat := Value.VlrUnitario;
    FDStoredProc1.ParamByName('pVlrTotal').AsFloat := Value.VlrTotal;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
    begin
      Value.CodigoProduto(FDStoredProc1.FieldByName('Codigo').AsInteger);
      Value.DescricaoProduto(FDStoredProc1.FieldByName('Descricao').AsString);
    end;
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
  }
end;

procedure TPedidoVendaDao.ProximoCodigoItem(Value: iPedidosProdutosModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_ProximoCodigoItem';
    FDStoredProc1.Prepare;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
      Value.Autoincrem(FDStoredProc1.FieldByName('ProximoCod').AsInteger);
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.ProximoCodigoPedido(Value: iPedidosDadosGeraisModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_ProximoCodigoPedido';
    FDStoredProc1.Prepare;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
      Value.NumeroPedido(FDStoredProc1.FieldByName('ProximoCod').AsInteger);
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

end.