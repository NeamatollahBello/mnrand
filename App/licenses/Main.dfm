object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1578#1585#1575#1582#1610#1589' '#1576#1585#1606#1575#1605#1580' '#1575#1606#1583#1585#1608#1610#1583' '#1575#1604#1605#1606#1575#1585#1577' - '#1575#1604#1578#1591#1576#1610#1602
  ClientHeight = 517
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Button1: TButton
    Left = 272
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    BiDiMode = bdRightToLeft
    PanelStyle.Active = True
    ParentBiDiMode = False
    Style.BorderStyle = ebsNone
    TabOrder = 1
    Height = 517
    Width = 1000
    object cxGroupBox1: TcxGroupBox
      Left = 2
      Top = 2
      Align = alTop
      BiDiMode = bdRightToLeft
      PanelStyle.Active = True
      ParentBiDiMode = False
      Style.BorderStyle = ebsNone
      TabOrder = 0
      DesignSize = (
        996
        33)
      Height = 33
      Width = 996
      object Label1: TLabel
        Left = 947
        Top = 6
        Width = 38
        Height = 16
        Anchors = [akTop, akRight]
        Caption = #1575#1604#1576#1581#1579':'
      end
      object Label2: TLabel
        Left = 473
        Top = 8
        Width = 28
        Height = 16
        Anchors = [akTop, akRight]
        Caption = #1601#1593#1575#1604':'
      end
      object Label3: TLabel
        Left = 265
        Top = 8
        Width = 52
        Height = 16
        Anchors = [akTop, akRight]
        Caption = #1575#1604#1589#1604#1575#1581#1610#1577':'
      end
      object cxTextEdit1: TcxTextEdit
        Left = 520
        Top = 3
        Anchors = [akTop, akRight]
        Properties.OnChange = cxTextEdit1PropertiesChange
        TabOrder = 0
        Width = 421
      end
      object cxButton1: TcxButton
        Left = 7
        Top = 3
        Width = 114
        Height = 25
        Caption = #1585#1601#1593' '#1575#1604#1578#1585#1575#1582#1610#1589
        TabOrder = 3
        OnClick = cxButton1Click
      end
      object cxComboBox1: TcxComboBox
        Left = 346
        Top = 3
        Anchors = [akTop, akRight]
        Properties.Alignment.Horz = taLeftJustify
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediatePost = True
        Properties.Items.Strings = (
          #1575#1604#1603#1604
          #1601#1593#1575#1604
          #1594#1610#1585' '#1601#1593#1575#1604)
        Properties.UseLeftAlignmentOnEditing = False
        Properties.OnChange = cxTextEdit1PropertiesChange
        TabOrder = 1
        Text = #1575#1604#1603#1604
        Width = 121
      end
      object cxComboBox2: TcxComboBox
        Left = 138
        Top = 3
        Anchors = [akTop, akRight]
        Properties.Alignment.Horz = taLeftJustify
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediatePost = True
        Properties.Items.Strings = (
          #1575#1604#1603#1604
          #1594#1610#1585' '#1605#1606#1578#1607#1610#1577
          #1605#1606#1578#1607#1610#1577)
        Properties.UseLeftAlignmentOnEditing = False
        Properties.OnChange = cxTextEdit1PropertiesChange
        Properties.OnEditValueChanged = cxTextEdit1PropertiesChange
        TabOrder = 2
        Text = #1575#1604#1603#1604
        Width = 121
      end
    end
    object cxGrid1: TcxGrid
      Left = 2
      Top = 35
      Width = 996
      Height = 480
      Align = alClient
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      TabOrder = 1
      object cxGrid1DBTableView1: TcxGridDBTableView
        PopupMenu = PopupMenu1
        Navigator.Buttons.CustomButtons = <>
        FilterBox.Visible = fvNever
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCellDblClick = cxGrid1DBTableView1CellDblClick
        DataController.DataSource = LicensesSrc
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.ColumnsQuickCustomizationShowCommands = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.HideFocusRectOnExit = False
        OptionsSelection.UnselectFocusedRecordOnExit = False
        OptionsView.NoDataToDisplayInfoText = ' '
        OptionsView.CellAutoHeight = True
        OptionsView.GroupByBox = False
        object cxGrid1DBTableView1ID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          Visible = False
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          VisibleForCustomization = False
        end
        object cxGrid1DBTableView1Active: TcxGridDBColumn
          Caption = #1601#1593#1575#1604
          DataBinding.FieldName = 'Active'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
          HeaderAlignmentHorz = taCenter
        end
        object cxGrid1DBTableView1DeviceID: TcxGridDBColumn
          Caption = #1605#1593#1585#1601' '#1575#1604#1580#1607#1575#1586
          DataBinding.FieldName = 'DeviceID'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1CompName: TcxGridDBColumn
          Caption = #1575#1587#1605' '#1575#1604#1588#1585#1603#1577' ('#1575#1604#1578#1585#1582#1610#1589')'
          DataBinding.FieldName = 'CompName'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1TaxNum: TcxGridDBColumn
          Caption = #1575#1604#1585#1602#1605' '#1575#1604#1590#1585#1610#1576#1610
          DataBinding.FieldName = 'TaxNum'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1TradeReccord: TcxGridDBColumn
          Caption = #1575#1604#1587#1580#1604' '#1575#1604#1578#1580#1575#1585#1610
          DataBinding.FieldName = 'TradeReccord'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1Notes: TcxGridDBColumn
          Caption = #1605#1604#1575#1581#1592#1575#1578
          DataBinding.FieldName = 'Notes'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1Comp: TcxGridDBColumn
          Caption = #1575#1587#1605' '#1575#1604#1588#1585#1603#1577
          DataBinding.FieldName = 'Comp'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1CompMgr: TcxGridDBColumn
          Caption = #1575#1604#1605#1583#1610#1585
          DataBinding.FieldName = 'CompMgr'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1Phones: TcxGridDBColumn
          Caption = #1575#1604#1607#1608#1575#1578#1601
          DataBinding.FieldName = 'Phones'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1Address: TcxGridDBColumn
          Caption = #1575#1604#1593#1606#1608#1575#1606
          DataBinding.FieldName = 'Address'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.FilteringAddValueItems = False
          Options.FilteringPopup = False
          Width = 150
        end
        object cxGrid1DBTableView1LicDate: TcxGridDBColumn
          Caption = #1575#1604#1578#1575#1585#1610#1582
          DataBinding.FieldName = 'LicDate'
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.DisplayFormat = 'dd / MM / yyyy'
          Properties.EditFormat = 'dd / MM / yyyy'
          Properties.SaveTime = False
          Properties.ShowTime = False
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Width = 90
        end
        object cxGrid1DBTableView1LicEndDate: TcxGridDBColumn
          Caption = #1589#1604#1575#1581#1610#1577' '#1575#1604#1578#1585#1582#1610#1589
          DataBinding.FieldName = 'LicEndDate'
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.DisplayFormat = 'dd / MM / yyyy'
          Properties.EditFormat = 'dd / MM / yyyy'
          Properties.SaveTime = False
          Properties.ShowTime = False
          Properties.UseLeftAlignmentOnEditing = False
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Width = 90
        end
        object cxGrid1DBTableView1HasPOS: TcxGridDBColumn
          Caption = #1606#1602#1591#1577' '#1576#1610#1593
          DataBinding.FieldName = 'HasPOS'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Filtering = False
        end
        object cxGrid1DBTableView1NoQR: TcxGridDBColumn
          Caption = #1576#1583#1608#1606' QR'
          DataBinding.FieldName = 'NoQR'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'lic'
    Left = 400
    Top = 128
  end
  object db: TUniConnection
    ProviderName = 'sqlite'
    Database = 'D:\aProjects\mzdAnd\MzdAnd\AndLicenses\Data'
    SpecificOptions.Strings = (
      'sqlite.Direct=True'
      'sqlite.UseUnicode=True')
    Options.KeepDesignConnected = False
    LoginPrompt = False
    AfterConnect = dbAfterConnect
    Left = 112
    Top = 152
  end
  object SQLiteUniProvider1: TSQLiteUniProvider
    Left = 112
    Top = 232
  end
  object Licenses: TUniTable
    TableName = 'Licenses'
    DataTypeMap = <
      item
        FieldName = 'HasPOS'
        FieldType = ftBoolean
      end
      item
        DBType = 601
        FieldType = ftLargeint
      end
      item
        DBType = 603
        FieldType = ftWideString
        FieldLength = 10000
      end
      item
        FieldName = 'NoQR'
        FieldType = ftBoolean
      end
      item
        FieldName = 'Active'
        FieldType = ftBoolean
      end>
    Connection = db
    AfterInsert = LicensesAfterInsert
    Left = 504
    Top = 80
    object LicensesID: TLargeintField
      FieldName = 'ID'
    end
    object LicensesDeviceID: TWideStringField
      FieldName = 'DeviceID'
      Size = 200
    end
    object LicensesCompName: TWideStringField
      FieldName = 'CompName'
      Size = 200
    end
    object LicensesTaxNum: TWideStringField
      FieldName = 'TaxNum'
      Size = 200
    end
    object LicensesTradeReccord: TWideStringField
      FieldName = 'TradeReccord'
      Size = 200
    end
    object LicensesNotes: TWideStringField
      FieldName = 'Notes'
      Size = 200
    end
    object LicensesComp: TWideStringField
      FieldName = 'Comp'
      Size = 200
    end
    object LicensesCompMgr: TWideStringField
      FieldName = 'CompMgr'
      Size = 200
    end
    object LicensesPhones: TWideStringField
      FieldName = 'Phones'
      Size = 200
    end
    object LicensesAddress: TWideStringField
      FieldName = 'Address'
      Size = 200
    end
    object LicensesLicDate: TDateField
      FieldName = 'LicDate'
    end
    object LicensesLicEndDate: TDateField
      FieldName = 'LicEndDate'
    end
    object LicensesHasPOS: TBooleanField
      DefaultExpression = 'False'
      FieldName = 'HasPOS'
      Required = True
    end
    object LicensesNoQR: TBooleanField
      FieldName = 'NoQR'
      Required = True
    end
    object LicensesLic: TWideStringField
      FieldName = 'Lic'
      Size = 10000
    end
    object LicensesActive: TBooleanField
      FieldName = 'Active'
    end
  end
  object LicensesSrc: TUniDataSource
    DataSet = Licenses
    Left = 532
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    OnPopup = PopupMenu1Popup
    Left = 656
    Top = 168
    object N1: TMenuItem
      Caption = #1573#1590#1575#1601#1577' '#1578#1585#1582#1610#1589' '#1580#1583#1610#1583
      OnClick = N1Click
    end
    object N6: TMenuItem
      Caption = #1578#1585#1582#1610#1589' '#1580#1583#1610#1583' '#1604#1606#1601#1587' '#1575#1604#1586#1576#1608#1606' '#1575#1604#1605#1581#1583#1583
      OnClick = N6Click
    end
    object N2: TMenuItem
      Caption = #1578#1593#1583#1610#1604
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #1581#1584#1601
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #1606#1587#1582' '#1603#1608#1583' '#1575#1604#1578#1585#1582#1610#1589
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #1578#1593#1591#1610#1604
      OnClick = N5Click
    end
  end
  object UniScript1: TUniScript
    SQL.Strings = (
      'ALTER TABLE Licenses ADD NoQR integer not null default 0')
    Connection = db
    Left = 280
    Top = 232
  end
end
