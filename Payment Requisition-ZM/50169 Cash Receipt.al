table 50169 "Cash Receipt"
{
    //Created by Akande
    Caption = 'Cash Receipt (Retirement)';
    DataClassification = CustomerContent;
    LookupPageId = "Cash Receipt List";


    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        field(2; "Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Retiring Officer"; Text[60])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
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
            Editable = false;
        }
        field(11; Amount; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line".Amount where("Document No." = field("Retirement Ref.")));
            // DataClassification = ToBeClassified;
            // Editable = false;


        }
        field(13; "Retirement No."; Code[20])
        {

        }
        field(14; Posted; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;

        }
        field(15; "Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line"."Amount (LCY)" where("Document No." = field("Retirement Ref.")));
            Editable = false;
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

        field(3; "Retired Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry"."Debit Amount" where("Document No." = field("No.")));
        }
        field(12; "Link Pmt Voucher"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Voucher Header"."No." where("Former PR No." = field("Retirement Ref.")));
        }
        field(18; "Exchange Rate"; Decimal)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 9;
        }
        field(19; "Debit Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = IF ("Debit  Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Debit  Account Type" = CONST(Vendor)) Vendor else
            if ("Debit  Account Type" = const(Staff)) Customer where(Type = const(Staff)) else
            if ("Debit  Account Type" = const("Bank Account")) "Bank Account" where("Currency Code" = field("Currency Code"));
            //DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CASE "Debit  Account Type" OF
                    "Debit  Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Debit Account No.");
                            "Debit Account Name" := GLAcc.Name;
                            // Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            // Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");
                        END;
                    "Debit  Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Debit Account No.");
                            "Debit Account Name" := Vend.Name;
                            // Validate("Shortcut Dimension 1 Code", Vend."Global Dimension 1 Code");
                            // Validate("Shortcut Dimension 2 Code", Vend."Global Dimension 2 Code");

                        END;
                    "Debit  Account Type"::Staff:
                        BEGIN
                            Cust.GET("Debit Account No.");
                            "Debit Account Name" := Cust.Name;
                            // Validate("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            // Validate("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");

                        END;
                    "Debit  Account Type"::"Bank Account":
                        BEGIN
                            BankAcc.GET("Debit Account No.");
                            "Debit Account Name" := BankAcc.Name;
                            // Validate("Shortcut Dimension 1 Code", BankAcc."Global Dimension 1 Code");
                            // Validate("Shortcut Dimension 2 Code", BankAcc."Global Dimension 2 Code");
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
        field(50000; "Balance Posted"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

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
            //DataClassification = ToBeClassified;
            // Description = 'Approved Purchase Requisition';
            DataClassification = ToBeClassified;
            TableRelation = "Cash Advance"."No." where("Transaction type" = filter("Staff Adv"), /*Retired = const(false),*/ Requester = field("Retiring Officer"));

            // trigger OnValidate()
            // begin
            //     //  CAImprestMgt.SETFILTER(Status, '%1', CAImprestMgt.Status::Approved);
            //     // IF PAGE.RUNMODAL(50097, CAImprestMgt) = ACTION::LookupOK THEN BEGIN
            //     // "Purchase Requisition No." := CAImprestMgt."No.";
            //     CAImprestMgt.SetRange("No.", "Retirement Ref.");
            //     CAImprestMgt.CALCFIELDS("Total Amount");
            //     Amount := CAImprestMgt."Total Amount";
            //     Message('%1', CAImprestMgt."Total Amount");
            //     //populate payment line with lines from approved purch. req
            //     CAImprestMgtLine.SETRANGE("Document No.", "Retirement Ref.");
            //     IF CAImprestMgtLine.FINDSET THEN BEGIN
            //         LineNo := 1;
            //         REPEAT
            //             RetirementLine.INIT;
            //             RetirementLine."Document No." := "No.";
            //             RetirementLine."Line No." := LineNo;
            //             RetirementLine.INSERT;
            //             RetirementLine.VALIDATE("Account No.", CAImprestMgtLine."Account No.");
            //             RetirementLine.Amount := CAImprestMgtLine.Amount;
            //             RetirementLine."Transaction Details" := COPYSTR(STRSUBSTNO('Payment for %1'), 1, MAXSTRLEN(CAImprestMgtLine."Payment Details"));
            //             RetirementLine.VALIDATE("Amount (LCY)", CAImprestMgtLine."Amount (LCY)");
            //             RetirementLine.MODIFY;
            //             // Message('%1', CAImprestMgtLine.Quantity);
            //             LineNo += 1;
            //         UNTIL CAImprestMgtLine.NEXT = 0;
            //     END;
            // END;
            //  end;
        }
        field(23; "Total Line Amount"; Decimal)
        {
            Caption = 'Retirement Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Retirement Line".Amount WHERE("Document No." = FIELD("Retirement No.")));
            Editable = false;
        }
        field(24; Balance; Decimal)
        {
            // Caption = 'Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Currency Code" = '' THEN
                    "Balance (LCY)" := Balance
                ELSE BEGIN
                    VALIDATE("Balance (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                     Date, "Currency Code", Balance, "Currency Factor"))));
                END;
            end;

        }
        field(25; "Credit Account No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Credit Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Credit Account Type" = CONST(Staff)) Customer where(Type = const(Staff)) else
            if ("Credit Account Type" = const(Vendor)) Vendor else
            if ("Credit Account Type" = const("Bank Account")) "Bank Account";
            //DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CASE "Credit Account Type" OF
                    "Credit Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Credit Account No.");
                            "Credit Account Name" := GLAcc.Name;
                        END;
                    "Credit Account Type"::Staff:
                        BEGIN
                            Cust.GET("Credit Account No.");
                            "Credit Account Name" := Cust.Name;
                        END;
                    "Credit Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Credit Account No.");
                            "Credit Account Name" := Vend.Name;
                        END;
                    "Credit Account Type"::"Bank Account":
                        BEGIN
                            BankAcc.GET("Credit Account No.");
                            "Credit Account Name" := BankAcc.Name;
                        END;
                END;


            end;

        }
        field(26; "Credit Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            //Editable = false;

        }
        field(27; "Credit Account Type"; Option)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Staff,Vendor,"Bank Account";
        }
        field(28; "Debit  Account Type"; Option)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Vendor,Staff,"Bank Account";
            InitValue = "Bank Account";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                Rec.ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }

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

        field(29; "Actual User 2"; Text[250])
        {
            Enabled = false;
        }

        field(31; "Actual User 3"; Text[250])
        {
            Enabled = false;
        }
        field(32; "Balance (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }

    }

    keys
    {
        key(PKey; "No.")
        {
            Clustered = true;
        }
    }

    var
        CashReceiptLine: Record "Cash Receipt Line";
        LineNo: Integer;
        BankAcc: Record "Bank Account";
        Vend: Record Vendor;
        Cust: Record Customer;
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

        CashRcpt: Record "Cash Receipt";
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
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Cash Receipt Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "Retiring Officer" := UserId;
        END;

    end;

    trigger OnModify()
    begin
        //TestField("User Code");
    end;

    trigger OnDelete()
    begin
        CashReceiptLine.Reset();
        CashReceiptLine.SetRange("Document No.", "No.");
        if CashReceiptLine.FindFirst() then

            //Message(PaymentReqLine."Document No.");
            CashReceiptLine.DeleteAll();
        //Message(PaymentReqLine."Document No.");

    end;

    trigger OnRename()
    begin

    end;

    // procedure ShowDocDim()
    // var
    //     OldDimSetID: Integer;
    // begin
    //     OldDimSetID := "Dimension Set ID";
    //     "Dimension Set ID" :=
    //    // DimMgt.EditDimensionSet(
    //         "Dimension Set ID", STRSUBSTNO('%1', "No."),
    //         "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    //     IF OldDimSetID <> "Dimension Set ID" THEN
    //         MODIFY;
    // end;


    procedure PostBalance()
    begin
        // IF Status <> Status::Approved THEN
        //     ERROR(ErrorOnPosting);
        TestField(Purpose);
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        CashRcpt.SETRANGE("No.", "No.");
        IF CashRcpt.FINDFIRST THEN BEGIN

            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DEFAULT';
            GenJournalLine."Line No." := 10000;
            GenJournalLine."Document No." := "No.";
            GenJournalLine.VALIDATE("Posting Date", Date);
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            GenJournalLine.VALIDATE("Account No.", "Credit Account No.");
            GenJournalLine.Description := Purpose;
            GenJournalLine."External Document No." := "Retirement No.";
            GenJournalLine."Dimension Set ID" := CashRcpt."Dimension Set ID";
            GenJournalLine.VALIDATE(Amount, -Balance);
            if CashRcpt."Debit  Account Type" = CashRcpt."Debit  Account Type"::"Bank Account" then
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
            if CashRcpt."Debit  Account Type" = CashRcpt."Debit  Account Type"::"G/L Account" then
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            if CashRcpt."Debit  Account Type" = CashRcpt."Debit  Account Type"::"G/L Account" then
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Customer;
            if CashRcpt."Debit  Account Type" = CashRcpt."Debit  Account Type"::"G/L Account" then
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
            GenJournalLine.VALIDATE("Bal. Account No.", "Debit Account No.");
            GenJournalLine.VALIDATE("Currency Code", CashRcpt."Currency Code");
            GenJournalLine."Balance Posted" := "Balance Posted";
            GenJournalLine.INSERT;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);


        END;
        CashRcpt.Posted := true;
        CashRcpt.Modify();
        MESSAGE('The balance on the transaction has been has been posted');

    end;





    // procedure PostPrint()
    // begin
    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     RetirementLine.SETCURRENTKEY("Document No.", "Line No.");
    //     RetirementLine.SETRANGE("Document No.", "No.");
    //     IF RetirementLine.FINDFIRST THEN BEGIN
    //         REPEAT
    //             GenJournalLine.INIT;
    //             GenJournalLine."Journal Template Name" := 'PAYMENTS';
    //             GenJournalLine."Journal Batch Name" := 'DEFAULT';
    //             GenJournalLine."Line No." := RetirementLine."Line No.";
    //             GenJournalLine."Posting Date" := Date;
    //             GenJournalLine."Document No." := "No.";
    //             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //             GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //             GenJournalLine.Description := RetirementLine."Transaction Details";
    //             GenJournalLine."Dimension Set ID" := RetirementLine."Dimension Set ID";
    //             GenJournalLine.VALIDATE(Amount, RetirementLine.Amount);
    //             GenJournalLine."Bal. Account Type" := "Credit Account Type";
    //             GenJournalLine.VALIDATE("Bal. Account No.", "Credit Account No.");
    //             GenJournalLine.VALIDATE("Currency Code", RetirementLine."Currency Code");
    //             GenJournalLine.INSERT;
    //         UNTIL RetirementLine.NEXT = 0;
    //         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);
    //     END;
    //     CheckPostedJnl;
    //     ModifyPostedCAImprest;

    // end;

    procedure CheckPostedJnl()
    begin
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN BEGIN
            Posted := TRUE;
            MODIFY;
        END;
    end;

    procedure ModifyPostedCAImprest()
    begin
        CAImprestMgt.GET("Retirement Ref.");
        CAImprestMgt.Retired := TRUE;
        CAImprestMgt.MODIFY;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();

        if OldDimSetID <> "Dimension Set ID" then begin
            if not IsNullGuid(Rec.SystemId) then
                Modify();
        end;

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
        end;
    end;










}