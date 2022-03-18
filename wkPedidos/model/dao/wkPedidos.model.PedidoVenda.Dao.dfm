object PedidoVendaDao: TPedidoVendaDao
  OldCreateOrder = False
  Height = 537
  Width = 466
  object FDQuery1: TFDQuery
    Left = 32
    Top = 160
  end
  object MemPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 200
    Top = 112
    object MemPedidoNumeroPedido: TIntegerField
      DisplayLabel = 'N'#176' Pedido'
      FieldName = 'NumeroPedido'
    end
    object MemPedidoDataEmissao: TDateTimeField
      DisplayLabel = 'Dta. Emiss'#227'o'
      FieldName = 'DataEmissao'
    end
    object MemPedidoCodigoCliente: TIntegerField
      DisplayLabel = 'C'#243'digo do Cliente'
      FieldName = 'CodigoCliente'
    end
    object MemPedidoValorTotal: TFloatField
      DisplayLabel = 'Valor Total'
      FieldName = 'ValorTotal'
      currency = True
    end
  end
  object DataSource1: TDataSource
    Left = 40
    Top = 392
  end
  object MemPedidoProdutos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 200
    Top = 176
    object MemPedidoProdutosAutoincrem: TIntegerField
      FieldName = 'Seq.'
      Visible = False
    end
    object MemPedidoProdutosNPedido: TIntegerField
      FieldName = 'N'#176' Pedido'
      Visible = False
    end
    object MemPedidoProdutosCodigoProduto: TIntegerField
      FieldName = 'C'#243'digo Produto'
    end
    object MemPedidoProdutosDescricao: TStringField
      DisplayWidth = 60
      FieldName = 'Descricao'
      Size = 150
    end
    object MemPedidoProdutosQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object MemPedidoProdutosVlrUnitario: TFloatField
      FieldName = 'Vlr.Unit'#225'rio'
      currency = True
    end
    object MemPedidoProdutosVlrTotal: TFloatField
      FieldName = 'Vlr.Total'
      currency = True
    end
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    Left = 32
    Top = 80
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 152
    Top = 16
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=wkdb'
      'User_Name=root'
      'Password=Mysql@123'
      'DriverID=MySQL')
    LoginPrompt = False
    BeforeConnect = FDConnection1BeforeConnect
    Left = 32
    Top = 16
  end
end
