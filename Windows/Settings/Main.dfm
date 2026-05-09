object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1573#1593#1583#1575#1583#1575#1578' '#1575#1604#1605#1582#1583#1605
  ClientHeight = 516
  ClientWidth = 1097
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -7
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 8
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 0
    Width = 1097
    Height = 516
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    BiDiMode = bdRightToLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    Properties.ActivePage = cxTabSheet3
    Properties.CustomButtons.Buttons = <>
    OnPageChanging = cxPageControl1PageChanging
    ClientRectBottom = 512
    ClientRectLeft = 4
    ClientRectRight = 1093
    ClientRectTop = 26
    object cxTabSheet3: TcxTabSheet
      Caption = #1573#1593#1583#1575#1583#1575#1578' '#1575#1604#1582#1583#1605#1577
      ImageIndex = 2
      DesignSize = (
        1089
        486)
      object cxGroupBox3: TcxGroupBox
        Left = 436
        Top = 174
        Anchors = []
        PanelStyle.Active = True
        Style.BorderStyle = ebsNone
        TabOrder = 0
        Height = 139
        Width = 219
        object Button1: TButton
          Left = 0
          Top = 0
          Width = 213
          Height = 33
          Caption = #1573#1593#1583#1575#1583#1575#1578' '#1605#1582#1583#1605' '#1602#1575#1593#1583#1577' '#1575#1604#1576#1610#1575#1606#1575#1578
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button5: TButton
          Left = 0
          Top = 50
          Width = 213
          Height = 33
          Caption = #1590#1576#1591' '#1573#1593#1583#1575#1583#1575#1578' '#1580#1583#1575#1585' '#1575#1604#1581#1605#1575#1610#1577
          TabOrder = 1
          OnClick = Button5Click
        end
        object cxButton2: TcxButton
          Left = 0
          Top = 99
          Width = 213
          Height = 33
          Caption = #1575#1604#1582#1583#1605#1577': '#1594#1610#1585' '#1605#1579#1576#1578#1577
          DropDownMenu = PopupMenu2
          Kind = cxbkDropDown
          PopupAlignment = paCenter
          TabOrder = 2
          OnDropDownMenuPopup = cxButton2DropDownMenuPopup
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1575#1604#1573#1593#1583#1575#1583#1575#1578' '#1575#1604#1593#1575#1605#1577
      ImageIndex = 0
      object cxGroupBox4: TcxGroupBox
        Left = 0
        Top = 0
        Align = alClient
        PanelStyle.Active = True
        Style.BorderStyle = ebsNone
        TabOrder = 0
        DesignSize = (
          1089
          486)
        Height = 486
        Width = 1089
        object Label10: TLabel
          Left = 666
          Top = 45
          Width = 37
          Height = 15
          Caption = #1575#1604#1605#1576#1610#1593#1575#1578':'
        end
        object Label1: TLabel
          Left = 666
          Top = 74
          Width = 67
          Height = 15
          Caption = #1605#1585#1578#1580#1593' '#1575#1604#1605#1576#1610#1593#1575#1578':'
        end
        object Label4: TLabel
          Left = 274
          Top = 74
          Width = 42
          Height = 15
          Caption = #1581'. '#1605#1605#1606#1608#1581':'
        end
        object Label5: TLabel
          Left = 666
          Top = 208
          Width = 46
          Height = 15
          Caption = #1587#1606#1583' '#1575#1604#1602#1576#1590':'
        end
        object Label6: TLabel
          Left = 274
          Top = 45
          Width = 45
          Height = 15
          Caption = #1581'. '#1605#1603#1578#1587#1576':'
        end
        object Label8: TLabel
          Left = 666
          Top = 238
          Width = 39
          Height = 15
          Caption = #1587#1606#1583' '#1575#1604#1583#1601#1593':'
        end
        object Label12: TLabel
          Left = 1026
          Top = 44
          Width = 33
          Height = 15
          Caption = #1575#1604#1593#1606#1608#1575#1606':'
        end
        object Label17: TLabel
          Left = 666
          Top = 103
          Width = 51
          Height = 15
          Caption = #1593#1585#1590' '#1587#1593#1585':'
        end
        object Label18: TLabel
          Left = 666
          Top = 132
          Width = 52
          Height = 15
          Caption = #1605#1581#1590#1585' '#1580#1585#1583':'
        end
        object Label11: TLabel
          Left = 274
          Top = 208
          Width = 27
          Height = 15
          Caption = #1575#1604#1593#1605#1604#1577':'
        end
        object Label9: TLabel
          Left = 666
          Top = 269
          Width = 48
          Height = 15
          Caption = #1587#1606#1583' '#1575#1604#1610#1608#1605#1610#1577':'
        end
        object Label7: TLabel
          Left = 274
          Top = 103
          Width = 76
          Height = 15
          Caption = #1581#1587#1575#1576' '#1575#1604#1605#1589#1575#1585#1610#1601':'
        end
        object Label13: TLabel
          Left = 1026
          Top = 139
          Width = 30
          Height = 15
          Anchors = [akTop, akRight]
          Caption = #1575#1604#1588#1593#1575#1585':'
        end
        object Label14: TLabel
          Left = 591
          Top = 335
          Width = 42
          Height = 15
          Caption = #1575#1604#1578#1585#1582#1610#1589':'
        end
        object Label16: TLabel
          Left = 992
          Top = 335
          Width = 59
          Height = 15
          Caption = #1605#1593#1585#1601' '#1575#1604#1580#1607#1575#1586':'
        end
        object Label19: TLabel
          Left = 274
          Top = 132
          Width = 58
          Height = 15
          Caption = #1575#1604#1586#1576#1608#1606' '#1575#1604#1606#1602#1583#1610':'
        end
        object Label20: TLabel
          Left = 274
          Top = 238
          Width = 71
          Height = 15
          Caption = #1578#1581#1583#1610#1579' '#1575#1604#1605#1608#1575#1583' '#1603#1604':'
        end
        object Label21: TLabel
          Left = 42
          Top = 238
          Width = 18
          Height = 15
          Caption = #1583#1602#1610#1602#1577
        end
        object dxBevel1: TdxBevel
          Left = 413
          Top = 23
          Width = 262
          Height = 17
          Shape = dxbsLineTop
        end
        object Label2: TLabel
          Left = 678
          Top = 18
          Width = 55
          Height = 15
          Caption = #1571#1606#1605#1575#1591' '#1575#1604#1601#1608#1575#1578#1610#1585
        end
        object Label3: TLabel
          Left = 676
          Top = 188
          Width = 57
          Height = 15
          Caption = #1571#1606#1605#1575#1591' '#1575#1604#1587#1606#1583#1575#1578
        end
        object dxBevel2: TdxBevel
          Left = 413
          Top = 194
          Width = 258
          Height = 17
          Shape = dxbsLineTop
        end
        object Label22: TLabel
          Left = 353
          Top = 18
          Width = 38
          Height = 15
          Caption = #1575#1604#1581#1587#1575#1576#1575#1578
        end
        object dxBevel3: TdxBevel
          Left = 21
          Top = 23
          Width = 330
          Height = 17
          Shape = dxbsLineTop
        end
        object Label23: TLabel
          Left = 333
          Top = 188
          Width = 58
          Height = 15
          Caption = #1582#1610#1575#1585#1575#1578' '#1571#1582#1585#1609
        end
        object dxBevel4: TdxBevel
          Left = 21
          Top = 194
          Width = 306
          Height = 17
          Shape = dxbsLineTop
        end
        object Label24: TLabel
          Left = 993
          Top = 18
          Width = 75
          Height = 15
          Caption = #1605#1593#1604#1608#1605#1575#1578' '#1575#1604#1605#1572#1587#1587#1577
        end
        object dxBevel5: TdxBevel
          Left = 765
          Top = 23
          Width = 222
          Height = 14
          Shape = dxbsLineTop
        end
        object Label25: TLabel
          Left = 1029
          Top = 313
          Width = 39
          Height = 15
          Caption = #1575#1604#1578#1585#1582#1610#1589
        end
        object dxBevel6: TdxBevel
          Left = 21
          Top = 320
          Width = 1004
          Height = 17
          Shape = dxbsLineTop
        end
        object Label15: TLabel
          Left = 81
          Top = 363
          Width = 197
          Height = 21
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cxDBLookupComboBox4: TcxDBLookupComboBox
          Left = 418
          Top = 41
          DataBinding.DataField = 'SellType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrBillTypeSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 0
          Width = 242
        end
        object cxDBLookupComboBox9: TcxDBLookupComboBox
          Left = 418
          Top = 70
          DataBinding.DataField = 'ReturnType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrBillTypeSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 1
          Width = 242
        end
        object cxDBLookupComboBox2: TcxDBLookupComboBox
          Left = 42
          Top = 70
          DataBinding.DataField = 'DiscAcc'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrAccountsSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 2
          Width = 225
        end
        object cxDBLookupComboBox3: TcxDBLookupComboBox
          Left = 410
          Top = 205
          DataBinding.DataField = 'PayInType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrPayTypesSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 3
          Width = 242
        end
        object cxDBLookupComboBox5: TcxDBLookupComboBox
          Left = 42
          Top = 41
          DataBinding.DataField = 'Disc2Acc'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrAccountsSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 4
          Width = 225
        end
        object cxDBLookupComboBox11: TcxDBLookupComboBox
          Left = 410
          Top = 235
          DataBinding.DataField = 'PayOutType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrPayTypesSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 5
          Width = 242
        end
        object cxDBLookupComboBox6: TcxDBLookupComboBox
          Left = 418
          Top = 99
          DataBinding.DataField = 'PriceType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrBillTypeSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 6
          Width = 242
        end
        object cxDBLookupComboBox7: TcxDBLookupComboBox
          Left = 418
          Top = 128
          DataBinding.DataField = 'StockType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrBillTypeSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 7
          Width = 242
        end
        object cxDBLookupComboBox1: TcxDBLookupComboBox
          Left = 42
          Top = 205
          DataBinding.DataField = 'Currency'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrCurrSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 8
          Width = 225
        end
        object cxDBLookupComboBox12: TcxDBLookupComboBox
          Left = 410
          Top = 266
          DataBinding.DataField = 'DayType'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrPayTypesSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 9
          Width = 242
        end
        object cxDBLookupComboBox10: TcxDBLookupComboBox
          Left = 42
          Top = 99
          DataBinding.DataField = 'SpendAcc'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrAccountsSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 10
          Width = 225
        end
        object cxDBImage1: TcxDBImage
          Left = 870
          Top = 139
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          DataBinding.DataField = 'CompLogo'
          DataBinding.DataSource = EData.settingsSrc
          Properties.GraphicClassName = 'TdxSmartImage'
          Properties.PopupMenuLayout.MenuItems = []
          Properties.ReadOnly = True
          Properties.ShowFocusRect = False
          TabOrder = 11
          OnClick = cxDBImage1Click
          Height = 150
          Width = 150
        end
        object cxDBMemo1: TcxDBMemo
          Left = 301
          Top = 332
          TabStop = False
          BiDiMode = bdLeftToRight
          DataBinding.DataField = 'Lic'
          DataBinding.DataSource = EData.settingsSrc
          ParentBiDiMode = False
          Properties.ReadOnly = True
          TabOrder = 12
          Height = 90
          Width = 284
        end
        object Button3: TButton
          Left = 591
          Top = 356
          Width = 42
          Height = 28
          Caption = #1604#1589#1602
          TabOrder = 13
          OnClick = Button3Click
        end
        object cxMemo1: TcxMemo
          Left = 703
          Top = 332
          BiDiMode = bdLeftToRight
          Lines.Strings = (
            'cxMemo1')
          ParentBiDiMode = False
          Properties.ReadOnly = True
          TabOrder = 14
          Height = 90
          Width = 284
        end
        object Button4: TButton
          Left = 992
          Top = 356
          Width = 59
          Height = 28
          Caption = #1606#1587#1582
          TabOrder = 15
          OnClick = Button4Click
        end
        object cxDBLookupComboBox8: TcxDBLookupComboBox
          Left = 42
          Top = 128
          DataBinding.DataField = 'DefaultPayedAccount'
          DataBinding.DataSource = EData.settingsSrc
          Properties.ImmediatePost = True
          Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = EData.mnrClientsSrc
          Properties.UseLeftAlignmentOnEditing = False
          TabOrder = 16
          Width = 225
        end
        object cxDBSpinEdit1: TcxDBSpinEdit
          Left = 66
          Top = 234
          DataBinding.DataField = 'MatUpdateInterval'
          DataBinding.DataSource = EData.settingsSrc
          Properties.Alignment.Horz = taLeftJustify
          Properties.SpinButtons.Visible = False
          Properties.UseCtrlIncrement = True
          Properties.UseLeftAlignmentOnEditing = False
          Properties.ZeroIncrement = True
          Properties.ZeroLargeIncrement = True
          TabOrder = 17
          Width = 201
        end
        object cxDBMemo2: TcxDBMemo
          Left = 773
          Top = 41
          DataBinding.DataField = 'CompAddress'
          DataBinding.DataSource = EData.settingsSrc
          TabOrder = 18
          Height = 89
          Width = 247
        end
        object Button2: TButton
          Left = 546
          Top = 438
          Width = 112
          Height = 30
          Caption = #1581#1601#1592' '#1575#1604#1578#1594#1610#1610#1585#1575#1578
          TabOrder = 19
          OnClick = Button2Click
        end
        object Button6: TButton
          Left = 418
          Top = 438
          Width = 108
          Height = 30
          Caption = #1573#1604#1594#1575#1569' '#1575#1604#1578#1594#1610#1610#1585#1575#1578
          TabOrder = 20
          OnClick = Button6Click
        end
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1575#1604#1605#1587#1578#1582#1583#1605#1610#1606
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGroupBox1: TcxGroupBox
        Left = 0
        Top = 0
        Align = alTop
        PanelStyle.Active = True
        Style.BorderStyle = ebsNone
        TabOrder = 0
        Height = 585
        Width = 1089
        object cxPageControl2: TcxPageControl
          Left = 2
          Top = 8
          Width = 824
          Height = 433
          TabOrder = 0
          Properties.ActivePage = cxTabSheet4
          Properties.CustomButtons.Buttons = <>
          OnPageChanging = cxPageControl2PageChanging
          ClientRectBottom = 429
          ClientRectLeft = 4
          ClientRectRight = 820
          ClientRectTop = 26
          object cxTabSheet4: TcxTabSheet
            Caption = #1576#1610#1575#1606#1575#1578' '#1575#1604#1583#1582#1608#1604' '#1608#1575#1604#1589#1604#1575#1581#1610#1575#1578
            ImageIndex = 0
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Label26: TLabel
              Left = 621
              Top = 70
              Width = 56
              Height = 15
              Caption = #1575#1587#1605' '#1575#1604#1605#1587#1578#1582#1583#1605':'
            end
            object Label27: TLabel
              Left = 621
              Top = 102
              Width = 53
              Height = 15
              Caption = #1603#1604#1605#1577' '#1575#1604#1605#1585#1608#1585':'
            end
            object Label28: TLabel
              Left = 621
              Top = 264
              Width = 47
              Height = 15
              Caption = #1581#1602#1604' '#1575#1604#1587#1593#1585':'
            end
            object Label29: TLabel
              Left = 621
              Top = 167
              Width = 24
              Height = 15
              Caption = #1575#1604#1576#1575#1574#1593':'
            end
            object Label30: TLabel
              Left = 621
              Top = 134
              Width = 39
              Height = 15
              Caption = #1575#1604#1605#1587#1578#1582#1583#1605':'
            end
            object Label31: TLabel
              Left = 621
              Top = 232
              Width = 50
              Height = 15
              Caption = #1605#1585#1603#1586' '#1575#1604#1603#1604#1601#1577':'
            end
            object Label32: TLabel
              Left = 621
              Top = 199
              Width = 41
              Height = 15
              Caption = #1575#1604#1605#1587#1578#1608#1583#1593':'
            end
            object Label33: TLabel
              Left = 621
              Top = 293
              Width = 52
              Height = 15
              Caption = #1578#1593#1583#1610#1604' '#1575#1604#1587#1593#1585':'
            end
            object Label34: TLabel
              Left = 239
              Top = 152
              Width = 53
              Height = 15
              Caption = #1575#1604#1603#1605#1610#1577' '#1581#1587#1576':'
            end
            object cxDBTextEdit1: TcxDBTextEdit
              Left = 464
              Top = 66
              DataBinding.DataField = 'Name'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 0
              Width = 150
            end
            object cxDBTextEdit2: TcxDBTextEdit
              Left = 464
              Top = 98
              DataBinding.DataField = 'Password'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.EchoMode = eemPassword
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 1
              Width = 150
            end
            object cxComboBox1: TcxDBComboBox
              Left = 464
              Top = 260
              DataBinding.DataField = 'PriceField'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.DropDownListStyle = lsFixedList
              Properties.Items.Strings = (
                #1575#1604#1605#1587#1578#1607#1604#1603
                #1575#1604#1578#1608#1586#1610#1593
                #1575#1604#1593#1575#1605
                #1575#1604#1608#1603#1610#1604
                #1575#1604#1575#1587#1578#1610#1585#1575#1583
                #1575#1604#1578#1589#1583#1610#1585
                #1575#1604#1605#1601#1585#1602
                #1575#1604#1580#1605#1604#1577)
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 6
              Width = 150
            end
            object cxDBLookupComboBox13: TcxDBLookupComboBox
              Left = 464
              Top = 163
              DataBinding.DataField = 'Saleman'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
              Properties.KeyFieldNames = 'ID'
              Properties.ListColumns = <
                item
                  FieldName = 'Name'
                end>
              Properties.ListOptions.ShowHeader = False
              Properties.ListSource = EData.mnrSaleManSrc
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 3
              Width = 150
            end
            object cxDBLookupComboBox14: TcxDBLookupComboBox
              Left = 464
              Top = 130
              DataBinding.DataField = 'mnrUser'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
              Properties.KeyFieldNames = 'ID'
              Properties.ListColumns = <
                item
                  FieldName = 'Name'
                end>
              Properties.ListOptions.ShowHeader = False
              Properties.ListSource = EData.mnrUsersSrc
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 2
              Width = 150
            end
            object cxDBLookupComboBox15: TcxDBLookupComboBox
              Left = 464
              Top = 195
              DataBinding.DataField = 'Store'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
              Properties.KeyFieldNames = 'ID'
              Properties.ListColumns = <
                item
                  FieldName = 'Name'
                end>
              Properties.ListOptions.ShowHeader = False
              Properties.ListSource = EData.mnrStoreSrc
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 4
              Width = 150
            end
            object cxDBLookupComboBox16: TcxDBLookupComboBox
              Left = 464
              Top = 228
              DataBinding.DataField = 'CostCenter'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
              Properties.KeyFieldNames = 'ID'
              Properties.ListColumns = <
                item
                  FieldName = 'Name'
                end>
              Properties.ListOptions.ShowHeader = False
              Properties.ListSource = EData.mnrCostSrc
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 5
              Width = 150
            end
            object cxDBCheckBox1: TcxDBCheckBox
              Left = 319
              Top = 66
              AutoSize = False
              Caption = #1605#1576#1610#1593#1575#1578
              DataBinding.DataField = 'pBill'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 8
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox2: TcxDBCheckBox
              Left = 319
              Top = 85
              AutoSize = False
              Caption = #1605#1585#1578#1580#1593' '#1575#1604#1605#1576#1610#1593#1575#1578
              DataBinding.DataField = 'pReturn'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 9
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox3: TcxDBCheckBox
              Left = 319
              Top = 152
              AutoSize = False
              Caption = #1602#1576#1590
              DataBinding.DataField = 'pPayIn'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 12
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox4: TcxDBCheckBox
              Left = 319
              Top = 171
              AutoSize = False
              Caption = #1583#1601#1593
              DataBinding.DataField = 'pPayOut'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 13
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox5: TcxDBCheckBox
              Left = 319
              Top = 224
              AutoSize = False
              Caption = #1581#1587#1605' '#1605#1605#1606#1608#1581
              DataBinding.DataField = 'pDiscOut'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 15
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox6: TcxDBCheckBox
              Left = 319
              Top = 243
              AutoSize = False
              Caption = #1581#1587#1605' '#1605#1603#1578#1587#1576
              DataBinding.DataField = 'pDiscIn'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 16
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox7: TcxDBCheckBox
              Left = 319
              Top = 205
              AutoSize = False
              Caption = #1605#1589#1585#1608#1601
              DataBinding.DataField = 'pSpent'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 14
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox8: TcxDBCheckBox
              Left = 319
              Top = 104
              AutoSize = False
              Caption = #1593#1585#1590' '#1587#1593#1585
              DataBinding.DataField = 'pPrice'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 10
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox9: TcxDBCheckBox
              Left = 319
              Top = 123
              AutoSize = False
              Caption = #1605#1581#1590#1585' '#1580#1585#1583
              DataBinding.DataField = 'pStock'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 11
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox10: TcxDBCheckBox
              Left = 319
              Top = 273
              AutoSize = False
              Caption = #1603#1588#1601' '#1581#1587#1575#1576
              DataBinding.DataField = 'pCustReport'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 17
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox11: TcxDBCheckBox
              Left = 319
              Top = 293
              AutoSize = False
              Caption = #1583#1601#1578#1585' '#1575#1604#1571#1587#1578#1575#1584
              DataBinding.DataField = 'pGLedger'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 18
              Transparent = True
              Height = 19
              Width = 100
            end
            object cxDBCheckBox12: TcxDBCheckBox
              Left = 142
              Top = 66
              AutoSize = False
              Caption = #1593#1585#1590' '#1580#1605#1610#1593' '#1575#1604#1581#1587#1575#1576#1575#1578
              DataBinding.DataField = 'pAllAcc'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 19
              Transparent = True
              Height = 19
              Width = 150
            end
            object cxDBCheckBox13: TcxDBCheckBox
              Left = 142
              Top = 85
              AutoSize = False
              Caption = #1606#1602#1591#1577' '#1576#1610#1593' '#1601#1602#1591
              DataBinding.DataField = 'pOnlyPOS'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 20
              Transparent = True
              Height = 19
              Width = 150
            end
            object cxComboBox2: TcxDBComboBox
              Left = 465
              Top = 289
              DataBinding.DataField = 'pEditPrice'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.DropDownListStyle = lsFixedList
              Properties.Items.Strings = (
                #1605#1605#1603#1606
                #1604#1604#1571#1593#1604#1609' '#1601#1602#1591
                #1604#1575' '#1610#1605#1603#1606)
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 7
              Width = 150
            end
            object cxComboBox3: TcxDBComboBox
              Left = 139
              Top = 149
              DataBinding.DataField = 'pQuantityType'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment.Horz = taLeftJustify
              Properties.DropDownListStyle = lsFixedList
              Properties.Items.Strings = (
                #1605#1587#1578#1608#1583#1593' '#1575#1604#1605#1587#1578#1582#1583#1605
                #1580#1605#1610#1593' '#1575#1604#1605#1587#1578#1608#1583#1593#1575#1578)
              Properties.UseLeftAlignmentOnEditing = False
              TabOrder = 23
              Width = 94
            end
            object cxDBCheckBox14: TcxDBCheckBox
              Left = 142
              Top = 123
              AutoSize = False
              Caption = #1593#1583#1605' '#1593#1585#1590' '#1575#1604#1605#1608#1575#1583' '#1594#1610#1585' '#1575#1604#1605#1578#1608#1601#1585#1577
              DataBinding.DataField = 'pOnlyAvailable'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 22
              Transparent = True
              Height = 19
              Width = 150
            end
            object cxDBCheckBox15: TcxDBCheckBox
              Left = 142
              Top = 104
              AutoSize = False
              Caption = #1589#1604#1575#1581#1610#1577' '#1604#1603#1604' '#1575#1604#1605#1608#1575#1583
              DataBinding.DataField = 'pAllMat'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 21
              Transparent = True
              Height = 19
              Width = 150
            end
            object cxDBCheckBox16: TcxDBCheckBox
              Left = 143
              Top = 205
              AutoSize = False
              Caption = #1593#1585#1590' '#1587#1593#1585' '#1575#1604#1603#1604#1601#1577
              DataBinding.DataField = 'pShowCost'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 24
              Transparent = True
              Height = 19
              Width = 149
            end
            object cxDBCheckBox17: TcxDBCheckBox
              Left = 143
              Top = 224
              AutoSize = False
              Caption = #1593#1585#1590' '#1575#1604#1580#1608#1583#1577
              DataBinding.DataField = 'pShowQuality'
              DataBinding.DataSource = EData.UsersSrc
              Properties.Alignment = taLeftJustify
              Style.TransparentBorder = False
              TabOrder = 25
              Transparent = True
              Height = 19
              Width = 149
            end
          end
          object cxTabSheet5: TcxTabSheet
            Caption = #1575#1604#1605#1608#1575#1583
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object cxGrid4: TcxGrid
              Left = 415
              Top = 42
              Width = 250
              Height = 350
              TabOrder = 0
              OnEnter = cxGrid4Enter
              object cxGridDBTableView3: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                FilterBox.Visible = fvNever
                ScrollbarAnnotations.CustomAnnotations = <>
                DataController.DataSource = GroupsSrc
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                FilterRow.SeparatorWidth = 8
                FixedDataRows.SeparatorWidth = 8
                NewItemRow.SeparatorWidth = 8
                OptionsBehavior.FocusCellOnTab = True
                OptionsBehavior.FocusFirstCellOnNewRecord = True
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsCustomize.ColumnHidingOnGrouping = False
                OptionsData.Appending = True
                OptionsData.DeletingConfirmation = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.NavigatorOffset = 63
                OptionsView.NoDataToDisplayInfoText = ' '
                OptionsView.FixedColumnSeparatorWidth = 3
                OptionsView.GroupByBox = False
                Preview.LeftIndent = 25
                Preview.RightIndent = 6
                RowLayout.MinValueWidth = 100
                object cxGridDBColumn3: TcxGridDBColumn
                  DataBinding.FieldName = 'UserID'
                  Visible = False
                  VisibleForCustomization = False
                end
                object cxGridDBColumn4: TcxGridDBColumn
                  Caption = #1605#1580#1605#1608#1593#1575#1578' '#1575#1604#1605#1608#1575#1583
                  DataBinding.FieldName = 'GroupID'
                  PropertiesClassName = 'TcxLookupComboBoxProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
                  Properties.KeyFieldNames = 'ID'
                  Properties.ListColumns = <
                    item
                      FieldName = 'Name'
                    end>
                  Properties.ListOptions.ShowHeader = False
                  Properties.ListSource = EData.mnrGroupsSrc
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Options.SortByDisplayText = isbtOn
                  Width = 240
                end
              end
              object cxGridLevel3: TcxGridLevel
                GridView = cxGridDBTableView3
              end
            end
            object cxGrid2: TcxGrid
              Left = 149
              Top = 42
              Width = 250
              Height = 350
              TabOrder = 1
              OnEnter = cxGrid2Enter
              object cxGridDBTableView2: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                FilterBox.Visible = fvNever
                ScrollbarAnnotations.CustomAnnotations = <>
                DataController.DataSource = MaterialsSrc
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                FilterRow.SeparatorWidth = 8
                FixedDataRows.SeparatorWidth = 8
                NewItemRow.SeparatorWidth = 8
                OptionsBehavior.FocusCellOnTab = True
                OptionsBehavior.FocusFirstCellOnNewRecord = True
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsCustomize.ColumnHidingOnGrouping = False
                OptionsData.Appending = True
                OptionsData.DeletingConfirmation = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.NavigatorOffset = 63
                OptionsView.NoDataToDisplayInfoText = ' '
                OptionsView.FixedColumnSeparatorWidth = 3
                OptionsView.GroupByBox = False
                Preview.LeftIndent = 25
                Preview.RightIndent = 6
                RowLayout.MinValueWidth = 100
                object cxGridDBColumn1: TcxGridDBColumn
                  DataBinding.FieldName = 'UserID'
                  Visible = False
                  VisibleForCustomization = False
                end
                object cxGridDBColumn2: TcxGridDBColumn
                  Caption = #1575#1604#1605#1608#1575#1583
                  DataBinding.FieldName = 'MatID'
                  PropertiesClassName = 'TcxLookupComboBoxProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
                  Properties.KeyFieldNames = 'ID'
                  Properties.ListColumns = <
                    item
                      FieldName = 'Name'
                    end>
                  Properties.ListOptions.ShowHeader = False
                  Properties.ListSource = EData.mnrMaterialsSrc
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Options.SortByDisplayText = isbtOn
                  Width = 240
                end
              end
              object cxGridLevel2: TcxGridLevel
                GridView = cxGridDBTableView2
              end
            end
            object cxButton12: TcxButton
              Left = 605
              Top = 10
              Width = 30
              Height = 30
              Caption = '-'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 2
              OnClick = cxButton12Click
            end
            object cxButton13: TcxButton
              Left = 635
              Top = 10
              Width = 30
              Height = 30
              Caption = '+'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 3
              OnClick = cxButton13Click
            end
            object cxButton14: TcxButton
              Left = 339
              Top = 10
              Width = 30
              Height = 30
              Caption = '-'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 4
              OnClick = cxButton14Click
            end
            object cxButton15: TcxButton
              Left = 369
              Top = 10
              Width = 30
              Height = 30
              Caption = '+'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 5
              OnClick = cxButton15Click
            end
          end
          object cxTabSheet6: TcxTabSheet
            Caption = #1575#1604#1581#1587#1575#1576#1575#1578
            ImageIndex = 2
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object cxGrid5: TcxGrid
              Left = 1
              Top = 42
              Width = 300
              Height = 350
              TabOrder = 0
              OnEnter = cxGrid5Enter
              object cxGridDBTableView4: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                FilterBox.Visible = fvNever
                ScrollbarAnnotations.CustomAnnotations = <>
                DataController.DataSource = PayTypesSrc
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                FilterRow.SeparatorWidth = 8
                FixedDataRows.SeparatorWidth = 8
                NewItemRow.SeparatorWidth = 8
                OptionsBehavior.FocusCellOnTab = True
                OptionsBehavior.FocusFirstCellOnNewRecord = True
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsCustomize.ColumnHidingOnGrouping = False
                OptionsData.Appending = True
                OptionsData.DeletingConfirmation = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.NavigatorOffset = 63
                OptionsView.NoDataToDisplayInfoText = ' '
                OptionsView.FixedColumnSeparatorWidth = 3
                OptionsView.GroupByBox = False
                Preview.LeftIndent = 25
                Preview.RightIndent = 6
                RowLayout.MinValueWidth = 100
                object cxGridDBTableView4ID: TcxGridDBColumn
                  DataBinding.FieldName = 'ID'
                  Visible = False
                  VisibleForCustomization = False
                end
                object cxGridDBTableView4Name: TcxGridDBColumn
                  Caption = #1606#1608#1593' '#1575#1604#1583#1601#1593
                  DataBinding.FieldName = 'Name'
                  PropertiesClassName = 'TcxTextEditProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Width = 100
                end
                object cxGridDBTableView4Account: TcxGridDBColumn
                  Caption = #1575#1604#1581#1587#1575#1576
                  DataBinding.FieldName = 'Account'
                  PropertiesClassName = 'TcxLookupComboBoxProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
                  Properties.KeyFieldNames = 'ID'
                  Properties.ListColumns = <
                    item
                      FieldName = 'Name'
                    end>
                  Properties.ListOptions.ShowHeader = False
                  Properties.ListSource = EData.mnrAccountsSrc
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Width = 190
                end
                object cxGridDBTableView4UserID: TcxGridDBColumn
                  DataBinding.FieldName = 'UserID'
                  Visible = False
                  VisibleForCustomization = False
                end
              end
              object cxGridLevel4: TcxGridLevel
                GridView = cxGridDBTableView4
              end
            end
            object cxGrid3: TcxGrid
              Left = 566
              Top = 42
              Width = 250
              Height = 350
              TabOrder = 1
              OnEnter = cxGrid3Enter
              object cxGridDBTableView1: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                FilterBox.Visible = fvNever
                ScrollbarAnnotations.CustomAnnotations = <>
                DataController.DataSource = ClientsSrc
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                FilterRow.SeparatorWidth = 8
                FixedDataRows.SeparatorWidth = 8
                NewItemRow.SeparatorWidth = 8
                OptionsBehavior.FocusCellOnTab = True
                OptionsBehavior.FocusFirstCellOnNewRecord = True
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsCustomize.ColumnHidingOnGrouping = False
                OptionsData.Appending = True
                OptionsData.DeletingConfirmation = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.NavigatorOffset = 63
                OptionsView.NoDataToDisplayInfoText = ' '
                OptionsView.FixedColumnSeparatorWidth = 3
                OptionsView.GroupByBox = False
                Preview.LeftIndent = 25
                Preview.RightIndent = 6
                RowLayout.MinValueWidth = 100
                object cxGridDBTableView1UserID: TcxGridDBColumn
                  DataBinding.FieldName = 'UserID'
                  Visible = False
                  VisibleForCustomization = False
                end
                object cxGridDBTableView1ClientID: TcxGridDBColumn
                  Caption = #1575#1604#1586#1576#1575#1574#1606
                  DataBinding.FieldName = 'ClientID'
                  PropertiesClassName = 'TcxLookupComboBoxProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
                  Properties.KeyFieldNames = 'ID'
                  Properties.ListColumns = <
                    item
                      FieldName = 'Name'
                    end>
                  Properties.ListOptions.ShowHeader = False
                  Properties.ListSource = EData.mnrAccountsSrc
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Options.SortByDisplayText = isbtOn
                  Width = 288
                end
              end
              object cxGridLevel1: TcxGridLevel
                GridView = cxGridDBTableView1
              end
            end
            object cxGrid6: TcxGrid
              Left = 310
              Top = 42
              Width = 250
              Height = 350
              TabOrder = 2
              OnEnter = cxGrid6Enter
              object cxGridDBTableView5: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                FilterBox.Visible = fvNever
                ScrollbarAnnotations.CustomAnnotations = <>
                DataController.DataSource = AccountsSrc
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                FilterRow.SeparatorWidth = 8
                FixedDataRows.SeparatorWidth = 8
                NewItemRow.SeparatorWidth = 8
                OptionsBehavior.FocusCellOnTab = True
                OptionsBehavior.FocusFirstCellOnNewRecord = True
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsCustomize.ColumnHidingOnGrouping = False
                OptionsData.Appending = True
                OptionsData.DeletingConfirmation = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.NavigatorOffset = 63
                OptionsView.NoDataToDisplayInfoText = ' '
                OptionsView.FixedColumnSeparatorWidth = 3
                OptionsView.GroupByBox = False
                Preview.LeftIndent = 25
                Preview.RightIndent = 6
                RowLayout.MinValueWidth = 100
                object cxGridDBColumn5: TcxGridDBColumn
                  DataBinding.FieldName = 'UserID'
                  Visible = False
                  VisibleForCustomization = False
                end
                object cxGridDBColumn6: TcxGridDBColumn
                  Caption = #1575#1604#1581#1587#1575#1576#1575#1578
                  DataBinding.FieldName = 'AccountID'
                  PropertiesClassName = 'TcxLookupComboBoxProperties'
                  Properties.Alignment.Horz = taLeftJustify
                  Properties.IncrementalFilteringOptions = [ifoUseContainsOperator]
                  Properties.KeyFieldNames = 'ID'
                  Properties.ListColumns = <
                    item
                      FieldName = 'Name'
                    end>
                  Properties.ListOptions.ShowHeader = False
                  Properties.ListSource = EData.mnrAccountsSrc
                  Properties.UseLeftAlignmentOnEditing = False
                  HeaderAlignmentHorz = taCenter
                  Options.SortByDisplayText = isbtOn
                  Width = 286
                end
              end
              object cxGridLevel5: TcxGridLevel
                GridView = cxGridDBTableView5
              end
            end
            object cxButton3: TcxButton
              Left = 786
              Top = 10
              Width = 30
              Height = 30
              Caption = '+'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 3
              OnClick = cxButton3Click
            end
            object cxButton7: TcxButton
              Left = 756
              Top = 10
              Width = 30
              Height = 30
              Caption = '-'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 4
              OnClick = cxButton7Click
            end
            object cxButton8: TcxButton
              Left = 500
              Top = 10
              Width = 30
              Height = 30
              Caption = '-'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 5
              OnClick = cxButton8Click
            end
            object cxButton9: TcxButton
              Left = 530
              Top = 10
              Width = 30
              Height = 30
              Caption = '+'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 6
              OnClick = cxButton9Click
            end
            object cxButton10: TcxButton
              Left = 241
              Top = 10
              Width = 30
              Height = 30
              Caption = '-'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 7
              OnClick = cxButton10Click
            end
            object cxButton11: TcxButton
              Left = 271
              Top = 10
              Width = 30
              Height = 30
              Caption = '+'
              SpeedButtonOptions.CanBeFocused = False
              TabOrder = 8
              OnClick = cxButton11Click
            end
          end
        end
        object cxGrid1: TcxGrid
          Left = 832
          Top = 8
          Width = 250
          Height = 433
          TabOrder = 1
          OnEnter = cxGrid1Enter
          object cxGrid1DBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            OnFocusedRecordChanged = cxGrid1DBTableView1FocusedRecordChanged
            DataController.DataSource = EData.UsersSrc
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            FilterRow.SeparatorWidth = 8
            FixedDataRows.SeparatorWidth = 8
            NewItemRow.SeparatorWidth = 8
            OptionsBehavior.FocusCellOnTab = True
            OptionsBehavior.FocusFirstCellOnNewRecord = True
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsSelection.CellSelect = False
            OptionsSelection.HideFocusRectOnExit = False
            OptionsSelection.UnselectFocusedRecordOnExit = False
            OptionsView.NavigatorOffset = 63
            OptionsView.NoDataToDisplayInfoText = ' '
            OptionsView.FixedColumnSeparatorWidth = 3
            OptionsView.GroupByBox = False
            Preview.LeftIndent = 25
            Preview.RightIndent = 6
            RowLayout.MinValueWidth = 100
            object cxGrid1DBTableView1ID: TcxGridDBColumn
              DataBinding.FieldName = 'ID'
              Visible = False
              VisibleForCustomization = False
            end
            object cxGrid1DBTableView1Name: TcxGridDBColumn
              Caption = #1575#1587#1605' '#1575#1604#1605#1587#1578#1582#1583#1605
              DataBinding.FieldName = 'Name'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Horz = taLeftJustify
              Properties.UseLeftAlignmentOnEditing = False
              HeaderAlignmentHorz = taCenter
              Width = 240
            end
          end
          object cxGrid1Level1: TcxGridLevel
            GridView = cxGrid1DBTableView1
          end
        end
      end
      object cxButton1: TcxButton
        Left = 982
        Top = 447
        Width = 100
        Height = 30
        Caption = #1580#1583#1610#1583
        TabOrder = 1
        OnClick = cxButton1Click
      end
      object cxButton4: TcxButton
        Left = 876
        Top = 447
        Width = 100
        Height = 30
        Caption = #1581#1584#1601
        TabOrder = 2
        OnClick = cxButton4Click
      end
      object cxButton5: TcxButton
        Left = 456
        Top = 447
        Width = 122
        Height = 30
        Caption = #1581#1601#1592' '#1575#1604#1578#1594#1610#1610#1585#1575#1578
        TabOrder = 3
        OnClick = cxButton5Click
      end
      object cxButton6: TcxButton
        Left = 326
        Top = 447
        Width = 116
        Height = 30
        Caption = #1573#1604#1594#1575#1569' '#1575#1604#1578#1594#1610#1610#1585#1575#1578
        TabOrder = 4
        OnClick = cxButton6Click
      end
    end
  end
  object Clients: TUniQuery
    Connection = EData.db
    SQL.Strings = (
      'select * from UserClients where UserID=:id')
    AfterInsert = ClientsAfterInsert
    BeforePost = ClientsBeforePost
    Left = 776
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = Null
      end>
    object ClientsID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object ClientsUserID: TGuidField
      FieldName = 'UserID'
      Size = 38
    end
    object ClientsClientID: TGuidField
      FieldName = 'ClientID'
      FixedChar = True
      Size = 38
    end
  end
  object ClientsSrc: TUniDataSource
    DataSet = Clients
    Left = 464
    Top = 40
  end
  object Materials: TUniQuery
    Connection = EData.db
    SQL.Strings = (
      'select * from UserMaterials where UserID=:id')
    AfterInsert = MaterialsAfterInsert
    BeforePost = MaterialsBeforePost
    Left = 280
    Top = 344
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = Null
      end>
    object MaterialsID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object MaterialsUserID: TGuidField
      FieldName = 'UserID'
      Size = 38
    end
    object MaterialsMatID: TGuidField
      FieldName = 'MatID'
      FixedChar = True
      Size = 38
    end
  end
  object MaterialsSrc: TUniDataSource
    DataSet = Materials
    Left = 280
    Top = 408
  end
  object Groups: TUniQuery
    Connection = EData.db
    SQL.Strings = (
      'select * from UserGroups where UserID=:id')
    AfterInsert = GroupsAfterInsert
    BeforePost = GroupsBeforePost
    Left = 80
    Top = 216
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = Null
      end>
    object GroupsID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object GroupsUserID: TGuidField
      FieldName = 'UserID'
      Required = True
      Size = 38
    end
    object GroupsGroupID: TGuidField
      FieldName = 'GroupID'
      FixedChar = True
      Size = 38
    end
  end
  object GroupsSrc: TUniDataSource
    DataSet = Groups
    Left = 88
    Top = 264
  end
  object PayTypes: TUniQuery
    Connection = EData.db
    SQL.Strings = (
      'select * from UserPayTypes where UserID=:id')
    AfterInsert = PayTypesAfterInsert
    BeforePost = PayTypesBeforePost
    Left = 200
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = Null
      end>
    object PayTypesID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object PayTypesName: TWideStringField
      FieldName = 'Name'
      Size = 50
    end
    object PayTypesAccount: TGuidField
      FieldName = 'Account'
      FixedChar = True
      Size = 38
    end
    object PayTypesUserID: TGuidField
      FieldName = 'UserID'
      Size = 38
    end
  end
  object PayTypesSrc: TUniDataSource
    DataSet = PayTypes
    Left = 184
    Top = 288
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 112
    Top = 376
  end
  object PopupMenu2: TPopupMenu
    Alignment = paRight
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 536
    Top = 176
    object N10: TMenuItem
      Caption = #1578#1588#1594#1610#1604
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #1573#1610#1602#1575#1601
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = #1573#1604#1594#1575#1569' '#1575#1604#1578#1579#1576#1610#1578
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = #1578#1579#1576#1610#1578
      OnClick = N13Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 728
    Top = 248
  end
  object Accounts: TUniQuery
    Connection = EData.db
    SQL.Strings = (
      'select * from UserAccounts where UserID=:id')
    AfterInsert = AccountsAfterInsert
    BeforePost = AccountsBeforePost
    Left = 552
    Top = 280
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = nil
      end>
    object AccountsID: TGuidField
      FieldName = 'ID'
      Required = True
      Size = 38
    end
    object AccountsUserID: TGuidField
      FieldName = 'UserID'
      Required = True
      Size = 38
    end
    object AccountsAccountID: TGuidField
      FieldName = 'AccountID'
      Required = True
      FixedChar = True
      Size = 38
    end
  end
  object AccountsSrc: TUniDataSource
    DataSet = Accounts
    Left = 520
    Top = 296
  end
end
