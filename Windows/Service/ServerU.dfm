object Server: TServer
  OnCreate = DataModuleCreate
  Height = 682
  Width = 917
  PixelsPerInch = 120
  object actions: TWebDispatcher
    Actions = <
      item
        Default = True
        Name = '404'
        OnAction = actions404Action
      end
      item
        MethodType = mtPost
        Name = 'clientlist'
        PathInfo = '/clientlist'
        OnAction = actionsclientlistAction
      end
      item
        MethodType = mtPost
        Name = 'login'
        PathInfo = '/login'
        OnAction = actionsloginAction
      end
      item
        MethodType = mtPost
        Name = 'paytypelist'
        PathInfo = '/paytypelist'
        OnAction = actionspaytypelistAction
      end
      item
        Name = 'addop'
        PathInfo = '/addop'
        OnAction = actionsaddopAction
      end
      item
        MethodType = mtPost
        Name = 'settings'
        PathInfo = '/settings'
        OnAction = actionssettingsAction
      end
      item
        MethodType = mtPost
        Name = 'addbill'
        PathInfo = '/addbill'
        OnAction = actionsaddbillAction
      end
      item
        MethodType = mtPost
        Name = 'oplog'
        PathInfo = '/oplog'
        OnAction = actionsoplogAction
      end
      item
        MethodType = mtPost
        Name = 'opdet'
        PathInfo = '/opdet'
        OnAction = actionsopdetAction
      end
      item
        MethodType = mtPost
        Name = 'logo'
        PathInfo = '/logo'
        OnAction = actionslogoAction
      end
      item
        MethodType = mtPost
        Name = 'kashf'
        PathInfo = '/kashf'
        OnAction = actionskashfAction
      end
      item
        MethodType = mtPost
        Name = 'teacher'
        PathInfo = '/teacher'
        OnAction = actionsteacherAction
      end
      item
        MethodType = mtPost
        Name = 'acclist'
        PathInfo = '/acclist'
        OnAction = actionsacclistAction
      end
      item
        MethodType = mtPost
        Name = 'matlist'
        PathInfo = '/matlist'
        OnAction = actionsmatlist1Action
      end>
    BeforeDispatch = actionsBeforeDispatch
    AfterDispatch = actionsAfterDispatch
    OnException = actionsException
    Left = 48
    Top = 136
    Height = 0
    Width = 0
    PixelsPerInch = 0
  end
  object db: TUniConnection
    ProviderName = 'sQL Server'
    Database = 'mnrAnd'
    SpecificOptions.Strings = (
      'sQL Server.Provider=prMSOLEDB'
      'sQL Server.NativeClientVersion=nc2012')
    Options.KeepDesignConnected = False
    Debug = True
    Username = 'sa'
    Server = '(local)\EDBDEV2022X64'
    LoginPrompt = False
    Left = 32
    Top = 32
    EncryptedPassword = 'D2FFBEFF9EFFCEFFCBFFCAFFCDFFC9FFC9FFCEFFCFFF'
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 376
    Top = 24
  end
  object strs: TJvMultiStringHolder
    MultipleStrings = <
      item
        Name = 'clientlist'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token;'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          ''
          
            'declare @vaccounts table (id uniqueidentifier, code  nvarchar(51' +
            '2), number nvarchar(512), name nvarchar(512), phone nvarchar(512' +
            '), TaxNum nvarchar(512), Address nvarchar(512))'
          'declare @vcurracc table (id uniqueidentifier)'
          'declare @vtmpacc table (id uniqueidentifier)'
          ''
          
            'insert into @vaccounts select acc.id, acc.code, acc.number, acc.' +
            'name, cust.Phone1 as phone, TaxNum, City+'#39' '#39'+Area+'#39' '#39'+Street'
          
            'from MnrAccDB001.dbo.mnrAcc acc inner join MnrAccDB001.dbo.mnrCu' +
            'st cust'
          'on acc.CustID=cust.ID'
          'where acc.ID in'
          '(select ClientID from UserClients where UserID=@vuid)'
          ''
          
            'insert into @vcurracc select id from MnrAccDB001.dbo.mnrAcc wher' +
            'e ParentID in (select ClientID from UserClients where UserID=@vu' +
            'id)'
          ''
          'while @@ROWCOUNT>0'
          'begin'
          
            #9'insert into @vaccounts select acc.id, acc.code, acc.number, acc' +
            '.name, cust.Phone1 as phone, TaxNum, City+'#39' '#39'+Area+'#39' '#39'+Street'
          
            #9'from MnrAccDB001.dbo.mnrAcc acc inner join MnrAccDB001.dbo.mnrC' +
            'ust cust'
          #9'on acc.CustID=cust.ID'
          #9'where acc.ID in (select id from @vcurracc)'
          
            #9'insert into @vtmpacc select id from MnrAccDB001.dbo.mnrAcc wher' +
            'e ParentID in (select id from @vcurracc)'
          #9'delete from @vcurracc'
          #9'insert into @vcurracc select id from @vtmpacc'
          #9'delete from @vtmpacc'
          'end'
          'select distinct * from @vaccounts')
      end
      item
        Name = 'paytypelist'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token;'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          ''
          'select Name, Account from UserPayTypes where UserID=@vuid')
      end
      item
        Name = 'settings'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token;'
          'declare @vuid uniqueidentifier'
          'declare @vpBill bit'
          'declare @vpReturn bit'
          'declare @vpPayIn bit'
          'declare @vpPayOut bit'
          'declare @vpDiscIn bit'
          'declare @vpDiscOut bit'
          'declare @vpSpent bit'
          'declare @vpCustReport bit'
          'declare @vpGLedger  bit'
          'declare @vpAllAcc bit'
          'declare @vpShowCost bit'
          'declare @vpShowQuality bit'
          'declare @vpPrice bit'
          'declare @vpStock bit'
          'declare @vpOnlyPos bit'
          'declare @vpEditPrice int'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          ''
          
            'select @vuid=ID, @vpBill=pBill, @vpReturn=pReturn, @vpPayIn=pPay' +
            'In, @vpPayOut=pPayOut, @vpDiscIn=pDiscIn, @vpDiscOut=pDiscOut, @' +
            'vpSpent=pSpent,'
          
            '@vpCustReport=pCustReport, @vpGLedger =pGLedger , @vpAllAcc=pAll' +
            'Acc, @vpShowCost=pShowCost, @vpPrice=pPrice, @vpStock=pStock,'
          
            '@vpOnlyPos=pOnlyPOS, @vpEditPrice=pEditPrice, @vpShowQuality=pSh' +
            'owQuality from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          ''
          'declare @bTTC bit'
          
            'select @bTTC=bTTC from MnrAccDB001.dbo.mnrBillType where ID=(sel' +
            'ect top 1 SellType from settings)'
          'declare @rTTC bit'
          
            'select @rTTC=bTTC from MnrAccDB001.dbo.mnrBillType where ID=(sel' +
            'ect top 1 ReturnType from settings)'
          'declare @pTTC bit'
          
            'select @pTTC=bTTC from MnrAccDB001.dbo.mnrBillType where ID=(sel' +
            'ect top 1 PriceType from settings)'
          'declare @sTTC bit'
          
            'select @sTTC=bTTC from MnrAccDB001.dbo.mnrBillType where ID=(sel' +
            'ect top 1 StockType from settings)'
          ''
          
            'select isnull(CompAddress, '#39#39') as CompAddress, isnull(DefaultPay' +
            'edAccount, 0x0) as DefaultPayedAccount, isnull(MatUpdateInterval' +
            ', 30) as MatUpdateInterval,'
          
            'isnull(@vpBill,0) as pBill, isnull(@vpReturn,0) as pReturn, isnu' +
            'll(@vpPayIn,0) as pPayIn,'
          
            'isnull(@vpPayOut,0) as pPayOut, isnull(@vpDiscIn,0) as pDiscIn, ' +
            'isnull(@vpDiscOut,0) as pDiscOut, isnull(@vpSpent,0) as pSpent '
          
            ', isnull(@vpStock,0) as pStock , isnull(@vpPrice,0) as pPrice , ' +
            'isnull(@vpCustReport,0) as pCustReport , isnull(@vpGLedger ,0) a' +
            's pGLedger,'
          
            'isnull(@vpAllAcc, 0) as pAllAcc, isnull(@vpShowCost, 0) as pShow' +
            'Cost, isnull(@vpShowQuality, 0) as pShowQuality, isnull(@vpOnlyP' +
            'os, 0) as pOnlyPOS, '
          
            'isnull(@vpEditPrice, 1) as pEditPrice , isnull(@bTTC ,0) as bttc' +
            ', isnull(@rTTC ,0) as rttc ,'
          'isnull(@pTTC ,0) as pttc, isnull(@sTTC ,0) as sttc'
          ''
          'from settings')
      end
      item
        Name = 'addbill'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token'
          'declare @vuid uniqueidentifier'
          'declare @vbillid uniqueidentifier'
          'declare @vsaleman uniqueidentifier'
          'declare @vmnruser uniqueidentifier'
          'declare @vcostcenter uniqueidentifier'
          'declare @vstore uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          
            'select @vuid=ID, @vsaleman=isnull(SaleMan, :nullid), @vmnruser=i' +
            'snull(mnrUser, :nullid),'
          
            '@vcostcenter=isnull(CostCenter, :nullid), @vstore=isnull(Store, ' +
            ':nullid) from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'exec MnrAccDB001.dbo.[mnrPrcConnections_Add] @vmnruser, 0'
          'declare @oldmaturity int'
          'declare @needsetmaturity bit'
          'select @needsetmaturity=0'
          
            'if exists(select * from MnrAccDB001.dbo.mnrUserObject where User' +
            'ID=@vmnruser and object=278) or :appbilltype<>1 select @needsetm' +
            'aturity=1'
          'if @needsetmaturity=1 '
          'begin'
          
            #9'select @oldmaturity=[Value] from MnrAccDB001.dbo.mnrFileOption ' +
            'where Number = 0x10000 + 97'
          
            #9'update MnrAccDB001.dbo.mnrFileOption set [Value]=0 where Number' +
            ' = 0x10000 + 97'
          'end'
          'select @vbillid=:billid'
          'INSERT INTO MnrAccDB001.dbo.mnrBill('
          
            'ID, Date, TimeIn, AccCustID, PayType, AccAccountID, CurrencyID, ' +
            'BranchID,'
          'CustID'
          ',AccCustName'
          ',CurrencyVal,'
          'Number,'
          'UserID, StoreID, CostJobID, ProjectID, BillTypeID,'
          
            'Notes, Total, TotalItem, TotalExtra, TotalDisc, Profits, TotalPa' +
            'id,'
          'ItemsExtra, ItemsDisc, Status, Vendor, IsPosted, VAT, Class,'
          'str1, str2, str3, str4, str5, str6, Date1, Date2, Date3,'
          'TermType, TermCnt, IsPrinted, ParentType, SalesmanID)'
          'VALUES('
          '@vbillid, :dt, :dtt, :accid, :paytype, :payacc, :curr, 0x0,'
          '(select CustID from MnrAccDB001.dbo.mnrAcc where ID=:accid),'
          '(select name from MnrAccDB001.dbo.mnrAcc where id=:accid),'
          
            '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
            'urr),'
          
            '(select cast(isnull(max(Number),0)+1 as float) from MnrAccDB001.' +
            'dbo.mnrBill where BillTypeID =:billtype),'
          '@vmnruser, @vstore, @vcostcenter, :nullid, :billtype,'
          ':notes, :net, :itemsum, 0, :disc, :net, :payed,'
          '0, 0, 0, '#39#39', :isposted, :vat, '#39#39', '
          #39#39', '#39#39', '#39#39', '#39#39', '#39#39', '#39#39', :nulldate, :nulldate, :nulldate, '
          '0, 0, 0,0, @vsaleman);'
          
            'if @needsetmaturity=1 update MnrAccDB001.dbo.mnrFileOption set [' +
            'Value]=@oldmaturity where Number = 0x10000 + 97'
          ''
          
            'select @vbillid as billid, @vmnruser as mnruser, @vsaleman as sa' +
            'leman, @vstore as store, @vcostcenter as costcenter,'
          
            '(select Number from MnrAccDB001.dbo.mnrBill where id=@vbillid) a' +
            's Num;')
      end
      item
        Name = 'additem'
        Strings.Strings = (
          'INSERT INTO MnrAccDB001.dbo.mnrBillItem'
          ''
          
            '("ID","mnrBillID","Number","MatID","StoreID","CostJobID", Provid' +
            'eDate,'
          '"Qty1","Qty2"'
          ',"Qty3","Qty4","Qty5","Unit","Price","Disc","Extra",'
          '"Bonus1","Bonus2","Bonus3"'
          ',"Bonus4","Bonus5","CostItem","Notes",'
          '"Length","Width","Height","ExpireDate"'
          ',"ProductDate",'
          '"Vendor","VAT","VATRatio","Class","Cnt","RelNum", SalesmanID)'
          ''
          'Values('
          ''
          
            ':itemid,:billid,:itemno, :matid, :storeid,:costjobid, '#39'1980-01-0' +
            '1'#39','
          ':qty1,:qty2,:qty3,:qty4,:qty5,:unit'
          ',:oneprice,0,0,'
          '0,0,0,0,0,0,:notes,'
          '0,0,0,:nulldate, :nulldate,'
          ':ven,:vat,:vatratio,'#39#39',0,0, :saleman)')
      end
      item
        Name = 'entry'
        Strings.Strings = (
          'exec MnrAccDB001.dbo.mnrPrcBill_GenEntry :billid,:newentryid;'
          
            '--UPDATE MnrAccDB001.dbo.mnrEntry SET "IsPosted"=1 WHERE "ID"=:n' +
            'ewentryid AND "IsPosted"=0;')
      end
      item
        Name = 'billpay'
        Strings.Strings = (
          'INSERT INTO MnrAccDB001.[dbo].[mnrBillPay] ('
          
            '[ID],[mnrBillID],[Number],[AccID],[Debit],[Credit],[CurrencyID],' +
            '[CurrencyVal],[Notes],[Vendor]'
          ',[CostJobID],[Class],[CurrencyVal2], SalesmanID)'
          'VALUES'
          '( '
          ':id, :bill, :num, :acc, :payed, :payed1, :curr,'
          
            '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
            'urr),'
          #39#39','#39#39',:cost, '#39#39', 0, :saleman'
          ')')
      end
      item
        Name = 'billdisc'
        Strings.Strings = (
          'INSERT INTO MnrAccDB001.[dbo].[mnrBillDisc]'
          
            '([ID] ,[mnrBillID], [Number],[AccID],[Disc],[Extra],[CurrencyID]' +
            ',[CurrencyVal]'
          ',[Notes],[Vendor],[CostJobID],[Class], SalesmanID)'
          'VALUES'
          '('
          ':id, :bill, :number, :acc, :disc, :vat, :curr, '
          
            '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
            'urr),'
          #39#39','#39#39',:costcenter, '#39#39', :saleman'
          ')')
      end
      item
        Name = 'addop'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'declare @vmadeen uniqueidentifier'
          'declare @vdaen uniqueidentifier'
          'declare @vsaleman uniqueidentifier'
          'declare @vmnruser uniqueidentifier'
          'declare @vcostcenter uniqueidentifier'
          'declare @vstore uniqueidentifier'
          'set @vtoken=:token'
          'set @vmadeen=:madeen'
          'set @vdaen=:daen'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          
            'select @vuid=ID, @vsaleman=isnull(SaleMan, :nullid), @vmnruser=i' +
            'snull(mnrUser, :nullid),'
          
            '@vcostcenter=isnull(CostCenter, :nullid), @vstore=isnull(Store, ' +
            ':nullid) from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          'declare @veid uniqueidentifier'
          'declare @vpid uniqueidentifier'
          'declare @vdnum float'
          'declare @vcurrval float'
          ''
          'select @veid=newid()'
          'select @vpid=newid()'
          
            'select @vdnum=isnull(max(Number),0)+1 from MnrAccDB001.dbo.mnrPa' +
            'y where PayTypeID=:daytype'
          
            'select @vcurrval=CurrencyVal from MnrAccDB001.dbo.mnrCurrency wh' +
            'ere id=:curr'
          ''
          'INSERT INTO MnrAccDB001.dbo.mnrEntry ('
          'ID, Number, Date, CurrencyID, CurrencyVal, '
          'Notes, BranchID, EntryTypeID, ParentID, '
          'ParentType, ParentNumber, IsPosted, State,UserID'
          ')VALUES ('
          
            '@veid, (select isnull(max(Number),0)+1 from MnrAccDB001.dbo.mnrE' +
            'ntry), :dt, :curr, @vcurrval, '
          ':notes, :nullid, :daytype, @vpid,'
          '1, @vdnum, 1, 0, @vmnruser)'
          ''
          'INSERT INTO MnrAccDB001.dbo.mnrEntryItem ('
          'ID, mnrEntryID, Number, Date,'
          
            'AccID, Debit, Credit, CurrencyID, CurrencyVal, Notes, SalesmanID' +
            ','
          'Vendor, CostJobID, ContraAccID, Class,'
          
            'CurrencyVal2, ItemType, TaxType, Tax, EntityName, TaxNum, Invoic' +
            'eNum, TaxAccID'
          ') VALUES ('
          'newid(), @veid, 0, :dt,'
          '@vmadeen, :amount, 0, :curr, @vcurrval, :notes , @vsaleman,'
          #39#39', @vcostcenter, @vdaen, '#39#39','
          '0, 0, 0, 0, '#39#39', '#39#39', '#39#39', :nullid)'
          ''
          'INSERT INTO MnrAccDB001.dbo.mnrEntryItem ('
          'ID, mnrEntryID, Number, Date,'
          
            'AccID, Debit, Credit, CurrencyID, CurrencyVal, Notes, SalesmanID' +
            ','
          'Vendor, CostJobID, ContraAccID, Class,'
          
            'CurrencyVal2, ItemType, TaxType, Tax, EntityName, TaxNum, Invoic' +
            'eNum, TaxAccID'
          ') VALUES ('
          'newid(), @veid, 1, :dt,'
          '@vdaen, 0, :amount, :curr, @vcurrval, :notes, @vsaleman,'
          #39#39', @vcostcenter, @vmadeen , '#39#39','
          '0, 0, 0, 0, '#39#39', '#39#39', '#39#39', :nullid)'
          ''
          'INSERT INTO MnrAccDB001.dbo.mnrPay ('
          'ID, Number, Date, Notes, CurrencyID, CurrencyVal,'
          'PayTypeID, AccID, BranchID,'
          'CostJobID, SalesmanID, UserID'
          ') VALUES ('
          '@vpid, @vdnum, :dt, :notes, :curr, @vcurrval,'
          
            ':daytype,      case :optype when 0 then null when 1 then @vmadee' +
            'n else @vdaen end      , :nullid,'
          '@vcostcenter, @vsaleman, :user)'
          ''
          'select @vpid as opid')
      end
      item
        Name = 'oplog'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          
            'select ID, UserID, Date, Operation, Num, ClientID, ClientNum, Cl' +
            'ientName, Notes, Materials from OpLog where UserID=@vuid'
          'and (:d1 is null or Date>=:d1)'
          'and (:d2 is null or Date<:d2)'
          'order by Date desc')
      end
      item
        Name = 'opdet'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          'select Details from OpLog where ID=:opid and UserID=@vuid')
      end
      item
        Name = 'logo'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token;'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          ''
          'select CompLogo from settings')
      end
      item
        Name = 'kashf'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          'declare @vuid uniqueidentifier'
          'select @vuid=ID from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          'declare @vcust uniqueidentifier'
          
            'select @vcust=CustID from  "MnrAccDB001".."mnrAcc" where ID=:cus' +
            't'
          'declare @vkid uniqueidentifier'
          'select @vkid=newid()'
          'declare @vcurr uniqueidentifier'
          'select @vcurr=:curr'
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          
            'select @vkid, id, 2, 0x0 from "MnrAccDB001"..mnrBillType where t' +
            'ype<>1'
          ''
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          
            'select @vkid, id, 4, 0x0 from "MnrAccDB001"..mnrPayType where ty' +
            'pe<>1'
          ''
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          'values (@vkid, 0x0, 4, 0x0)'
          ''
          
            'exec "MnrAccDB001"..mnrPrcRepAccStatement5 @CustID=@vcust, @SrcI' +
            'D= @vkid , '
          '@CurrencyID=@vcurr, @ShowAccAge=0, @PeriodCnt=0, @PeriodLen=0, '
          
            '@FromDate=:d1 , @ToDate=:d2 , @UseUnit =6, @ShowBillDetailes=:sb' +
            'd,'
          '@ShowUnPosted=0')
      end
      item
        Name = 'barcodes'
        Strings.Strings = (
          
            'select matid, unit, barcode from MnrAccDB001.dbo.mnrMatBarcode w' +
            'here Barcode<>'#39#39)
      end
      item
        Name = 'teacher'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'declare @vmnruser uniqueidentifier'
          'set @vtoken=:token'
          'declare @vcurr uniqueidentifier'
          'select @vcurr=:curr'
          'declare @vcurrval float'
          
            'select @vcurrval=CurrencyVal from "MnrAccDB001"..mnrCurrency whe' +
            're id=@vcurr'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          
            'select @vuid=ID, @vmnruser=isnull(mnrUser, 0x0) from Users where' +
            ' LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e'
          #9'return'
          'end'
          ''
          'declare @vkid uniqueidentifier'
          'select @vkid=newid()'
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          
            'select @vkid, id, 2, 0x0 from "MnrAccDB001"..mnrBillType where t' +
            'ype<>1'
          ''
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          
            'select @vkid, id, 4, 0x0 from "MnrAccDB001"..mnrPayType where ty' +
            'pe<>1'
          ''
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          'values (@vkid, 0x0, 4, 0x0)'
          ''
          'exec "MnrAccDB001"..mnrPrcRepAccGL '
          ':accid, 0x0 , 0x0 , 0x0 , 0x0 , @vkid , @vcurr, @vcurrval'
          
            ',:d1, :d2 , '#39#39' , '#39#39' , '#39#39' , '#39#39' , 0 , 0 , 1 , 0 , 1 , 1 , 0 , 0 , ' +
            '0 , 0 , 1 , 0 , 1 , 1 , 0 , 0 , 0 , 0 , 1 , 1 , 0x0, 0x0 , 0x0 ,' +
            ' @vmnruser')
      end
      item
        Name = 'acclist'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'declare @vcanall bit'
          'set @vtoken=:token;'
          'declare @vuid uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          
            'select @vuid=ID, @vcanall=isnull(pAllAcc,0) from Users where Las' +
            'tToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'if @vcanall=1'
          'begin'
          
            'select acc.id, acc.code, acc.number, acc.name, cust.Phone1 as ph' +
            'one, TaxNum, City+'#39' '#39'+Area+'#39' '#39'+Street as Address'
          
            #9'from MnrAccDB001.dbo.mnrAcc acc left join MnrAccDB001.dbo.mnrCu' +
            'st cust'
          #9'on acc.CustID=cust.ID'
          #9'return'
          'end'
          ''
          ''
          
            'declare @vaccounts table (id uniqueidentifier, code  nvarchar(51' +
            '2), number nvarchar(512), name nvarchar(512), phone nvarchar(512' +
            '), TaxNum nvarchar(512), Address nvarchar(512))'
          'declare @vcurracc table (id uniqueidentifier)'
          'declare @vtmpacc table (id uniqueidentifier)'
          ''
          
            'insert into @vaccounts select acc.id, acc.code, acc.number, acc.' +
            'name, cust.Phone1 as phone, TaxNum, City+'#39' '#39'+Area+'#39' '#39'+Street'
          
            'from MnrAccDB001.dbo.mnrAcc acc left join MnrAccDB001.dbo.mnrCus' +
            't cust'
          'on acc.CustID=cust.ID'
          'where acc.ID in'
          '(select AccountID from UserAccounts where UserID=@vuid)'
          ''
          
            'insert into @vcurracc select id from MnrAccDB001.dbo.mnrAcc wher' +
            'e ParentID in (select AccountID from UserAccounts where UserID=@' +
            'vuid)'
          ''
          'while @@ROWCOUNT>0'
          'begin'
          
            #9'insert into @vaccounts select acc.id, acc.code, acc.number, acc' +
            '.name, cust.Phone1 as phone, TaxNum, City+'#39' '#39'+Area+'#39' '#39'+Street'
          
            #9'from MnrAccDB001.dbo.mnrAcc acc left join MnrAccDB001.dbo.mnrCu' +
            'st cust'
          #9'on acc.CustID=cust.ID'
          #9'where acc.ID in (select id from @vcurracc)'
          
            #9'insert into @vtmpacc select id from MnrAccDB001.dbo.mnrAcc wher' +
            'e ParentID in (select id from @vcurracc)'
          #9'delete from @vcurracc'
          #9'insert into @vcurracc select id from @vtmpacc'
          #9'delete from @vtmpacc'
          'end'
          'select distinct * from @vaccounts')
      end
      item
        Name = 'additem2'
        Strings.Strings = (
          'INSERT INTO MnrAccDB001.dbo.mnrBillItem'
          ''
          
            '("ID","mnrBillID","Number","MatID","StoreID","CostJobID", Provid' +
            'eDate,'
          '"Qty1","Qty2"'
          ',"Qty3","Qty4","Qty5","Unit","Price","Disc","Extra",'
          '"Bonus1","Bonus2","Bonus3"'
          ',"Bonus4","Bonus5","CostItem","Notes",'
          '"Length","Width","Height","ExpireDate"'
          ',"ProductDate",'
          
            '"Vendor","VAT","VATRatio","Class","Cnt","RelNum", SalesmanID, Ta' +
            'x2, Tax2Ratio, Tax3, Tax3Ratio)'
          ''
          'Values('
          ''
          
            ':itemid,:billid,:itemno, :matid, :storeid,:costjobid, '#39'1980-01-0' +
            '1'#39','
          ':qty1,:qty2,:qty3,:qty4,:qty5,:unit'
          ',:oneprice,0,0,'
          '0,0,0,0,0,0,:notes,'
          '0,0,0,:nulldate, :nulldate,'
          ':ven,:vat,:vatratio/100,'#39#39',0,0, :saleman, 0, 0, 0, 0)')
      end
      item
        Name = 'matlist1'
        Strings.Strings = (
          'declare @showall bit'
          'select @showall=isnull(pAllMat,0) from Users where id=:uid'
          'if @showall=1 '
          'begin'
          
            #9'select mnrMaterial.id, mnrMaterial.name, mnrMaterial.code, mnrG' +
            'rp.Name as grp,'
          
            #9'<Price>1 as price1, <Price>2  as price2, <Price>3 as price3, <P' +
            'rice>4 as price4, <Price>5 as price5,'
          #9'unit1, unit2, unit3, unit4, unit5,'
          
            #9'barcode1, barcode2, barcode3, barcode4, barcode5, AvgCostPrice ' +
            'as cost, Quality as quality'
          
            #9'from MnrAccDB001.dbo.mnrMaterial inner join MnrAccDB001.dbo.mnr' +
            'Grp on mnrMaterial.ParentID=mnrGrp.ID'
          #9' order by mnrGrp.Name, mnrMaterial.name, mnrMaterial.id'
          'end'
          'ELSE'
          'begin'
          #9'declare @vmaterials table ('
          
            #9'id uniqueidentifier, name nvarchar(512), code nvarchar(512), gr' +
            'p nvarchar(512),'
          
            #9'price1 float, price2 float, price3 float, price4 float, price5 ' +
            'float,'
          
            #9'unit1 nvarchar(512), unit2 nvarchar(512), unit3 nvarchar(512), ' +
            'unit4 nvarchar(512), unit5 nvarchar(512),'
          
            #9'barcode1 nvarchar(512), barcode2 nvarchar(512), barcode3 nvarch' +
            'ar(512), barcode4 nvarchar(512), barcode5 nvarchar(512),'
          #9'cost float, quality nvarchar(512)'
          #9')'
          ''
          #9'insert into @vmaterials select '
          
            #9'mnrMaterial.ID, mnrMaterial.Name, mnrMaterial.Code, mnrGrp.Name' +
            ','
          #9'<Price>1, <Price>2, <Price>3, <Price>4, <Price>5,'
          #9'Unit1, Unit2, Unit3, Unit4, Unit5,'
          
            #9'Barcode1, Barcode2, Barcode3, Barcode4, Barcode5, AvgCostPrice,' +
            ' quality'
          
            #9'from MnrAccDB001.dbo.mnrMaterial inner join MnrAccDB001.dbo.mnr' +
            'Grp on mnrMaterial.ParentID=mnrGrp.ID where mnrMaterial.ID in (s' +
            'elect MatID from UserMaterials where UserID=:uid)'
          ''
          #9'declare @vgroups table (id uniqueidentifier)'
          #9'declare @vtmpgrp table (id uniqueidentifier)'
          #9#9
          #9'insert into @vgroups'
          #9'select GroupID from UserGroups where UserID=:uid'
          #9'while @@ROWCOUNT>0'
          #9'begin'
          #9'insert into @vmaterials select '
          
            #9'mnrMaterial.ID, mnrMaterial.Name, mnrMaterial.Code, mnrGrp.Name' +
            ','
          #9'<Price>1, <Price>2, <Price>3, <Price>4, <Price>5,'
          #9'Unit1, Unit2, Unit3, Unit4, Unit5,'
          
            #9'Barcode1, Barcode2, Barcode3, Barcode4, Barcode5, AvgCostPrice,' +
            ' quality'
          
            #9'from MnrAccDB001.dbo.mnrMaterial inner join MnrAccDB001.dbo.mnr' +
            'Grp on mnrMaterial.ParentID=mnrGrp.ID where mnrMaterial.ParentID' +
            ' in (select id from @vgroups)'
          ''
          
            #9'insert into @vtmpgrp select GrpID from MnrAccDB001.dbo.mnrGrpIt' +
            'em where ParentID in (select id from @vgroups)'
          
            #9'insert into @vtmpgrp select ID from MnrAccDB001.dbo.mnrGrp wher' +
            'e ParentID in (select id from @vgroups)'
          #9'delete from @vgroups'
          #9'insert into @vgroups select id from @vtmpgrp'
          #9'delete from @vtmpgrp'
          #9'end'
          #9'select distinct * from @vmaterials order by grp, name, id'
          'end')
      end
      item
        Name = 'matlist2'
        Strings.Strings = (
          
            'select MatID, StoreID, st.Name as StoreName, mnrMatStore.Qty1 as' +
            ' Qty'
          'from MnrAccDB001.dbo.mnrMatStore '
          'inner join MnrAccDB001.dbo.mnrMaterial mt on MatID=mt.ID'
          'inner join MnrAccDB001.dbo.mnrStore st on StoreID=st.ID'
          'inner join MnrAccDB001.dbo.mnrGrp gr on mt.ParentID=gr.ID'
          'where mnrMatStore.Qty1<>0'
          'and (:cstr=0 or StoreID=:str)'
          'order by gr.Name, mt.Name, MatID')
      end
      item
        Name = 'matlist2jardbased'
        Strings.Strings = (
          'declare @vkid uniqueidentifier'
          'select @vkid=newid()'
          
            'insert into "MnrAccDB001".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
            'peID","LinkID") '
          
            'select @vkid, id, 2, 0x0 from "MnrAccDB001"..mnrBillType where t' +
            'ype<>1'
          ''
          
            'exec MnrAccDB001.dbo.mnrPrcRepMatInventory 0x0, 0x0, 0, :store, ' +
            '0, 0x0, 0x0, '#39#39', '#39#39', @vkid, :curr, '#39'1980-01-01'#39', '#39'2111-01-01'#39', 0' +
            ', 0, 0, 0, 0, 1, '#39'GrNAme, mtName, MatID'#39', 12, 1, 0, 1, 0, '#39#39', '#39#39 +
            ', 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x0, 0, 0'
          '')
      end
      item
        Name = 'addbill2'
        Strings.Strings = (
          'declare @vtoken varchar(250)'
          'set @vtoken=:token'
          'declare @vuid uniqueidentifier'
          'declare @vbillid uniqueidentifier'
          'declare @vsaleman uniqueidentifier'
          'declare @vmnruser uniqueidentifier'
          'declare @vcostcenter uniqueidentifier'
          'declare @vstore uniqueidentifier'
          'if isnull(@vtoken, '#39#39')='#39#39' '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          
            'select @vuid=ID, @vsaleman=isnull(SaleMan, :nullid), @vmnruser=i' +
            'snull(mnrUser, :nullid),'
          
            '@vcostcenter=isnull(CostCenter, :nullid), @vstore=isnull(Store, ' +
            ':nullid) from Users where LastToken=@vtoken'
          'if @vuid is null '
          'begin'
          #9'select '#39'login'#39' as e;'
          #9'return;'
          'end'
          'exec MnrAccDB001.dbo.[mnrPrcConnections_Add] @vmnruser, 0'
          'declare @oldmaturity int'
          'declare @needsetmaturity bit'
          'select @needsetmaturity=0'
          
            'if exists(select * from MnrAccDB001.dbo.mnrUserObject where User' +
            'ID=@vmnruser and object=278) or :appbilltype<>1 select @needsetm' +
            'aturity=1'
          'if @needsetmaturity=1 '
          'begin'
          
            #9'select @oldmaturity=[Value] from MnrAccDB001.dbo.mnrFileOption ' +
            'where Number = 0x10000 + 97'
          
            #9'update MnrAccDB001.dbo.mnrFileOption set [Value]=0 where Number' +
            ' = 0x10000 + 97'
          'end'
          'select @vbillid=:billid'
          'INSERT INTO MnrAccDB001.dbo.mnrBill('
          
            'ID, Date, TimeIn, AccCustID, PayType, AccAccountID, CurrencyID, ' +
            'BranchID, Tax2, Tax3'
          ',CustID'
          ',AccCustName'
          ',CurrencyVal,'
          'Number,'
          'UserID, StoreID, CostJobID, ProjectID, BillTypeID,'
          
            'Notes, Total, TotalItem, TotalExtra, TotalDisc, Profits, TotalPa' +
            'id,'
          'ItemsExtra, ItemsDisc, Status, Vendor, IsPosted, VAT, Class,'
          'str1, str2, str3, str4, str5, str6, Date1, Date2, Date3,'
          'TermType, TermCnt, IsPrinted, ParentType, SalesmanID)'
          'VALUES('
          
            '@vbillid, :dt, :dtt, :accid, :paytype, :payacc, :curr, :nullid,0' +
            ',0,'
          '(select CustID from MnrAccDB001.dbo.mnrAcc where ID=:accid),'
          '(select name from MnrAccDB001.dbo.mnrAcc where id=:accid),'
          
            '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
            'urr),'
          
            '(select cast(isnull(max(Number),0)+1 as float) from MnrAccDB001.' +
            'dbo.mnrBill where BillTypeID =:billtype),'
          '@vmnruser, @vstore, @vcostcenter, :nullid, :billtype,'
          ':notes, :net, :itemsum, 0, :disc, :net, :payed,'
          '0, 0, 0, '#39#39', :isposted, :vat, '#39#39', '
          #39#39', '#39#39', '#39#39', '#39#39', '#39#39', '#39#39', :nulldate, :nulldate, :nulldate, '
          '0, 0, 0,0, @vsaleman);'
          ''
          
            'if @needsetmaturity=1 update MnrAccDB001.dbo.mnrFileOption set [' +
            'Value]=@oldmaturity where Number = 0x10000 + 97'
          ''
          
            'select @vbillid as billid, @vmnruser as mnruser, @vsaleman as sa' +
            'leman, @vstore as store, @vcostcenter as costcenter,'
          
            '(select Number from MnrAccDB001.dbo.mnrBill where id=@vbillid) a' +
            's Num;')
      end>
    Left = 160
    Top = 152
  end
  object UniQuery1: TUniQuery
    Connection = db
    Left = 160
    Top = 48
  end
  object AddItem: TUniQuery
    Connection = db
    SQL.Strings = (
      'INSERT INTO MnrAccDB001.dbo.mnrBillItem'
      ''
      '("ID","mnrBillID","Number","MatID","StoreID","CostJobID",'
      '"Qty1","Qty2"'
      ',"Qty3","Qty4","Qty5","Unit","Price","Disc","Extra",'
      '"Bonus1","Bonus2","Bonus3"'
      ',"Bonus4","Bonus5","CostItem","Notes",'
      '"Length","Width","Height","ExpireDate"'
      ',"ProductDate",'
      '"Vendor","VAT","VATRatio","Class","Cnt","RelNum")'
      ''
      'Values('
      ''
      ':itemid,:billid,:itemno, :matid, :storeid,:costjobid,'
      ':qty,0,0,0,0,1'
      ',:oneprice,0,0,'
      '0,0,0,0,0,0,:notes,'
      '0,0,0,:nulldate, :nulldate,'
      ':ven,:vat,:vatratio,'#39#39',0,0)')
    Left = 434
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'itemid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'billid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'itemno'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'matid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'storeid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'costjobid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'qty'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'oneprice'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'notes'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'nulldate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ven'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vat'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vatratio'
        Value = nil
      end>
  end
  object Entry: TUniQuery
    Connection = db
    SQL.Strings = (
      'exec MnrAccDB001.dbo.mnrPrcBill_GenEntry :billid,:newentryid;'
      
        'UPDATE MnrAccDB001.dbo.mnrEntry SET "IsPosted"=1 WHERE "ID"=:new' +
        'entryid AND "IsPosted"=0;')
    Left = 434
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'billid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'newentryid'
        Value = nil
      end>
  end
  object EditBill: TUniQuery
    SQL.Strings = (
      'declare @vtoken varchar(250)'
      'set @vtoken=:token'
      'declare @vuid uniqueidentifier'
      'if isnull(@vtoken, '#39#39')='#39#39' '
      'begin'
      #9'select '#39'login'#39' as e'
      #9'return'
      'end'
      'select @vuid=ID from Users where LastToken=@vtoken'
      'if @vuid is null '
      'begin'
      #9'select '#39'login'#39' as e'
      #9'return'
      'end'
      ''
      'declare @vcust uniqueidentifier'
      'select @vcust=:cust'
      'declare @vkid uniqueidentifier'
      'select @vkid=newid()'
      'declare @vcurr uniqueidentifier'
      'select @vcurr=:curr'
      
        'insert into "MnrAccDB002".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
        'peID","LinkID") '
      'select @vkid, id, 2, 0x0 from mnrBillType where type<>1'
      ''
      
        'insert into "MnrAccDB002".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
        'peID","LinkID") '
      'select @vkid, id, 4, 0x0 from mnrPayType where type<>1'
      ''
      
        'insert into "MnrAccDB002".."mnrRepSrcs" ("RepID","TypeID","SubTy' +
        'peID","LinkID") '
      'values (@vkid, 0x0, 4, 0x0)'
      ''
      'exec mnrPrcRepAccStatement5 @vCustID=@vcust, @vSrcID= @vkid , '
      
        '@vCurrencyID=@vcurr, @vShowAccAge=0, @vPeriodCnt=0, @vPeriodLen=' +
        '0, '
      '@vFromDate=:d1 , @vToDate=:d2 , @vUseUnit =6 ')
    Left = 306
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'token'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'cust'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'curr'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'd1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'd2'
        Value = nil
      end>
  end
  object AddBill: TUniQuery
    Connection = db
    SQL.Strings = (
      'INSERT INTO MnrAccDB001.dbo.mnrBill('
      'ID, Date, TimeIn, AccCustID, PayType, AccAccountID, CurrencyID'
      ',AccCustName'
      ',CurrencyVal,'
      'Number,'
      'UserID, StoreID, CostJobID, BillTypeID,'
      
        'Notes, Total, TotalItem, TotalExtra, TotalDisc, Profits, TotalPa' +
        'id,'
      'ItemsExtra, ItemsDisc, Status, Vendor, IsPosted, VAT, Class,'
      'str1, str2, str3, str4, str5, str6, Date1, Date2, Date3,'
      'TermType, TermCnt, IsPrinted, ParentType)'
      'VALUES('
      ':billid, :dt, :dtt, :accid, :paytype, :payacc, :curr,'
      '(select name from MnrAccDB001.dbo.mnrAcc where id=:accid),'
      
        '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
        'urr),'
      
        '(select cast(isnull(max(Number),0)+1 as float) from MnrAccDB001.' +
        'dbo.mnrBill where BillTypeID =:billtype),'
      ':user, :store, :costcenter, :billtype,'
      ':notes, :net, :itemsum, :vat, :disc, :net, :payed'
      '0, 0, 0, '#39#39', 1, 0, '#39#39', '
      #39#39', '#39#39', '#39#39', '#39#39', '#39#39', '#39#39', :nulldate, :nulldate, :nulldate, '
      '0, 0, 0, '#39'00000000-0000-0000-0000-000000000000'#39');')
    Left = 426
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'billid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'dt'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'dtt'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'accid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'paytype'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'payacc'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'curr'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'billtype'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'user'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'store'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'costcenter'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'notes'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'net'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'itemsum'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vat'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'disc'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'payed'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'nulldate'
        Value = nil
      end>
  end
  object billdisc: TUniQuery
    Connection = db
    SQL.Strings = (
      'INSERT INTO MnrAccDB001.[dbo].[mnrBillDisc]'
      
        '([ID] ,[mnrBillID], [Number],[AccID],[Disc],[Extra],[CurrencyID]' +
        ',[CurrencyVal]'
      ',[Notes],[Vendor],[CostJobID],[Class], SalesmanID)'
      'VALUES'
      '('
      ':id, :bill, :number, :acc, :disc, :vat, :curr, '
      
        '(select CurrencyVal from MnrAccDB001.dbo.mnrCurrency where id=:c' +
        'urr),'
      #39#39','#39#39',:costcenter, '#39#39', :saleman'
      ')')
    Left = 338
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'bill'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'number'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'acc'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'disc'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vat'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'curr'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'costcenter'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'saleman'
        Value = nil
      end>
  end
  object billpay: TUniQuery
    Connection = db
    SQL.Strings = (
      'INSERT INTO MnrAccDB001.dbo.mnrBillItem'
      ''
      '("ID","mnrBillID","Number","MatID","StoreID","CostJobID",'
      '"Qty1","Qty2"'
      ',"Qty3","Qty4","Qty5","Unit","Price","Disc","Extra",'
      '"Bonus1","Bonus2","Bonus3"'
      ',"Bonus4","Bonus5","CostItem","Notes",'
      '"Length","Width","Height","ExpireDate"'
      ',"ProductDate",'
      '"Vendor","VAT","VATRatio","Class","Cnt","RelNum")'
      ''
      'Values('
      ''
      ':itemid,:billid,:itemno, :matid, :storeid,:costjobid,'
      ':qty,0,0,0,0,1'
      ',:oneprice,0,0,'
      '0,0,0,0,0,0,:notes,'
      '0,0,0,:nulldate, :nulldate,'
      ':ven,:vat,:vatratio,'#39#39',0,0)')
    Left = 330
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'itemid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'billid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'itemno'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'matid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'storeid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'costjobid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'qty'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'oneprice'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'notes'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'nulldate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ven'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vat'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'vatratio'
        Value = nil
      end>
  end
  object addop: TUniQuery
    Connection = db
    SQL.Strings = (
      'declare @vtoken varchar(250)'
      'declare @vsaleman uniqueidentifier'
      'set @vtoken=:token'
      'declare @vuid uniqueidentifier'
      'if isnull(@vtoken, '#39#39')='#39#39' '
      'begin'
      #9'select '#39'login'#39' as e'
      #9'return'
      'end'
      
        'select @vuid=ID, @vsaleman=isnull(SaleMan, :nullid) from Users w' +
        'here LastToken=@vtoken'
      'if @vuid is null '
      'begin'
      #9'select '#39'login'#39' as e'
      #9'return'
      'end'
      ''
      'declare @veid uniqueidentifier'
      'declare @vpid uniqueidentifier'
      'declare @vdnum float'
      'declare @vcurrval float'
      ''
      'select @veid=newid()'
      'select @vpid=newid()'
      
        'select @vdnum=isnull(max(Number),0)+1 from MnrAccDB002.dbo.mnrPa' +
        'y where PayTypeID=:daytype'
      
        'select @vcurrval=CurrencyVal from MnrAccDB002.dbo.mnrCurrency wh' +
        'ere id=:curr'
      ''
      'INSERT INTO MnrAccDB002.dbo.mnrEntry ('
      'ID, Number, Date, CurrencyID, CurrencyVal, '
      'Notes, BranchID, EntryTypeID, ParentID, '
      'ParentType, ParentNumber, IsPosted, State,UserID'
      ')VALUES ('
      
        '@veid, (select isnull(max(Number),0)+1 from MnrAccDB002.dbo.mnrE' +
        'ntry), :dt, :curr, @vcurrval, '
      ':notes, :nullid, :daytype, @vpid,'
      '1, @vdnum, 1, 0, :user)'
      ''
      'INSERT INTO MnrAccDB002.dbo.mnrEntryItem ('
      'ID, mnrEntryID, Number, Date,'
      
        'AccID, Debit, Credit, CurrencyID, CurrencyVal, Notes, SalesmanID' +
        ','
      'Vendor, CostJobID, ContraAccID, Class,'
      
        'CurrencyVal2, ItemType, TaxType, Tax, EntityName, TaxNum, Invoic' +
        'eNum, TaxAccID'
      ') VALUES ('
      'newid(), @veid, 0, :dt,'
      ':madeen, :amount, 0, :curr, @vcurrval, :notes , @vsaleman,'
      #39#39', :costcenter, :daen, '#39#39','
      '0, 0, 0, 0, '#39#39', '#39#39', '#39#39', :nullid)'
      ''
      'INSERT INTO MnrAccDB002.dbo.mnrEntryItem ('
      'ID, mnrEntryID, Number, Date,'
      
        'AccID, Debit, Credit, CurrencyID, CurrencyVal, Notes, SalesmanID' +
        ','
      'Vendor, CostJobID, ContraAccID, Class,'
      
        'CurrencyVal2, ItemType, TaxType, Tax, EntityName, TaxNum, Invoic' +
        'eNum, TaxAccID'
      ') VALUES ('
      'newid(), @veid, 1, :dt,'
      ':daen, 0, :amount, :curr, @vcurrval, :notes, @vsaleman,'
      #39#39', :costcenter, :madeen , '#39#39','
      '0, 0, 0, 0, '#39#39', '#39#39', '#39#39', :nullid)'
      ''
      'INSERT INTO MnrAccDB002.dbo.mnrPay ('
      'ID, Number, Date, Notes, CurrencyID, CurrencyVal,'
      'PayTypeID, AccID, BranchID,'
      'CostJobID, SalesmanID, UserID'
      ') VALUES ('
      '@vpid, @vdnum, :dt, :notes, :curr, @vcurrval,'
      
        ':daytype,      case :optype when 0 then null when 1 then :madeen' +
        ' else :daen end      , :nullid,'
      ':costcenter, @vsaleman, :user)'
      ''
      'select @vpid as opid')
    Left = 328
    Top = 296
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'token'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'nullid'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'daytype'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'curr'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'dt'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'notes'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'user'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'madeen'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'amount'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'costcenter'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'daen'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'optype'
        Value = nil
      end>
  end
  object kashf: TVirtualTable
    Active = True
    FieldDefs = <
      item
        Name = 'Doc'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'DocNotes'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Madeen'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Daen'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Quantity'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Price'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Total'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Add'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Disc'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'Date'
        DataType = ftWideString
        Size = 100
      end>
    Left = 240
    Top = 224
    Data = {
      04000A000300446F6318006400000000000800446F634E6F7465731800640000
      00000006004D616465656E180064000000000004004461656E18006400000000
      0008005175616E74697479180064000000000005005072696365180064000000
      00000500546F74616C1800640000000000030041646418006400000000000400
      4469736318006400000000000400446174651800640000000000000000000000}
    object kashfDoc: TWideStringField
      FieldName = 'Doc'
      Size = 100
    end
    object kashfDocNotes: TWideStringField
      FieldName = 'DocNotes'
      Size = 100
    end
    object kashfMadeen: TWideStringField
      FieldName = 'Madeen'
      Size = 100
    end
    object kashfDaen: TWideStringField
      FieldName = 'Daen'
      Size = 100
    end
    object kashfQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 100
    end
    object kashfPrice: TWideStringField
      FieldName = 'Price'
      Size = 100
    end
    object kashfTotal: TWideStringField
      FieldName = 'Total'
      Size = 100
    end
    object kashfAdd: TWideStringField
      FieldName = 'Add'
      Size = 100
    end
    object kashfDisc: TWideStringField
      FieldName = 'Disc'
      Size = 100
    end
    object kashfDate: TWideStringField
      FieldName = 'Date'
      Size = 100
    end
  end
  object Teacher: TVirtualTable
    Active = True
    FieldDefs = <
      item
        Name = 'Date'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'Notes'
        DataType = ftWideString
        Size = 1000
      end
      item
        Name = 'Madeen'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'Daen'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'Balance'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'Num'
        DataType = ftWideString
        Size = 20
      end>
    Left = 200
    Top = 360
    Data = {
      04000600040044617465180014000000000005004E6F7465731800E803000000
      0006004D616465656E180032000000000004004461656E180032000000000007
      0042616C616E6365180032000000000003004E756D1800140000000000000000
      000000}
    object TeacherDate: TWideStringField
      FieldName = 'Date'
    end
    object TeacherNotes: TWideStringField
      FieldName = 'Notes'
      Size = 1000
    end
    object TeacherMadeen: TWideStringField
      FieldName = 'Madeen'
      Size = 50
    end
    object TeacherDaen: TWideStringField
      FieldName = 'Daen'
      Size = 50
    end
    object TeacherBalance: TWideStringField
      FieldName = 'Balance'
      Size = 50
    end
    object TeacherNum: TWideStringField
      FieldName = 'Num'
    end
  end
  object UniQuery2: TUniQuery
    Connection = db
    SQL.Strings = (
      
        'insert into OpLog(ID, UserID, Date, Operation, Num, ClientID, Cl' +
        'ientNum, ClientName, Notes, Materials, Details) values (:p0, '#39'+'
      
        '  '#39'(select ID from Users where LastToken=:p1)'#39'+'#39', :p2, :p3, (sel' +
        'ect N'#39#39#39'+'#39'sell'#39'+'#39#1548' '#39#39'+LTrim(Str(:p4))), :p5, :p6, :p7, :p8, :p9,' +
        ' :p10)')
    Left = 600
    Top = 240
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p0'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p3'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p4'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p5'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p6'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p7'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p8'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p9'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'p10'
        Value = nil
      end>
  end
  object UniQuery3: TUniQuery
    Connection = db
    SQL.Strings = (
      
        'exec MnrAccDB_2024.dbo.mnrPrcRepMatInventory 0x0, 0x0, 0, 0x0, 0' +
        ', 0x0, 0x0, '#39#39', '#39#39', 0x0,'
      
        #39'4E1CA840-AF6C-46E4-9BE0-9664A3133F4F'#39', '#39'1980-01-01'#39', '#39'2111-01-0' +
        '1'#39', 1, 0, 0, 0, 0, 1,'
      
        #39'GrNAme, mtName, MatID'#39', 12, 1, 0, 1, 0, '#39#39', '#39#39', 0, 2, 0, 0, 0, ' +
        '0, 0, 0, 0, 0, 0, 0, 0x0, 0, 0')
    Left = 496
    Top = 408
  end
end
