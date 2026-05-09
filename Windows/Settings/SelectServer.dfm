object SelectServerForm: TSelectServerForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1573#1593#1583#1575#1583#1575#1578' '#1575#1604#1605#1582#1583#1605
  ClientHeight = 176
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    BiDiMode = bdRightToLeft
    PanelStyle.Active = True
    ParentBiDiMode = False
    ParentFont = False
    Style.BorderStyle = ebsNone
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Height = 176
    Width = 325
    object Label1: TLabel
      Left = 224
      Top = 10
      Width = 41
      Height = 16
      Caption = #1575#1604#1587#1585#1601#1585':'
    end
    object Label2: TLabel
      Left = 224
      Top = 43
      Width = 92
      Height = 16
      Caption = #1575#1587#1605' '#1575#1604#1605#1587#1578#1582#1583#1605':'
    end
    object Label3: TLabel
      Left = 224
      Top = 77
      Width = 65
      Height = 16
      Caption = #1603#1604#1605#1577' '#1575#1604#1605#1585#1608#1585':'
    end
    object Label4: TLabel
      Left = 224
      Top = 112
      Width = 79
      Height = 16
      Caption = #1602#1575#1593#1583#1577' '#1575#1604#1576#1610#1575#1606#1575#1578':'
    end
    object cxComboBox1: TcxComboBox
      Left = 3
      Top = 108
      Properties.IncrementalFiltering = True
      Properties.OnInitPopup = cxComboBox1PropertiesInitPopup
      TabOrder = 3
      Width = 214
    end
    object cxButton1: TcxButton
      Left = 169
      Top = 143
      Width = 75
      Height = 25
      Caption = #1605#1608#1575#1601#1602
      TabOrder = 4
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton
      Left = 80
      Top = 143
      Width = 75
      Height = 25
      Caption = #1573#1604#1594#1575#1569' '#1575#1604#1571#1605#1585
      TabOrder = 5
      OnClick = cxButton2Click
    end
    object cxTextEdit1: TcxTextEdit
      Left = 3
      Top = 6
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 0
      Width = 214
    end
    object cxTextEdit2: TcxTextEdit
      Left = 3
      Top = 39
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 1
      Width = 214
    end
    object cxTextEdit3: TcxTextEdit
      Left = 3
      Top = 73
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      Properties.EchoMode = eemPassword
      TabOrder = 2
      Width = 214
    end
  end
  object con: TUniConnection
    ProviderName = 'sQL Server'
    Left = 264
    Top = 32
  end
end
