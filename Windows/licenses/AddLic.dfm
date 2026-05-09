object AddLicForm: TAddLicForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AddLicForm'
  ClientHeight = 539
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    BiDiMode = bdRightToLeft
    PanelStyle.Active = True
    ParentBiDiMode = False
    Style.BorderStyle = ebsNone
    TabOrder = 0
    ExplicitWidth = 574
    DesignSize = (
      576
      539)
    Height = 539
    Width = 576
    object Label1: TLabel
      Left = 478
      Top = 34
      Width = 73
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1587#1605' '#1575#1604#1588#1585#1603#1577':'
    end
    object Label2: TLabel
      Left = 478
      Top = 64
      Width = 65
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1587#1605' '#1575#1604#1605#1583#1610#1585':'
    end
    object Label3: TLabel
      Left = 484
      Top = 124
      Width = 41
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1604#1593#1606#1608#1575#1606':'
      ExplicitLeft = 482
    end
    object Label4: TLabel
      Left = 484
      Top = 94
      Width = 44
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1604#1607#1608#1575#1578#1601':'
      ExplicitLeft = 482
    end
    object Label5: TLabel
      Left = 478
      Top = 198
      Width = 54
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1605#1604#1575#1581#1592#1575#1578':'
    end
    object Label6: TLabel
      Left = 3
      Top = 316
      Width = 568
      Height = 23
      Alignment = taCenter
      AutoSize = False
      Caption = #1605#1593#1604#1608#1605#1575#1578' '#1575#1604#1578#1585#1582#1610#1589
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 478
      Top = 381
      Width = 73
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1587#1605' '#1575#1604#1588#1585#1603#1577':'
    end
    object Label8: TLabel
      Left = 478
      Top = 412
      Width = 79
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1604#1585#1602#1605' '#1575#1604#1590#1585#1610#1576#1610':'
    end
    object Label9: TLabel
      Left = 478
      Top = 445
      Width = 89
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1575#1604#1587#1580#1604' '#1575#1604#1578#1580#1575#1585#1610':'
    end
    object Label10: TLabel
      Left = 478
      Top = 272
      Width = 81
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1578#1575#1585#1610#1582' '#1575#1604#1578#1585#1582#1610#1589':'
    end
    object Label11: TLabel
      Left = 478
      Top = 349
      Width = 70
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1605#1593#1585#1601' '#1575#1604#1580#1607#1575#1586':'
    end
    object Label12: TLabel
      Left = 478
      Top = 477
      Width = 95
      Height = 16
      Anchors = [akTop, akRight]
      Caption = #1589#1604#1575#1581#1610#1577' '#1575#1604#1578#1585#1582#1610#1589':'
    end
    object Label13: TLabel
      Left = 3
      Top = 6
      Width = 568
      Height = 23
      Alignment = taCenter
      AutoSize = False
      Caption = #1605#1593#1604#1608#1605#1575#1578' '#1575#1604#1588#1585#1603#1577
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object cxDBTextEdit1: TcxDBTextEdit
      Left = 3
      Top = 31
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'Comp'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 0
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBTextEdit2: TcxDBTextEdit
      Left = 3
      Top = 61
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'CompMgr'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 1
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBTextEdit3: TcxDBTextEdit
      Left = 3
      Top = 91
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'Phones'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 2
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBMemo1: TcxDBMemo
      Left = 3
      Top = 121
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'Address'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 3
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Height = 68
      Width = 468
    end
    object cxDBMemo2: TcxDBMemo
      Left = 3
      Top = 195
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'Notes'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 4
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Height = 68
      Width = 468
    end
    object cxButton1: TcxButton
      Left = 294
      Top = 508
      Width = 75
      Height = 25
      Caption = #1605#1608#1575#1601#1602
      TabOrder = 11
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton
      Left = 206
      Top = 508
      Width = 75
      Height = 25
      Caption = #1573#1604#1594#1575#1569' '#1575#1604#1571#1605#1585
      TabOrder = 12
      OnClick = cxButton2Click
    end
    object cxDBTextEdit4: TcxDBTextEdit
      Left = 3
      Top = 378
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'CompName'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 7
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBTextEdit5: TcxDBTextEdit
      Left = 3
      Top = 409
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'TaxNum'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 8
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBTextEdit6: TcxDBTextEdit
      Left = 3
      Top = 442
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'TradeReccord'
      DataBinding.DataSource = MainForm.LicensesSrc
      TabOrder = 9
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBDateEdit1: TcxDBDateEdit
      Left = 3
      Top = 269
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'LicDate'
      DataBinding.DataSource = MainForm.LicensesSrc
      Properties.Alignment.Horz = taLeftJustify
      Properties.DisplayFormat = 'dd / MM / yyyy'
      Properties.EditFormat = 'dd / MM / yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      Properties.UseLeftAlignmentOnEditing = False
      TabOrder = 5
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBTextEdit7: TcxDBTextEdit
      Left = 3
      Top = 346
      Anchors = [akLeft, akTop, akRight]
      BiDiMode = bdLeftToRight
      DataBinding.DataField = 'DeviceID'
      DataBinding.DataSource = MainForm.LicensesSrc
      ParentBiDiMode = False
      TabOrder = 6
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
    object cxDBDateEdit2: TcxDBDateEdit
      Left = 3
      Top = 474
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'LicEndDate'
      DataBinding.DataSource = MainForm.LicensesSrc
      Properties.Alignment.Horz = taLeftJustify
      Properties.DisplayFormat = 'dd / MM / yyyy'
      Properties.EditFormat = 'dd / MM / yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      Properties.UseLeftAlignmentOnEditing = False
      TabOrder = 10
      OnKeyDown = cxDBTextEdit1KeyDown
      OnKeyPress = cxDBTextEdit1KeyPress
      Width = 468
    end
  end
end
