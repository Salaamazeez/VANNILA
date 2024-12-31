table 50155 Retirement
{
    //Created by Salaam Azeez
    DataClassification = CustomerContent;
    LookupPageId = "Retirement List";


    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Retired Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            //  CalcFormula = sum("G/L Entry"."Amount" where("External Document No." = field("No."), "Bal. Account Type" = const(Customer)));
            CalcFormula = sum("G/L Entry"."Debit Amount" where("Document No." = field("No.")));
        }
        field(4; "Retiring Officer"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
        }
        field(7; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Editable = false;

        }
        field(9; Treated; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;

        }
        field(10; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Cash Advance",Imprest,Expense,Maintenance;
            OptionCaptionML = ENU = '" ,Cash Advance,Imprest,Expense,Maintenance"';
            InitValue = "Cash Advance";
        }
        field(11; Amount; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line".Amount where("Document No." = field("Retirement Ref.")));

        }
        field(14; Posted; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(15; "Amount (LCY)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line"."Amount (LCY)" where("Document No." = field("Retirement Ref.")));
        }
        field(16; "Currency Code"; Code[10])
        {
            TableRelation = currency.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //CashAdvance.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                if PaymentVoucherLinesExist() then
                    IF CONFIRM('Do you want to recalcute the lcy amount?', FALSE) THEN
                        UpdateAllLineCurrencyCode()
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
            end;
        }

        field(12; "Link Pmt Voucher"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Voucher Header"."No." where("Former PR No." = field("Retirement Ref.")));
        }
        field(18; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 9;
        }
        field(19; "Debit Account No."; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = IF ("Debit  Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Debit  Account Type" = CONST(Vendor)) Vendor else
            if ("Debit  Account Type" = const(Staff)) Customer where(Type = const(Staff));


            trigger OnValidate()
            begin
                CASE "Debit  Account Type" OF
                    "Debit  Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Debit Account No.");
                            "Debit Account Name" := GLAcc.Name;
                            Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");

                        END;
                    "Debit  Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Debit Account No.");
                            "Debit Account Name" := Vend.Name;
                            Validate("Shortcut Dimension 1 Code", Vend."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Vend."Global Dimension 2 Code");

                        END;
                    "Debit  Account Type"::Staff:
                        BEGIN
                            Cust.GET("Debit Account No.");
                            "Debit Account Name" := Cust.Name;
                            Validate("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");

                        END;
                    "Debit  Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Debit Account No.");
                            "Debit Account Name" := BankAccount.Name;
                            Validate("Shortcut Dimension 1 Code", BankAccount."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", BankAccount."Global Dimension 2 Code");
                        END;
                END;


            end;

        }
        field(20; "Debit Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        field(21; Purpose; Text[50])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        // field(50111; "Actual User"; Text[250])
        // {

        // }

        // field(50002; "User Code"; Code[20])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }
        // field(50012; "User Code 2"; Code[20])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code 2") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User 2" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }

        // field(30; "Actual User 2"; Text[250])
        // {

        // }
        // field(31; "User Code 3"; Code[20])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code 3") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User 3" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }


        // field(32; "Actual User 3"; Text[250])
        // {

        // }

        // field(22; "Retirement Ref."; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Cash Advance"."No." where(Type = filter("Cash Advance" | Imprest), /*Retired = const(false),*/ Requester = field("Retiring Officer"));

        //     trigger OnValidate()
        //     begin
        //         //  CAImprestMgt.SETFILTER(Status, '%1', CAImprestMgt.Status::Approved);
        //         // IF PAGE.RUNMODAL(50097, CAImprestMgt) = ACTION::LookupOK THEN BEGIN
        //         // "Purchase Requisition No." := CAImprestMgt."No.";
        //         //populate Cash Advance Header with lines from approved purch. req

        //         CAImprestMgt.SetRange("No.", "Retirement Ref.");

        //         CAImprestMgt.SetRange("No.", "Retirement Ref.");

        //         CAImprestMgt.CALCFIELDS("Total Amount");
        //         Amount := CAImprestMgt."Total Amount";
        //         Message('%1', CAImprestMgt."Total Amount");
        //         //populate Cash Advance line with lines from approved purch. req
        //         CAImprestMgtLine2.SETRANGE("Document No.", "Retirement Ref.");
        //         CAImprestMgtLine2.SetRange("Document No.", "Retirement Ref.");
        //         if CAImprestMgtLine2.FindFirst() then
        //             CAImprestMgtLine2.DeleteAll();

        //         CAImprestMgtLine.SETRANGE("Document No.", "Retirement Ref.");
        //         IF CAImprestMgtLine.FIND('-') THEN BEGIN

        //             LineNo := 1;
        //             REPEAT
        //                 //  Message('%1', CAImprestMgtLine.Quantity);
        //                 RetirementLine.Reset();

        //                 RetirementLine."Document No." := "No.";
        //                 //RetirementLine.INSERT;
        //                 //PaymentRequisitionLine.VALIDATE("Account No.",CAImprestMgtLine."Cost Account No.");
        //                 RetirementLine."Line No." := LineNo;
        //                 RetirementLine."Account Type" := CAImprestMgtLine."Account Type";
        //                 RetirementLine."Account No." := CAImprestMgtLine."Account No.";
        //                 RetirementLine."Account Name" := CAImprestMgtLine."Account Name";
        //                 RetirementLine.Amount := CAImprestMgtLine.Amount;
        //                 RetirementLine."Transaction Details" := CAImprestMgtLine."Payment Details";
        //                 RetirementLine.VALIDATE("Amount (LCY)", CAImprestMgtLine."Amount (LCY)");
        //                 RetirementLine.Modify();
        //                 LineNo += 1;
        //             UNTIL RetirementLine.NEXT = 0;
        //         END;
        //     END;




        // }
        field(22; "Retirement Ref."; Code[20])
        {
            Caption = 'Cash Advance No.';
            // Editable = false;
            //DataClassification = ToBeClassified;
            // Description = 'Approved Purchase Requisition';
            DataClassification = ToBeClassified;
            TableRelation = "Cash Advance" where(Status = filter(Approved), Requester = field("Retiring Officer"), "Transaction type" = field("Transaction type"), Retired = const(false), Posted = const(true));

            trigger OnValidate()
            begin
                GetCashAdvance
            END;
            //  end;
        }
        field(23; "Total Line Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Retirement Line".Amount WHERE("Document No." = FIELD("No.")));

        }
        field(24; Balance; Decimal)
        {
            Editable = true;
            DataClassification = ToBeClassified;

        }


        field(26; "Credit Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        field(27; "Credit Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
            // OptionCaptionML = ENU = '"G/L Account",Customer,Vendor,Bank Account,"Fixed Asset","IC Partner",Employee';
        }
        field(28; "Debit  Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Vendor,Staff,"Bank Account";
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(13; "Former Voucher"; Code[20])
        {

        }
        field(29; "Posted Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry"."Amount" where("External Document No." = field("No."), "Bal. Account Type" = filter(Customer)));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";
            trigger OnLookup()
            begin
                ShowDocDim;
            end;

        }
        field(50000; "Balance Posted"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }
        field(50006; "Cash Receipt Status"; Option)
        {
            OptionMembers = " ",Created,Posted;
        }
        field(50008; "Cash Recpt No./Pmt Voucher"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PKey; "No.")
        {
            Clustered = true;
        }
    }

    var
        LineNo: Integer;
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAcc: Record "G/L Account";
        PaymentMgtSetup: Record "Payment Mgt Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        UserSetup: Record "User Setup";
        CAImprestMgt: Record "Cash Advance";
        CAImprestMgt2: Record "Cash Advance";
        CAImprestMgtLine: Record "Cash Advance Line";
        CAImprestMgtLine2: Record "Cash Advance Line";
        RetireRec: Record Retirement;

        RetirementLine: Record "Retirement Line";
        RetirementLine2: Record "Retirement Line";
        RetirementLine3: Record "Retirement Line";
        CashAdvance: Record "Cash Advance";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TestReportPrint: Codeunit "Test Report-Print";
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        BankAccount: Record "Bank Account";
        ErrorOnPosting: TextConst ENU = 'The Document needs to be approved!';
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: TextConst ENU = 'cannot be specified without %1';

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        "Retiring Officer" := UserSetup."User ID";
        Date := TODAY;

        IF "No." = '' THEN BEGIN
            PaymentMgtSetup.GET;
            PaymentMgtSetup.TESTFIELD("Retirement Nos.");
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Retirement Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "Retiring Officer" := UserId;
        END;

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        RetirementLine2.Reset();
        RetirementLine2.SetRange("Document No.", "No.");
        if RetirementLine2.FindFirst() then
            RetirementLine2.DeleteAll();
    end;


    trigger OnRename()
    begin

    end;


    procedure PostRetirement()
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;
        //Error('a');
        RetirementLine.SETCURRENTKEY("Document No.", "Line No.");
        RetirementLine.SETRANGE("Document No.", "No.");
        IF RetirementLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := RetirementLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                if RetirementLine."Account Type" = RetirementLine."Account Type"::Staff then
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                if RetirementLine."Account Type" = RetirementLine."Account Type"::"G/L Account" then
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                if RetirementLine."Account Type" = RetirementLine."Account Type"::Vendor then
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                if RetirementLine."Account Type" = RetirementLine."Account Type"::"Bank Account" then
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Account No.", RetirementLine."Account No.");
                if "Debit  Account Type" = "Debit  Account Type"::"G/L Account" then
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                if "Debit  Account Type" = "Debit  Account Type"::Vendor then
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                if "Debit  Account Type" = "Debit  Account Type"::Staff then
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                GenJournalLine.VALIDATE("Bal. Account No.", "Debit Account No.");
                GenJournalLine."Shortcut Dimension 1 Code" := RetirementLine."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := RetirementLine."Shortcut Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
                GenJournalLine.Description := RetirementLine."Transaction Details";

                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."VAT Bus. Posting Group" := '';
                GenJournalLine."VAT Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";

                GenJournalLine.VALIDATE(Amount, RetirementLine.Amount);

                GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
                GenJournalLine.INSERT;
            UNTIL RetirementLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        END;
        CheckPostedJnl;
        ModifyPostedCAImprest;

    end;

    // procedure PostBalance()
    // begin
    //     // IF Status <> Status::Approved THEN
    //     //     ERROR(ErrorOnPosting);

    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENT');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     RetirementLine.SETRANGE("Document No.", "No.");
    //     IF RetirementLine.FINDFIRST THEN BEGIN

    //         GenJournalLine.INIT;
    //         GenJournalLine."Journal Template Name" := 'PAYMENT';
    //         GenJournalLine."Journal Batch Name" := 'DEFAULT';
    //         GenJournalLine."Line No." := RetirementLine."Line No.";
    //         GenJournalLine."Document No." := "No.";
    //         GenJournalLine.VALIDATE("Posting Date", Date);
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //         GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //         GenJournalLine."External Document No.":="No.";
    //         GenJournalLine.Description := 'Expense Retirement' + ' ' + "No." + ' ' + 'Balance';
    //         GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
    //         GenJournalLine.VALIDATE(Amount, Balance);
    //         Message('%1', Balance);
    //         GenJournalLine."Bal. Account Type" := RetirementLine."Account Type";
    //         Message('%1', RetirementLine."Account Type");
    //         GenJournalLine.VALIDATE("Bal. Account No.", RetirementLine."Account No.");
    //         GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
    //         GenJournalLine.INSERT;
    //         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);


    //     END;

    //     MESSAGE('The balance on the transaction has been moved to Journal Template Name "PAYMENT", Journal Batch Name "DEFAULT"!');

    // end;

    procedure PreviewPosting()
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        RetirementLine.SETCURRENTKEY("Document No.");
        RetirementLine.SETRANGE("Document No.", "No.");
        IF RetirementLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := RetirementLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
                GenJournalLine.Description := RetirementLine."Transaction Details";
                GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
                GenJournalLine.VALIDATE(Amount, RetirementLine.Amount);
                //GenJournalLine."Bal. Account Type" := "Credit Account Type";
                //GenJournalLine.VALIDATE("Bal. Account No.", "Credit Account No.");
                GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
                GenJournalLine.INSERT;
                COMMIT;
            UNTIL RetirementLine.NEXT = 0;
            GenJnlPost.Preview(GenJournalLine);
        END;

    end;

    procedure TestReport()
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        RetirementLine.SETCURRENTKEY("Document No.", "Line No.");
        RetirementLine.SETRANGE("Document No.", "No.");
        IF RetirementLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := RetirementLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
                GenJournalLine.Description := RetirementLine."Transaction Details";
                GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
                GenJournalLine.VALIDATE(Amount, RetirementLine.Amount);
                GenJournalLine."Bal. Account Type" := "Credit Account Type";
                // GenJournalLine.VALIDATE("Bal. Account No.", "Credit Account No.");
                GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
                GenJournalLine.INSERT;
                COMMIT;
            UNTIL RetirementLine.NEXT = 0;
            TestReportPrint.PrintGenJnlLine(GenJournalLine);
        END;

    end;

    procedure PostPrint()
    begin
        TestField(Posted, false);
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        RetirementLine.SETCURRENTKEY("Document No.", "Line No.");
        RetirementLine.SETRANGE("Document No.", "No.");
        IF RetirementLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := RetirementLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
                GenJournalLine.Description := RetirementLine."Transaction Details";
                GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
                GenJournalLine.VALIDATE(Amount, RetirementLine.Amount);
                GenJournalLine."Bal. Account Type" := "Credit Account Type";
                //GenJournalLine.VALIDATE("Bal. Account No.", "Credit Account No.");
                GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
                GenJournalLine.INSERT;
            UNTIL RetirementLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);
        END;
        CheckPostedJnl;
        ModifyPostedCAImprest;

    end;

    procedure CheckPostedJnl()
    begin
        //GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        //GLEntry.SETRANGE("Document No.", "No.");
        //IF GLEntry.FINDFIRST THEN BEGIN
        Posted := TRUE;
        MODIFY;
        //END;
    end;


    procedure ModifyPostedCAImprest()
    begin
        CAImprestMgt.GET("Retirement Ref.");
        CAImprestMgt.Retired := TRUE;
        CAImprestMgt."Retired Amount" := Amount;
        CAImprestMgt.MODIFY;
    end;

    procedure Navigate()
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc(Date, "No.");
        NavigatePage.SetRec(Rec);
        NavigatePage.Run();
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=

DimMgt.EditDimensionSet(
             "Dimension Set ID", StrSubstNo('%1 %2', 0, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if PaymentVoucherLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure PaymentVoucherLinesExist(): Boolean
    var
        IsHandled, Result : Boolean;

    begin
        IsHandled := false;
        Result := false;
        if IsHandled then
            exit(Result);

        RetirementLine.Reset();
        RetirementLine.SetRange("Document No.", "No.");
        exit(not RetirementLine.IsEmpty);
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
        IsHandled: Boolean;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;

        RetirementLine.Reset();
        RetirementLine.SetRange("Document No.", "No.");
        RetirementLine.LockTable();
        if RetirementLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(RetirementLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if RetirementLine."Dimension Set ID" <> NewDimSetID then begin
                    RetirementLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      RetirementLine."Dimension Set ID", RetirementLine."Shortcut Dimension 1 Code", RetirementLine."Shortcut Dimension 2 Code");
                    RetirementLine.Modify();
                end;
            until RetirementLine.Next() = 0;
    end;


    procedure GetCashAdvance()
    begin
        CashAdvance.Get("Retirement Ref.");
        "Debit  Account Type" := CashAdvance."Debit  Account Type";
        "Debit Account No." := CashAdvance."Debit Account No.";
        "Debit Account Name" := CashAdvance."Debit Account Name";
        "Currency Code" := CashAdvance."Currency Code";
        "Currency Factor" := CashAdvance."Currency Factor";
        Purpose := CashAdvance.Description;
        RetirementLine3.SetRange("Document No.", "No.");
        RetirementLine3.DeleteAll();
        CAImprestMgt.SetRange("No.", "Retirement Ref.");
        CAImprestMgt.CALCFIELDS("Total Amount");
        Amount := CAImprestMgt."Total Amount";
        "Former Voucher" := CAImprestMgt."Voucher No";
        "Loan ID" := CAImprestMgt."Loan ID";
        "Shortcut Dimension 1 Code" := CashAdvance."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := CashAdvance."Shortcut Dimension 2 Code";
        "Dimension Set ID" := CashAdvance."Dimension Set ID";
        //populate payment line with lines from approved purch. req
        CAImprestMgtLine.SETRANGE("Document No.", "Retirement Ref.");
        IF CAImprestMgtLine.FINDSET THEN BEGIN
            LineNo := 1;
            REPEAT
                RetirementLine.INIT;
                RetirementLine."Document No." := "No.";
                RetirementLine."Line No." := LineNo;
                RetirementLine."Account Type" := RetirementLine."Account Type"::"G/L Account";
                //RetirementLine.VALIDATE("Account No.", CAImprestMgtLine."Account No.");
                RetirementLine.Validate("Currency Code", CAImprestMgtLine."Currency Code");
                RetirementLine.Validate(Amount, CAImprestMgtLine.Amount);
                RetirementLine."Transaction Details" := CAImprestMgtLine."Payment Details";
                RetirementLine."Shortcut Dimension 1 Code" := CAImprestMgtLine."Shortcut Dimension 1 Code";
                RetirementLine."Shortcut Dimension 2 Code" := CAImprestMgtLine."Shortcut Dimension 2 Code";
                RetirementLine."Dimension Set ID" := CAImprestMgtLine."Dimension Set ID";
                RetirementLine.Insert();
                LineNo += 1;
            UNTIL CAImprestMgtLine.NEXT = 0;
        END;
        OnMoveDocAttachFromCashAdvanceToRetirement(CashAdvance, Rec)
    END;
    //  end;

    procedure MarkAllWhereUserisUserIDOrDepartment()
    var
        UserSetup: Record "User Setup";
        IsHandled: Boolean;
    begin
        if UserSetup.Get(UserId) and UserSetup."Finance Admin" then
            exit;

        FilterGroup(-1); //Used to support the cross-column search
        SetRange("Retiring Officer", UserId);
        if FindSet() then
            repeat
                Mark(true);
            until Next() = 0;
        MarkedOnly(true);
        FilterGroup(0);
    end;

    local procedure UpdateAllLineCurrencyCode()
    var
        RetireAmt: Decimal;
    begin

        if "Currency Code" = xRec."Currency Code" then
            exit;

        RetirementLine.Reset();
        RetirementLine.SetRange("Document No.", "No.");
        RetirementLine.LockTable();
        if RetirementLine.Find('-') then
            repeat
                RetireAmt := RetirementLine.Amount;
                RetirementLine.Validate("Currency Code", "Currency Code");
                RetirementLine.Validate(Amount, RetireAmt);
                RetirementLine.Modify();
            until RetirementLine.Next() = 0;
    end;

    procedure TestMandatoryFields()
    var
        RetirementLine: Record "Retirement Line";
        Error001: Label '%1 cannot be empty on line no. %2';
        Error002: Label '%1 cannot be 0';
        Err001: Label 'Kindly select a %1 value';
        Err002: Label 'Kindly input a %1 value';
    begin
        //Rec.TestField(Status, Rec.Status::Approved);
        // if Rec."Transaction type" = Rec."Transaction type"::" " then
        //     Error(Err001, Rec.FieldCaption("Transaction type"));
        if Rec."Transaction type" = Rec."Transaction type"::Loan then
            TestField("Loan ID");
        Rec.TestField("Debit Account No.");
        Rec.TestField("Shortcut Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.CalcFields(Amount);
        if Rec.Amount = 0 then
            Error(Error002, Rec.FieldCaption(Amount));
        RetirementLine.SetRange("Document No.", Rec."No.");
        RetirementLine.FindFirst();
        repeat
            if RetirementLine."Account No." = '' then
                Error(Error001, RetirementLine.FieldCaption("Account No."), RetirementLine.FieldCaption("Line No."));
            if RetirementLine."Shortcut Dimension 1 Code" = '' then
                Error(Error001, RetirementLine.FieldCaption("Shortcut Dimension 1 Code"), RetirementLine.FieldCaption("Line No."));
            if RetirementLine."Shortcut Dimension 2 Code" = '' then
                Error(Error001, RetirementLine.FieldCaption("Shortcut Dimension 2 Code"), RetirementLine.FieldCaption("Line No."));
            if RetirementLine."Transaction Details" = '' then
                Error(Error001, RetirementLine.FieldCaption("Transaction Details"), RetirementLine.FieldCaption("Line No."));
        until RetirementLine.Next() = 0;

    end;

    [IntegrationEvent(false, false)]
    procedure OnMoveDocAttachFromCashAdvanceToRetirement(var Rec1: Record "Cash Advance"; var Rec2: Record Retirement)
    begin
    end;
}