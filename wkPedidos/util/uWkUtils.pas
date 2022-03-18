unit uWkUtils;

interface

uses System.StrUtils, System.SysUtils, Vcl.Dialogs, Vcl.StdCtrls;

const
    MESSAGEFIXO1 =
      'Problema ao executar comando, contate o administador do sistema, '+
      'e informe o erro a seguir:';

    MESSAGEEXCEPCOMPCONTROL =
      'Erro de controle do componente, ' + MESSAGEFIXO1;

    MESSAGECARREGAPEDIDOSVALCLIENTE =
      'Para carregar os pedidos, o c�digo do cliente n�o pode ser informado.';

    MESSAGEVALIDARCAMPOSPEDIDOS =
      'Informa��es obrigat�rias para cria��o de um pedido: '+#13+
      '* N�mero do pedido gerado;' +#13+
      '* C�digo do cliente;';

    MESSAGEVALIDARCAMPOSPEDIDOSPRODUTOS =
      'Informa��es obrigat�rias para inserir um novo produto: '+#13+
      '* C�digo do produto;' +#13+
      '* Valor unit�rio informado e maior que zero;'+#13+
      '* Quantidade do produto informada e maior que zero;';

    MESSAGEGRAVARD =
      'Pedido inserido com sucesso.';

  function CalculaValorTotalProduto(edtQtd : TEdit; edtVlrUni : TEdit): Double;
  function ArredValores(value: double;casas : integer): double;

implementation


function CalculaValorTotalProduto(edtQtd : TEdit; edtVlrUni : TEdit): Double;
var
  vValorVenda, vTotal : Double;
  vQtd : Integer;
  vTemp : string;
begin
  try
    if (edtQtd.Text <> '') and (edtVlrUni.Text <> '') then
    begin
      vValorVenda := 0;
      vTotal := 0;
      vQtd := 0;
      if edtVlrUni.Text = '0' then
        Exit;

      vValorVenda := StrToFloat(StringReplace(
        edtVlrUni.Text,'.','',[rfReplaceAll]));
      vQtd := StrToIntDef(edtQtd.Text,0);

      //vValorVenda := ArredValores(vValorVenda,2);


      vTotal := vValorVenda * vQtd;

      //vTotal := ArredValores(vTotal,2);

      Result := vTotal;

    end else
      Result := 0.00;
  except on E : Exception do
    begin
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
end;

function ArredValores(value: double;casas : integer): double;
Var
fracao, Total:real;
decimal:string;
begin
  Result := 0;
  if value = 0 then
    Exit;
    try
      //Retorna a parte fracion�ria de um n�mero
      fracao:=Frac(value);
      //decimal recebe a parte decimal
      decimal:=(RightStr(floattostr(fracao),length(floattostr(fracao))-2));
      //Enquanto o tamanho da variavel decimal for maior que o n�mero
      //de casas fa�a
      while length(decimal) > casas do
      begin
        //Verifica se o �ltimo digito da vari�vel decimal � maior que 5
        if strtoint(RightStr(decimal,1))>5 then
        begin
          //Descarta o �ltimo digito da vari�vel Decimal
          decimal:=leftstr(decimal,length(decimal)-1);
          //Soma o valor n�mero da variavel decimal + 1
          decimal:=floattostr(strtofloat(decimal) + 1);
        end else
        //Descarta o �ltimo digito da vari�vel Decimal
        decimal:=leftstr(decimal,length(decimal)-1);
      end;
      //devolve o resultado para a fun��o
      result:=(int(value) + (strtofloat(decimal)/100));
    except on e : exception do
        ShowMessage(e.Message);
    end;
end;

end.
