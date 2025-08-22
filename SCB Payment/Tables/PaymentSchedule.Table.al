Table 90223 "Payment Schedule"
{
    DrillDownPageID = "Payment Schedules";
    LookupPageID = "Payment Schedules";

    fields
    {
        field(1; "Source Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Source Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Payee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payee Bank"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payee Account No."; Text[30])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Payee Account No." <> '' then
                    if "CBN Bank Code" <> '' then
                        if CheckNubanStatus("Payee Account No.", "CBN Bank Code") <> 'Valid Nuban' then
                            Error(CheckNubanStatus("Payee Account No.", "CBN Bank Code"));
            end;

        }
        field(7; "Payee Bank Branch"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Payee Bank SORT-CODE"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "G/L Account No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Posting Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Payee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Entries Type" = filter(Employee)) Employee."No." where(Status = const(Active))
            else
            if ("Entries Type" = const("Saved Beneficiary")) "Payment Schedule"."Payee No." where("Save Beneficiary" = const(true));
            // else
            // if ("Entries Type" = const("Payroll Entries")) "Payroll-Employee"."No." where("Appointment Status" = const(Active));
        }
        field(28; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(29; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Last Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(32; "CBN Bank Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank";

            trigger OnValidate()
            begin
                if "Payee Account No." <> '' then
                    if "CBN Bank Code" <> '' then
                        if CheckNubanStatus("Payee Account No.", "CBN Bank Code") <> 'Valid Nuban' then
                            Error(CheckNubanStatus("Payee Account No.", "CBN Bank Code"));
                if CBNBankCodes.Get("CBN Bank Code") then
                    Validate("Payee Bank", CBNBankCodes."Name")
                else
                    Clear("Payee Bank");
            end;
        }
        field(33; "Entries Type"; Option)
        {
            OptionCaption = 'Payroll Entries,Imported Entries,IC Partner,Saved Beneficiary,Imputed Entry,Employee';
            OptionMembers = "Payroll Entries","Imported Entries","IC Partner","Saved Beneficiary","Imputed Entry",Employee;
            DataClassification = CustomerContent;
        }
        field(35; "IC Partner Code"; Code[10])
        {
            Editable = false;
            TableRelation = if ("Entries Type" = filter("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }
        field(36; Paid; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(37; "Occurance Of Payee No."; Integer)
        {

            CalcFormula = count("Payment Schedule" where("Source Document No." = field("Source Document No."),
                                                          "Payee No." = field("Payee No.")));
            FieldClass = FlowField;
        }
        field(39; "Save Beneficiary"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(42; "Payee BVN"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(43; "Debit Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account" where("Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"),
                                                  "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code"));

            trigger OnValidate()
            begin
                if "Debit Bank Account No." <> '' then begin
                    BankAccountRec.Get("Debit Bank Account No.");
                    Validate("Debit Bank", BankAccountRec."Bank Name");
                    Validate("Debit Bank Account Name", BankAccountRec.Name);
                    Validate("Debit Bank Code", BankAccountRec."Bank Code");
                end else begin
                    Clear("Debit Bank");
                    Clear("Debit Bank Account Name");
                    Clear("Debit Bank Code");
                end;
            end;
        }
        field(44; "Debit Bank"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(46; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                //
                //ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }

        field(47; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(48; "Debit Bank Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Custodian Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50; "Direction In Bank Acct"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Debit In Bank,Credit In Bank';
            OptionMembers = " ","Debit In Bank","Credit In Bank";
        }
        field(52; "Debit Bank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank";
        }
        field(501; "Schedule Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(502; "General Journal Template"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Template";
        }
        field(503; "General Journal Batch"; Text[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("General Journal Template"));
        }
        field(227; "Dimension Set ID Beneficiary"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(507; "Schedule Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Payment Memo,Cash Advance,Retirement';
            OptionMembers = "Payment Memo","Cash Advance",Retirement;
        }
        field(52132628; "Payment Option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Transfer,Payment';
            OptionMembers = " ",Transfer,Payment;
        }
    }

    keys
    {
        key(Key1; "Source Document No.", "Source Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GeneralJournalLine.Get(0, "Source Document No.");
        //PaymentHeader.Get(0, "Source Document No.");
        //PaymentHeader.TestField(Status, PaymentHeader.Status::Open);
    end;

    trigger OnInsert()
    begin
        "Date Created" := CreateDatetime(Today, Time);
        "Created By" := Format(UserId);
    end;

    trigger OnModify()
    begin
        //GeneralJournalLine.Get(GeneralJournalLine."Document Type"::Payment, "Source Document No.");
        //PaymentHeader.Get(PaymentHeader."document type"::"Payment Voucher", "Source Document No.");
        //PaymentHeader.TestField(Status, PaymentHeader.Status::Open);
        "Last Modified Date" := CreateDatetime(Today, Time);
        "Last Modified By" := Format(UserId);
    end;

    var
        CBNBankCodes: Record "Bank";
        MyExcelBuffer: Record "Excel Buffer";
        GeneralJournalLine: Record "Gen. Journal Line";
        PaymentScheduleRec: Record "Payment Schedule";
        PVDocumentNo: Code[20];
        FirstDataRowNo: Integer;
        LastColumnNo: Integer;
        LastRowNo: Integer;
        PVDocumentNoLineNo: Integer;
        ServerFileName: Text;
        LineNo: Integer;
        GloblalTemplateName: Code[10];
        GlobalBatchName: Code[10];
        BankAccountRec: Record "Bank Account";

    procedure GetValue(RowID: Integer; ColumnID: Integer): Text
    begin
        if MyExcelBuffer.Get(RowID, ColumnID) then
            exit(MyExcelBuffer."Cell Value as Text")
    end;


    procedure InsertValues(RowID: Integer)
    var
        PaymentBankCBNCodes: Record "Bank";
        AmountToPay: Decimal;
        ValidMsg: Label '%1 Is not a valid NUBAN', Comment = '%1 = (RowID, 4)';
    begin
        if not Evaluate(AmountToPay, GetValue(RowID, 5)) then
            exit;
        if AmountToPay = 0 then
            exit;
        if CheckNubanStatus(GetValue(RowID, 4), Format(GetValue(RowID, 3))) <> 'Valid Nuban' then
            Error(ValidMsg, GetValue(RowID, 4));

        PaymentScheduleRec.Init();
        PaymentScheduleRec."Source Document No." := PVDocumentNo;
        PaymentScheduleRec."Source Line No." := PVDocumentNoLineNo;
        PaymentScheduleRec."General Journal Template" := GloblalTemplateName;
        PaymentScheduleRec."General Journal Batch" := GlobalBatchName;
        LineNo := LineNo + 10000;
        PaymentScheduleRec."Line No." := LineNo;
        PaymentScheduleRec."Entries Type" := PaymentScheduleRec."entries type"::"Imported Entries";
        PaymentScheduleRec."Payee No." := Format(GetValue(RowID, 1));
        PaymentScheduleRec."Payee Name" := Format(GetValue(RowID, 2));
        //PaymentBankCBNCodes.Get(GetValue(RowID, 3));
        //PaymentScheduleRec."CBN Bank Code" := PaymentBankCBNCodes.Code;
        PaymentScheduleRec."CBN Bank Code" := Format(GetValue(RowID, 3));
        PaymentScheduleRec."Payee Bank" := PaymentBankCBNCodes."Name";
        Evaluate(PaymentScheduleRec.Amount, GetValue(RowID, 5));
        PaymentScheduleRec.Insert(true);
        PaymentScheduleRec.Validate("Payee Account No.", GetValue(RowID, 4));
        PaymentScheduleRec."Posting Description" := Format(GetValue(RowID, 6));
        PaymentScheduleRec.Modify();
    end;

    local procedure SelectFile(): Boolean
    var
        FileMgt: Codeunit "File Management";
        SheetName: Text;
        IStream: InStream;
        FromFile: Text;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            ServerFileName := FileMgt.GetFileName(FromFile);
            SheetName := MyExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        MyExcelBuffer.Reset();
        MyExcelBuffer.DeleteAll();
        MyExcelBuffer.OpenBookStream(IStream, SheetName);
        MyExcelBuffer.ReadSheet();
        if ServerFileName = '' then
            exit(false)
        else begin
            GetLastRowAndColumn();
            exit(true);
        end;
    end;


    procedure ImportStdExcel(PVNo: Code[20]; PVLineno: Integer; GLAccNo: Code[20]; TemplateName: Code[10]; BatchName: Code[10])
    var
        x: Integer;
    begin
        GloblalTemplateName := TemplateName;
        GlobalBatchName := BatchName;
        PVDocumentNo := PVNo;
        PVDocumentNoLineNo := PVLineno;
        if SelectFile() then
            for x := FirstDataRowNo to LastRowNo do
                InsertValues(x);
    end;

    procedure ReadExcelSheet()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        FileName: Text;
        SheetName: Text[250];
        NoFileFoundMsg: Label 'No Excel file found!';
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    // procedure ImportPaymentScheduleData()   //Import Payment Schedule
    // var
    //     Rec_PurchLine: Record "Purchase Line";
    //     RowNo: Integer;
    //     ColNo: Integer;
    //     LineNo: Integer;
    //     MaxRowNo: Integer;
    //     GLAccount: Record "G/L Account";
    //     Window: Dialog;
    //     Text001: TextConst ENU = 'Purchase line uploading';
    //     RecNo: Integer;
    //     TotalRecNo: Integer;
    // begin
    //     Window.OPEN(
    //     Text001 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
    //     Window.UPDATE(1, 0);
    //     TotalRecNo := Rec_PurchLine.Count;
    //     RowNo := 0;
    //     ColNo := 0;
    //     MaxRowNo := 0;
    //     LineNo := 0;
    //     Rec_PurchLine.Reset();
    //     if Rec_PurchLine.FindLast() then
    //         LineNo := Rec_PurchLine."Line No.";
    //     TempExcelBuffer.Reset();
    //     if TempExcelBuffer.FindLast() then begin
    //         MaxRowNo := TempExcelBuffer."Row No.";
    //     end;

    //     for RowNo := 2 to MaxRowNo do begin
    //         RecNo += 1;
    //         Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
    //         // MODIFY TRIP ANALYSIS
    //         /*  if Rec_PurchLine.Get(GetValueAtCell(RowNo, 1), GetValueAtCell(RowNo, 2), GetValueAtCell(RowNo, 3)) then begin
    //              Evaluate(Rec_PurchLine.Type, GetValueAtCell(RowNo, 4));
    //              Rec_PurchLine.Validate(Type);
    //              Evaluate(Rec_PurchLine."No.", GetValueAtCell(RowNo, 5));
    //              Rec_PurchLine.Validate("No.");
    //              Evaluate(Rec_PurchLine."Location Code", GetValueAtCell(RowNo, 6));
    //              Rec_PurchLine.Validate("Location Code");
    //              Evaluate(Rec_PurchLine.Quantity, GetValueAtCell(RowNo, 7));
    //              Rec_PurchLine.Validate(Quantity);
    //              Evaluate(Rec_PurchLine."Direct Unit Cost", GetValueAtCell(RowNo, 8));
    //              Rec_PurchLine.Validate("Direct Unit Cost");
    //              Evaluate(Rec_PurchLine."VAT Amount(Manual)", GetValueAtCell(RowNo, 9));
    //              Rec_PurchLine.Validate("VAT Amount(Manual)");
    //              Evaluate(Rec_PurchLine."WHT Code", GetValueAtCell(RowNo, 10));
    //              Rec_PurchLine.Validate("WHT Code");
    //              Evaluate(Rec_PurchLine."Leased Asset Class", GetValueAtCell(RowNo, 11));
    //              Rec_PurchLine.Validate("Leased Asset Class");
    //              Evaluate(Rec_PurchLine."Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
    //              Rec_PurchLine.Validate("Shortcut Dimension 1 Code");
    //              Evaluate(Rec_PurchLine."Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
    //              Rec_PurchLine.Validate("Shortcut Dimension 2 Code");
    //              Rec_PurchLine.Modify(true);

    //          end */
    //         //else

    //         begin
    //             LineNo := LineNo + 10000;
    //             Rec_PurchLine.Init();
    //             Evaluate(Rec_PurchLine."Document Type", GetValueAtCell(RowNo, 1));
    //             Evaluate(Rec_PurchLine."Document No.", GetValueAtCell(RowNo, 2));
    //             Evaluate(Rec_PurchLine."Line No.", GetValueAtCell(RowNo, 3));
    //             Evaluate(Rec_PurchLine.Type, GetValueAtCell(RowNo, 4));
    //             Rec_PurchLine.Validate(Type);
    //             Evaluate(Rec_PurchLine."No.", GetValueAtCell(RowNo, 5));
    //             Rec_PurchLine.Validate("No.");
    //             IF PurchLine.Type = PurchLine.Type::"G/L Account" then begin
    //                 IF GLAccount.Get(Rec_PurchLine."No.") then
    //                     Rec_PurchLine.Validate(Description, GLAccount.Name);
    //             end;



    //             Evaluate(Rec_PurchLine."Location Code", GetValueAtCell(RowNo, 6));
    //             Rec_PurchLine.Validate("Location Code");
    //             Evaluate(Rec_PurchLine.Quantity, GetValueAtCell(RowNo, 7));
    //             Rec_PurchLine.Validate(Quantity);
    //             Evaluate(Rec_PurchLine."Direct Unit Cost", GetValueAtCell(RowNo, 8));
    //             IF Rec_PurchLine."Direct Unit Cost" <> 0 then
    //                 Rec_PurchLine.Validate("Line Amount", (Rec_PurchLine.Quantity * Rec_PurchLine."Direct Unit Cost"));
    //             Evaluate(Rec_PurchLine."VAT Amount(Manual)", GetValueAtCell(RowNo, 9));
    //             Rec_PurchLine.Validate("VAT Amount(Manual)");

    //             Evaluate(Rec_PurchLine."WHT Code", GetValueAtCell(RowNo, 10));
    //             Rec_PurchLine.Validate("WHT Code");
    //             if Rec_PurchLine."WHT Code" <> '' then
    //                 Rec_PurchLine.Validate("WHT Amount", ((Rec_PurchLine."WHT Rate" * 0.01) * (Rec_PurchLine."Line Amount" - Rec_PurchLine."VAT Amount(Manual)")));
    //             Evaluate(Rec_PurchLine."Leased Asset Class", GetValueAtCell(RowNo, 11));
    //             Rec_PurchLine.Validate("Leased Asset Class");
    //             Evaluate(Rec_PurchLine."Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
    //             Rec_PurchLine.Validate("Shortcut Dimension 1 Code");
    //             Evaluate(Rec_PurchLine."Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
    //             Rec_PurchLine.Validate("Shortcut Dimension 2 Code");
    //             Rec_PurchLine.Insert(true);
    //         end;




    //     end;
    // END;

    procedure GetLastRowAndColumn()
    begin
        MyExcelBuffer.FindLast();
        LastColumnNo := MyExcelBuffer."Column No.";
        LastRowNo := MyExcelBuffer."Row No.";
    end;


    procedure GetFirstDataRowNo()
    begin
        MyExcelBuffer.SetRange("Column No.", LastColumnNo);
        if MyExcelBuffer.FindFirst() then
            FirstDataRowNo := MyExcelBuffer."Row No." + 1;
    end;

    procedure CheckNubanStatus(EmpNuban: Text; BankCode: Code[20]) NUBAN_Status: Text
    var
        A: Integer;
        B: Integer;
        C: Integer;
        D: Integer;
        E: Integer;
        F: Integer;
        G: Integer;
        H: Integer;
        I: Integer;
        J: Integer;
        K: Integer;
        L: Integer;
        M: Integer;
        A_String: Text;
        B_String: Text;
        C_String: Text;
        D_String: Text;
        E_String: Text;
        F_String: Text;
        G_String: Text;
        H_String: Text;
        I_String: Text;
        J_String: Text;
        K_String: Text;
        L_String: Text;
        M_String: Text;
        //NubanStatus: Option "Valid Nuban","Invalid Nuban";
        BankCodeAndNuban: Text[15];
        ModOften: Integer;
        Remainder: Integer;
        CheckDigit: Integer;
    begin
        BankCodeAndNuban := '';
        if BankCode = '' then
            Error('Bank Code Must have a value');
        if BankCode = '001' then
            exit;
        if StrLen(EmpNuban) <> 10 then
            Error('Nuban Account Number Must Be 10 digit');
        A := 0;
        B := 0;
        C := 0;
        D := 0;
        E := 0;
        F := 0;
        G := 0;
        H := 0;
        I := 0;
        J := 0;
        K := 0;
        L := 0;
        M := 0;

        A_String := '';
        B_String := '';
        C_String := '';
        D_String := '';
        E_String := '';
        F_String := '';
        G_String := '';
        H_String := '';
        I_String := '';
        J_String := '';
        K_String := '';
        L_String := '';
        M_String := '';

        BankCodeAndNuban := BankCode + EmpNuban;

        A_String := CopyStr(BankCodeAndNuban, 1, 1);
        B_String := CopyStr(BankCodeAndNuban, 2, 1);
        C_String := CopyStr(BankCodeAndNuban, 3, 1);
        D_String := CopyStr(BankCodeAndNuban, 4, 1);
        E_String := CopyStr(BankCodeAndNuban, 5, 1);
        F_String := CopyStr(BankCodeAndNuban, 6, 1);
        G_String := CopyStr(BankCodeAndNuban, 7, 1);
        H_String := CopyStr(BankCodeAndNuban, 8, 1);
        I_String := CopyStr(BankCodeAndNuban, 9, 1);
        J_String := CopyStr(BankCodeAndNuban, 10, 1);
        K_String := CopyStr(BankCodeAndNuban, 11, 1);
        L_String := CopyStr(BankCodeAndNuban, 12, 1);
        M_String := CopyStr(BankCodeAndNuban, 13, 1);

        Evaluate(A, A_String);
        Evaluate(B, B_String);
        Evaluate(C, C_String);
        Evaluate(D, D_String);
        Evaluate(E, E_String);
        Evaluate(F, F_String);
        Evaluate(G, G_String);
        Evaluate(H, H_String);
        Evaluate(I, I_String);
        Evaluate(J, J_String);
        Evaluate(K, K_String);
        Evaluate(L, L_String);
        Evaluate(M, M_String);

        ModOften := (A * 3 + B * 7 + C * 3 + D * 3 + E * 7 + F * 3 + G * 3 + H * 7 + I * 3 + J * 3 + K * 7 + L * 3);

        Remainder := ModOften MOD 10;
        IF Remainder = 0 THEN
            CheckDigit := 0
        ELSE
            CheckDigit := 10 - Remainder;
        IF CheckDigit = M THEN
            NUBAN_Status := 'Valid Nuban'
        ELSE
            NUBAN_Status := 'Invalid Nuban';
    end;


    procedure GetNextLineNo(PVDocNo: Code[20]; PVLineNo: Integer): Integer
    var
        MyPaymentSchedule: Record "Payment Schedule";
    begin
        MyPaymentSchedule.SetRange("Source Document No.", PVDocNo);
        MyPaymentSchedule.SetRange("Source Line No.", PVLineNo);
        if MyPaymentSchedule.FindLast() then
            exit(MyPaymentSchedule."Line No." + 1000)
        else
            exit(1000);
    end;

    
}

