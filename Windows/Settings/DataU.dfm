object EData: TEData
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 612
  Width = 847
  PixelsPerInch = 120
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 288
    Top = 72
  end
  object db: TUniConnection
    ProviderName = 'sQL Server'
    Database = 'mnrAnd'
    Options.KeepDesignConnected = False
    Username = 'sa'
    Server = '(local),2239'
    LoginPrompt = False
    Left = 16
    Top = 48
    EncryptedPassword = 'D2FFBEFF9EFFCEFFCBFFCAFFCDFFC9FFC9FFCEFFCFFF'
  end
  object mnr: TUniConnection
    ProviderName = 'sQL Server'
    Database = 'MnrAccDB002'
    SpecificOptions.Strings = (
      'sQL Server.ConnectionTimeout=5')
    Options.KeepDesignConnected = False
    Username = 'sa'
    Server = '192.168.43.158\sqlexpress'
    LoginPrompt = False
    Left = 16
    Top = 104
    EncryptedPassword = '9EFFD2FFCEFFCBFFCAFFCDFFC9FFC9FFCEFFCFFF'
  end
  object Users: TUniTable
    TableName = 'Users'
    OrderFields = 'Name'
    DataTypeMap = <
      item
        FieldName = 'pBill'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pReturn'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pPayIn'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pPayOut'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pDiscIn'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pDiscOut'
        FieldType = ftBoolean
      end
      item
        FieldName = 'pGeneral'
        FieldType = ftBoolean
      end>
    Connection = db
    LockMode = lmNone
    AfterInsert = UsersAfterInsert
    AfterEdit = UsersAfterEdit
    BeforePost = UsersBeforePost
    AfterPost = UsersAfterPost
    AfterCancel = UsersAfterCancel
    BeforeDelete = UsersBeforeDelete
    AfterDelete = UsersAfterDelete
    Left = 160
    Top = 16
    object UsersID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object UsersName: TWideStringField
      FieldName = 'Name'
      Size = 50
    end
    object UsersPassword: TWideStringField
      FieldName = 'Password'
      Size = 50
    end
    object UsersLastToken: TStringField
      FieldName = 'LastToken'
      FixedChar = True
      Size = 128
    end
    object UsersPriceField: TWideStringField
      FieldName = 'PriceField'
      OnGetText = UsersPriceFieldGetText
      OnSetText = UsersPriceFieldSetText
      Size = 50
    end
    object UsersSaleman: TGuidField
      FieldName = 'Saleman'
      FixedChar = True
      Size = 38
    end
    object UsersCostCenter: TGuidField
      FieldName = 'CostCenter'
      FixedChar = True
      Size = 38
    end
    object UsersStore: TGuidField
      FieldName = 'Store'
      FixedChar = True
      Size = 38
    end
    object UsersmnrUser: TGuidField
      FieldName = 'mnrUser'
      FixedChar = True
      Size = 38
    end
    object UserspBill: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pBill'
      Required = True
    end
    object UserspReturn: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pReturn'
      Required = True
    end
    object UserspPayIn: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pPayIn'
      Required = True
    end
    object UserspPayOut: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pPayOut'
      Required = True
    end
    object UserspDiscIn: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pDiscIn'
      Required = True
    end
    object UserspDiscOut: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pDiscOut'
      Required = True
    end
    object UserspSpent: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pSpent'
      Required = True
    end
    object UserspPrice: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pPrice'
      Required = True
    end
    object UserspStock: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pStock'
      Required = True
    end
    object UserspCustReport: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pCustReport'
      Required = True
    end
    object UserspAllAcc: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pAllAcc'
      Required = True
    end
    object UserspGLedger: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'pGLedger'
      Required = True
    end
    object UserspOnlyPOS: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'pOnlyPOS'
      Required = True
    end
    object UserspEditPrice: TIntegerField
      DefaultExpression = '1'
      FieldName = 'pEditPrice'
      Required = True
      OnGetText = UserspEditPriceGetText
      OnSetText = UserspEditPriceSetText
    end
    object UserspQuantityType: TIntegerField
      DefaultExpression = '1'
      FieldName = 'pQuantityType'
      Required = True
      OnGetText = UserspQuantityTypeGetText
      OnSetText = UserspQuantityTypeSetText
    end
    object UserspOnlyAvailable: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'pOnlyAvailable'
      Required = True
    end
    object UserspAllMat: TBooleanField
      DefaultExpression = 'False'
      FieldName = 'pAllMat'
      Required = True
    end
    object UserspShowCost: TBooleanField
      DefaultExpression = 'False'
      FieldName = 'pShowCost'
      Required = True
    end
    object UserspShowQuality: TBooleanField
      DefaultExpression = 'False'
      FieldName = 'pShowQuality'
      Required = True
    end
  end
  object mnrMaterials: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, code+'#39' - '#39'+Name as Name from mnrMaterial')
    Left = 40
    Top = 160
    object mnrMaterialsID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrMaterialsName: TWideStringField
      FieldName = 'Name'
      Size = 512
    end
  end
  object mnrGroups: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select Id, code+'#39' - '#39'+Name as Name from mnrGrp')
    Left = 24
    Top = 208
    object mnrGroupsId: TGuidField
      FieldName = 'Id'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrGroupsName: TWideStringField
      FieldName = 'Name'
      Required = True
      Size = 512
    end
  end
  object mnrClients: TUniQuery
    Connection = mnr
    SQL.Strings = (
      
        'select ID, code+'#39' - '#39'+Name as Name from mnrAcc where CustID<>'#39'00' +
        '000000-0000-0000-0000-000000000000'#39)
    Left = 16
    Top = 272
    object mnrClientsID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrClientsName: TWideStringField
      FieldName = 'Name'
      Required = True
      Size = 512
    end
  end
  object UsersSrc: TUniDataSource
    DataSet = Users
    Left = 88
    Top = 24
  end
  object mnrMaterialsSrc: TUniDataSource
    DataSet = mnrMaterials
    Left = 112
    Top = 152
  end
  object mnrGroupsSrc: TUniDataSource
    DataSet = mnrGroups
    Left = 88
    Top = 208
  end
  object mnrClientsSrc: TUniDataSource
    DataSet = mnrClients
    Left = 64
    Top = 256
  end
  object mnrAccounts: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, code+'#39' - '#39'+ Name as Name from mnrAcc')
    Left = 16
    Top = 328
    object mnrAccountsID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrAccountsName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrAccountsSrc: TUniDataSource
    DataSet = mnrAccounts
    Left = 88
    Top = 320
  end
  object mnrBillType: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrBillType')
    Left = 464
    Top = 16
    object mnrBillTypeID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrBillTypeName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrBillTypeSrc: TUniDataSource
    DataSet = mnrBillType
    Left = 392
    Top = 8
  end
  object mnrCurr: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrCurrency')
    Left = 456
    Top = 72
    object mnrCurrID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrCurrName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrCurrSrc: TUniDataSource
    DataSet = mnrCurr
    Left = 384
    Top = 64
  end
  object mnrStore: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrStore')
    Left = 448
    Top = 120
    object mnrStoreID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrStoreName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrStoreSrc: TUniDataSource
    DataSet = mnrStore
    Left = 384
    Top = 120
  end
  object mnrUsers: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrUsers')
    Left = 440
    Top = 184
    object mnrUsersID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrUsersName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrUsersSrc: TUniDataSource
    DataSet = mnrUsers
    Left = 384
    Top = 184
  end
  object mnrCost: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrCostJob')
    Left = 440
    Top = 248
    object mnrCostID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrCostName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Size = 525
    end
  end
  object mnrCostSrc: TUniDataSource
    DataSet = mnrCost
    Left = 384
    Top = 240
  end
  object mnrPayTypes: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Name from mnrPayType')
    Left = 200
    Top = 248
    object mnrPayTypesID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrPayTypesName: TWideStringField
      FieldName = 'Name'
      Required = True
      Size = 512
    end
  end
  object mnrPayTypesSrc: TUniDataSource
    DataSet = mnrPayTypes
    Left = 256
    Top = 240
  end
  object mnrSaleMan: TUniQuery
    Connection = mnr
    SQL.Strings = (
      'select ID, Code+'#39' - '#39'+Name as Name from mnrSellMan')
    Left = 200
    Top = 304
    object mnrSaleManID: TGuidField
      FieldName = 'ID'
      Required = True
      FixedChar = True
      Size = 38
    end
    object mnrSaleManName: TWideStringField
      FieldName = 'Name'
      ReadOnly = True
      Required = True
      Size = 1027
    end
  end
  object mnrSaleManSrc: TUniDataSource
    DataSet = mnrSaleMan
    Left = 256
    Top = 296
  end
  object settings: TUniTable
    TableName = 'settings'
    Connection = db
    LockMode = lmNone
    AfterOpen = settingsAfterPost
    BeforeInsert = settingsBeforeEdit
    AfterInsert = settingsAfterPost
    BeforeEdit = settingsBeforeEdit
    AfterEdit = settingsAfterPost
    AfterPost = settingsAfterPost
    AfterCancel = settingsAfterPost
    Left = 160
    Top = 80
    object settingsSellType: TGuidField
      FieldName = 'SellType'
      FixedChar = True
      Size = 38
    end
    object settingsReturnType: TGuidField
      FieldName = 'ReturnType'
      FixedChar = True
      Size = 38
    end
    object settingsCurrency: TGuidField
      FieldName = 'Currency'
      FixedChar = True
      Size = 38
    end
    object settingsDiscAcc: TGuidField
      FieldName = 'DiscAcc'
      FixedChar = True
      Size = 38
    end
    object settingsDisc2Acc: TGuidField
      FieldName = 'Disc2Acc'
      FixedChar = True
      Size = 38
    end
    object settingsPayInType: TGuidField
      FieldName = 'PayInType'
      FixedChar = True
      Size = 38
    end
    object settingsPayOutType: TGuidField
      FieldName = 'PayOutType'
      FixedChar = True
      Size = 38
    end
    object settingsDayType: TGuidField
      FieldName = 'DayType'
      FixedChar = True
      Size = 38
    end
    object settingsSpendAcc: TGuidField
      FieldName = 'SpendAcc'
      FixedChar = True
      Size = 38
    end
    object settingsCompAddress: TWideStringField
      FieldName = 'CompAddress'
      Size = 255
    end
    object settingsCompLogo: TBlobField
      FieldName = 'CompLogo'
    end
    object settingsLic: TWideMemoField
      FieldName = 'Lic'
      BlobType = ftWideMemo
    end
    object settingsPriceType: TGuidField
      FieldName = 'PriceType'
      FixedChar = True
      Size = 38
    end
    object settingsStockType: TGuidField
      FieldName = 'StockType'
      FixedChar = True
      Size = 38
    end
    object settingsDefaultPayedAccount: TGuidField
      FieldName = 'DefaultPayedAccount'
      FixedChar = True
      Size = 38
    end
    object settingsMatUpdateInterval: TIntegerField
      FieldName = 'MatUpdateInterval'
    end
    object settingsmnrVersion: TWideStringField
      FieldName = 'mnrVersion'
      Size = 50
    end
  end
  object settingsSrc: TUniDataSource
    DataSet = settings
    Left = 88
    Top = 72
  end
  object updates: TJvMultiStringHolder
    MultipleStrings = <
      item
        Name = '0'
        Strings.Strings = (
          'alter table Users add pAllMat bit not null default 0'
          'GO'
          'alter table Users add pShowCost bit not null default 0')
      end
      item
        Name = '1.01'
        Strings.Strings = (
          'alter table Users add pShowQuality bit not null default 0')
      end>
    Left = 248
    Top = 168
  end
end
