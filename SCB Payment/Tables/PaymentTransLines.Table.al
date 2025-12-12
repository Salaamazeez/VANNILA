Table 90220 "Payment Schedule Line"
{

    fields
    {
        field(4; "Batch Number"; Code[20])
        {
            Description = 'Unique Batch Details no, Part of the Primary Key';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Currency Code"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; "Bank CBN Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            Editable = true;
            TableRelation = "Bank";

            trigger OnValidate()
            begin
                if "Bank CBN Code" <> '' then begin
                    CBNBanks.Get("Bank CBN Code");
                    "Bank Name" := CBNBanks."Name";
                end;
            end;
        }
        field(16; "Reference Number"; Code[35])
        {
            DataClassification = EndUserIdentifiableInformation;
            Description = 'Unique Ref no., Part of the Primary Key';
            Editable = false;
        }
        field(17; TransactionType; Option)
        {
            OptionCaption = '50';
            OptionMembers = "50";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(18; "To Account Number"; Code[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(19; "To Account Type"; Option)
        {
            OptionCaption = '10,20';
            OptionMembers = "10","20";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(20; Amount; Decimal)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(21; Surcharge; Decimal)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(22; Description; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(23; "Bank Name"; Text[100])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(26; "Interswitch Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Created,Error cannot process,In Queue/Still Processing,Processed Ok,Processed with Error';
            OptionMembers = "-1","0","1","2","3";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(27; "Line No."; Integer)
        {
            Description = 'Part of the Primary Key';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(28; "Date Created"; DateTime)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(29; "Created By"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(30; "Last Modified By"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(31; "Last Modified Date"; DateTime)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(32; "Source No."; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(33; "Source Type"; Option)
        {
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = 'Bank Account,Vendor,Staff,Customer,Import,Retieree,Pension Fund Administrator';
            OptionMembers = "Bank Account",Vendor,Staff,Customer,Import,Retieree,"Pension Fund Administrator";
        }
        field(34; Payee; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(35; "Reference Type"; Option)
        {
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = ' ,Gen Journal,Payroll,Voucher';
            OptionMembers = " ","Gen Journal",Payroll,Voucher;
        }
        field(36; "Record ID"; RecordID)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(37; Posted; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(38; "Old Reference Number"; Code[25])
        {
            DataClassification = EndUserIdentifiableInformation;
            Description = 'To keep the last reference no if copied to another batch';
            Editable = false;
        }
        field(39; Status; Code[10])
        {
            
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Status';
            Editable = false;
        }
        field(40; "Status Description"; Text[250])
        {
            Caption = ' Status Description';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(41; "Reason Code"; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(42; Processed; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(43; "Payee No."; Code[30])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = if ("Source Type" = filter(Staff)) Employee
            else
            if ("Source Type" = filter(Vendor)) Vendor
            else
            if ("Source Type" = filter(Customer)) Customer
            else
            if ("Source Type" = filter("Bank Account")) "Bank Account";
            // else
            // if ("Source Type" = filter("Pension Fund Administrator")) "Pension Administrator";
        }
        field(44; "Payee BVN"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(45; "Uploaded Schedule Page No."; Integer)
        {
            Description = 'This is the page number used to upload this record';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(46; "Uploaded Schedule Serial No."; Integer)
        {
            Description = 'This is the serial number used to upload this record';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(47; "Reason Information Text"; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(48; "Uploaded Status Code"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(49; "Payment Batch"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50; "Schedule Page No."; Integer)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(51; "Schedule Serial No."; Integer)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(52; Stan; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(53; "Date Time Created"; DateTime)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(54; "Value Date"; Date)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(55; "From Account Number"; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(56; "From Bank Code"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(57; "From Bank Name"; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(58; "Transaction Date Time"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Payment Successful"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50006; "Line Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50007; "External Document No."; Text[30])
        {
            DataClassification = CustomerContent;
        }//
        field(50008; "Branch Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50009; "Creditor BIC"; Text[30])
        {
            TableRelation = "SWIFT Code".Code;
            ValidateTableRelation = false;
        }
        
        field(50010; "Creditor Identifier Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,BAN,IBAN,Other';
            OptionMembers = " ",BAN,IBAN,Other;
        }
    }

    keys
    {
        key(Key1; "Batch Number", "Reference Number", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Batch Number", "Interswitch Status")
        {
        }
    }

    fieldgroups
    {
    }

    // trigger OnDelete()
    // begin


    // case "Reference Type" of
    //     1:
    //         begin
    //             RecdRef.Open(DATABASE::"Gen. Journal Line");
    //             RecdRef.Get("Record ID");
    //             RecdRef.SetTable(GenJournal);
    //             GenJournal.Reset();
    //             GenJournal.SetRange("Document No.", PaymentLine."Source No.");
    //             GenJournal.SetRange("Journal Batch Name", 'OKTOPUS');
    //             GenJournal.SetRange("Journal Template Name", 'PAYMENTS');
    //             PaymentLine.SetRange("Source No.", GenJournal."Document No.");
    //             PaymentLine.SetFilter("Line No.", '<>%1', "Line No.");
    //             PaymentLine.DeleteAll();
    //             GenJournal."External Document No." := '';
    //             GenJournal.Modify();
    //             RecdRef.Close();
    //         end;
    // end;


    //end;
    trigger OnDelete()
    var
        FindGenJnl: Boolean;
        PaymentLine: Record "Payment Schedule Line";
        FindCashLine: Boolean;
    begin
        // if PaymentHeader.Get("Source No.") then begin
        //     PaymentHeader."Payment ID" := '';
        //     PaymentHeader.Modify()
        // end;

        // PaymentLine := Rec;
        // PaymentLine.SetRecFilter();
        // PaymentLine.TestStatusOpen;
        // TransHeader.Get(PaymentLine."Batch Number");
        // if TransHeader.Submitted then
        //     Error(Txt002, TransHeader."Batch Number");
        // GeneralJournalLine.Reset();
        // GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
        // GeneralJournalLine.SetRange("Document No.", PaymentLine."Source No.");
        // GeneralJournalLine.SetRange("Account No.", PaymentLine."Payee No.");
        // FindGenJnl := GeneralJournalLine.FindFirst();
        // if not FindGenJnl then begin
        //     GeneralJournalLine.Reset();
        //     GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
        //     GeneralJournalLine.SetRange("Document No.", PaymentLine."Source No.");
        //     if GeneralJournalLine.FindFirst() then begin
        //         PaymentTransLines.Reset();
        //         PaymentTransLines.SetRange("Source No.", GeneralJournalLine."Document No.");
        //         PaymentTransLines.SetRange("Line No.", PaymentLine."Line No.");
        //         FindCashLine := PaymentTransLines.FindFirst();
        //         if FindCashLine then begin
        //             GeneralJournalLine."Payment ID" := '';
        //             GeneralJournalLine.Modify();
        //             PaymentTransLines.DeleteAll();
        //         end;
        //     end;
        // end;
        // if not FindCashLine then begin
        //     PaymentTransLines.Reset();
        //     PaymentTransLines.SetRange("Source No.", GeneralJournalLine."Document No.");
        //     if PaymentTransLines.FindFirst() then begin
        //         GeneralJournalLine.Reset();
        //         GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
        //         GeneralJournalLine.SetRange("Document No.", Rec."Source No.");
        //         GeneralJournalLine."Payment ID" := '';
        //         GeneralJournalLine.Modify();
        //     end;
        // end;
    end;

    trigger OnInsert()
    begin
        TestStatusOpen();
        if "Reference Number" = '' then begin
            PmtTranSetup.Get();
            PmtTranSetup.TestField(PmtTranSetup."Reference No. Series");
            // NoSeriesMgt.InitSeries(PmtTranSetup."Reference No. Series", PmtTranSetup."Reference No. Series", 0D, "Reference Number",
            //                         PmtTranSetup."Reference No. Series");
            "Reference Number" := NoSeriesMgt.GetNextNo(PmtTranSetup."Reference No. Series");

        end;

        "Date Created" := CreateDatetime(Today, Time);
        "Created By" := Format(UserId());

        PmtTranSetup.Get();
        Surcharge := PmtTranSetup.Surcharge;
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
        TransHeader.Get("Batch Number");
        if TransHeader.Submitted then
            Error(TransTxt, TransHeader."Batch Number");

        "Last Modified Date" := CreateDatetime(Today, Time);
        "Last Modified By" := Format(UserId());
    end;

    trigger OnRename()
    begin
        TestStatusOpen();
        TransHeader.Get("Batch Number");
        if TransHeader.Submitted then
            Error(TransTxt, TransHeader."Batch Number");
    end;

    var
        CBNBanks: Record "Bank";
        PmtTranSetup: Record "Payment Schedule Setup";
        TransHeader: Record "Payment Schedule Header";
        PaymentLine: Record "Payment Schedule Line";
        GenJournal: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit "No. Series";
        RecdRef: RecordRef;
        TransTxt: label 'Batch Number %1 already submitted, Transaction cannot be modified', Comment = '%1 is the Batch Number';
        // Text002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
        StatusCheckSuspended: Boolean;

        Txt002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
        //TransHeader: Record "Payment Schedule Header";
        GeneralJournalLine: Record "Gen. Journal Line";
        PaymentTransLines: Record "Payment Schedule Line";
        PaymentHeader: Record "Payment Voucher Header";
    //ClosedPayroll: Record "Closed Payroll-PayslipHder";


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetPaymentHeader();
        TransHeader.TestField(Status, TransHeader.Status::Open);
    end;


    procedure GetPaymentHeader()
    begin
        TestField("Batch Number");
        if ("Batch Number" <> TransHeader."Batch Number") then
            TransHeader.Get("Batch Number");
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

}

