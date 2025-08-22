Table 90219 "Payment Window Header"
{
    DrillDownPageID = "Payment List";
    LookupPageID = "Payment List";

    fields
    {
        field(3; "Search Name"; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Batch Number"; Code[20])
        {
            Description = 'Unique Batch Details no';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Currency Code"; Code[10])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; "Bank CBN Code"; Code[20])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Bank Account Number"; Code[30])
        {
            Description = 'This is the corresponding bank account no';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Record Count"; Integer)
        {
            CalcFormula = count("Payment Window Line" where("Batch Number" = field("Batch Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Bank Name"; Text[100])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(25; Submitted; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(26; "Submission Response Code"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(27; "Created by"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(28; "Submitted by"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(29; Confirmed; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
            trigger OnValidate()
            begin
                if Submitted then Error(Error001Txt);

                if Confirmed then begin
                    TransLine.SetCurrentkey("Batch Number", "Reference Number", "Line No.");
                    TransLine.SetRange(TransLine."Batch Number", "Batch Number");
                    if not TransLine.FindSet() then Error(Error002Txt, "Batch Number");
                    repeat
                        TransLine.TestField(TransLine.Surcharge);
                    until TransLine.Next() = 0;

                    TestField("Bank Account Code");
                    TestField("Bank CBN Code");
                    TestField("Bank Account Number");
                    TestField("Currency Code");
                    TestField(Description);
                    "Confirmed by" := Format(UserId())
                end else
                    "Confirmed by" := '';
            end;
        }
        field(30; "Confirmed by"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(31; "Date Created"; DateTime)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(32; "Date Submitted"; DateTime)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(33; "Last modified by"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(34; "Last Modified Date"; DateTime)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(35; "Bank Account Code"; Code[20])
        {
            Description = 'This is Navision''s bank account no.';
            TableRelation = "Payment Bank Mapping";
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                if "Bank Account Code" <> '' then begin
                    if PaymentBankMapping.Get("Bank Account Code") then begin
                        //PaymentBankMapping.TestField(Blocked, false);
                        "Bank CBN Code" := PaymentBankMapping."Bank CBN Code";
                        "Bank Account Number" := PaymentBankMapping."Bank Account No.";
                        "Bank Name" := PaymentBankMapping.Name;
                        "Currency Code" := PaymentBankMapping."Payment Currency Code"
                    end;
                end else begin
                    "Bank CBN Code" := '';
                    "Bank Account Number" := '';
                    "Bank Name" := '';
                    "Currency Code" := '';
                end;
                //to be used when going live
                if "Bank Account Code" <> '' Then begin
                    if PaymentBankMapping.Get("Bank Account Code") Then begin
                        PaymentDebitAccount.SetRange("Account Number", PaymentBankMapping."Bank Account No.");
                        PaymentDebitAccount.SetRange("Bank Code", PaymentBankMapping."Bank CBN Code");
                        if NOT PaymentDebitAccount.FINDFIRST() then
                            error(Error003Txt, PaymentBankMapping."Bank Account No.", PaymentBankMapping."Bank CBN Code");
                        PaymentBankMapping.TESTFIELD(Blocked, false);
                        "Bank CBN Code" := PaymentBankMapping."Bank CBN Code";
                        "Bank Account Number" := PaymentBankMapping."Bank Account No.";
                        "Debit Account Id" := PaymentBankMapping."Debit Account Id";
                        "Bank Name" := PaymentBankMapping.Name;
                        "Currency Code" := PaymentBankMapping."Payment Currency Code"
                    end;
                end ELSE begin
                    "Bank CBN Code" := '';
                    "Bank Account Number" := '';
                    "Bank Name" := '';
                    "Currency Code" := '';
                end;
            end;
        }
        field(36; "Recipient Email"; Text[250])
        {
            Description = 'For Mail Notification';
            DataClassification = EndUserIdentifiableInformation;

        }
        field(37; Description; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Payment Window Line".Amount where("Batch Number" = field("Batch Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(40; "Old Batch Number"; Code[20])
        {
            Description = 'To keep the last Batch No. if copied to another batch';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(41; Processed; Integer)
        {
            CalcFormula = count("Payment Window Line" where("Batch Number" = field("Batch Number"),
                                                              "Interswitch Status" = filter("-1" | "1" | "2")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; ClientID; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(43; "API Platform"; Option)
        {
            OptionCaption = 'SCB';
            OptionMembers =SCB;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(44; "Check Status Response"; Text[250])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(45; "Check Status Response Code"; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(46; "Submission Status Code"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50; "Create Schedule Status"; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(51; "General Journal Template"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Template";
            trigger OnValidate()
            begin
                Rec.TestField("Payroll Payment", Rec."Payroll Payment"::" ");
            end;
        }
        field(52; "General Journal Batch"; Text[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("General Journal Template"));
        }
        field(53; "Payment Method"; Text[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Payment Method";
            Editable = false;
        }

        field(50004; "Payroll-E/DCode"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
           // TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                // if "Payroll-E/DCode" <> '' then begin
                //     PayrollEDRec.Get("Payroll-E/DCode");
                //     Validate("Payroll E/D Description", PayrollEDRec."Description");
                // end else
                //     Clear("Payroll E/D Description");
            end;
        }
        field(50005; "Payroll E/D Description"; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50006; "Closed Payroll(Yes/No)"; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(50007; "Pension Administrator"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            //TableRelation = "Pension Administrator";
        }
        field(50016; "Payroll Payment"; Option)
        {
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = ' ,Salary,Other Payroll Deductions,Pension Remittance';
            OptionMembers = " ",Salary,"Other Payroll Deductions","Pension Remitance";

            trigger OnValidate()
            begin
                // PayrollSetup.Get;
                // PayrollSetup.TestField("Total Pension Contri. E/D");
                // PayrollSetup.TestField(PayrollSetup."Net Pay E/D Code");
                case "Payroll Payment" of
                    "payroll payment"::"Pension Remitance":
                        begin
                            //Validate("Payroll-E/DCode", PayrollSetup."Total Pension Contri. E/D");
                        end;
                    "payroll payment"::Salary:
                        begin
                            //Validate("Payroll-E/DCode", PayrollSetup."Net Pay E/D Code");
                        end;
                end;
                begin
                    Rec.TestField("General Journal Template", '');
                end;
            end;
        }
        field(50017; "Multiple Remittance Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Start Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Payroll-Period";
        }
        field(50019; "End Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Payroll-Period";
        }
        field(50020; "Attached to Entity"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment Voucher,G/L Journal,Payroll';
            OptionMembers = " ",PV,GLJournal,Payroll;
        }
        field(52132418; "Global Dimension 1 Code Desc"; Text[100])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Global Dimension 1 Code"),
                                                               "Global Dimension No." = const(1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52132419; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = filter(false));
        }
        field(52132421; "Related Batches"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(52132422; "Payroll Period"; Code[10])
        {
            //TableRelation = "Payroll-Period";
            DataClassification = EndUserIdentifiableInformation;
        }

        field(52132425; "Payment Reference"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(52132426; Balance; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52132429; "Schedule Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(52132430; "Process Completed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(52132431; "Debit Account Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(Key1; "Batch Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PmtTranSetup.Get();
        if "Batch Number" = '' then begin
            PmtTranSetup.TestField(PmtTranSetup."Batch No. Series");
            PmtTranSetup.TestField(PmtTranSetup."Payment Platform", PmtTranSetup."Payment Platform"::SCB);
            NoSeriesMgt.InitSeries(PmtTranSetup."Batch No. Series", PmtTranSetup."Batch No. Series", 0D, "Batch Number",
                                   PmtTranSetup."Batch No. Series");
        end;
        "Date Created" := CreateDatetime(Today, Time);
        "Created by" := Format(UserId());
        "API Platform" := PmtTranSetup."Payment Platform"::SCB;
    end;

    trigger OnModify()
    begin
        if Submitted then Error(Error001Txt, "Batch Number");
        "Last Modified Date" := CreateDatetime(Today, Time);
        "Last modified by" := Format(UserId());
        PmtTranSetup.Get();
        PmtTranSetup.TestField("Payment Platform", PmtTranSetup."Payment Platform"::SCB);
    end;

    var
        BankRec: Record "Bank Account";
        PmtTranSetup: Record "Payment Trans Setup";
        TransLine: Record "Payment Window Line";
        PaymentDebitAccount: Record "Payment-DebitAccounts";
        PaymentBankMapping: Record "Payment Bank Mapping";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Error001Txt: label 'Batch Number %1 already submitted, Transaction cannot be modified', Comment = '%1 is the Batch Number';
        Error002Txt: label 'Line does not exist for Batch Number %1', Comment = '%1 is the Batch Number';
        Error003Txt: Label 'Account No. %1,Bank Code %2 cannot be found on the related debit accounts', Comment = '%1 is the Account No., %2 is the Bank Code';
        Text001: label 'Batch Number %1 already submitted, Transaction cannot be modified';
        Text002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
        Text003: label 'Line does not exist for Batch Number %1';
        EnablePayrollPeriodField: Boolean;
        CashlitLn: Record "Payment Window Line";
        FileName: Text;
        // PayrollEDRec: Record "Payroll-E/D";
        // PayrollSetup: Record "Payroll-Setup";

    procedure Recreate()
    var

        NewPaymentHeader: Record "Payment Window Header";
        PaymentLine: Record "Payment Window Line";
        NewPaymentLine: Record "Payment Window Line";
        PostedPaymentHeader: Record "Posted Payment Trans Hdr";
        PostedPaymentLine: Record "Posted Payment Trans Line";
        GeneralJournalLine: Record "Gen. Journal Line";
        ErrorTxt: Label 'Action not allowed';
    begin
        if (Rec."Submission Status Code" = '16') and
         (Rec."Check Status Response Code" in ['00', '06', '']) then
            error(ErrorTxt);
        NewPaymentHeader.Init();
        NewPaymentHeader := Rec;
        NewPaymentHeader."Batch Number" := '';
        NewPaymentHeader.Submitted := false;
        NewPaymentHeader."Submission Response Code" := '';
        NewPaymentHeader."Created by" := Format(UserId);
        NewPaymentHeader."Submitted by" := '';
        NewPaymentHeader.Confirmed := false;
        NewPaymentHeader."Confirmed by" := '';
        NewPaymentHeader."Date Created" := CurrentDateTime;
        NewPaymentHeader."Date Submitted" := 0DT;
        NewPaymentHeader."Last modified by" := Format(UserId);
        NewPaymentHeader."Last Modified Date" := CurrentDateTime;
        NewPaymentHeader.Status := 0;
        NewPaymentHeader."Old Batch Number" := Rec."Batch Number";
        NewPaymentHeader."Check Status Response" := '';
        NewPaymentHeader."Check Status Response Code" := '';
        NewPaymentHeader."Submission Status Code" := '';
        NewPaymentHeader.Insert(true);
        NewPaymentHeader.CopyLinks(Rec);
        PaymentLine.SetRange("Batch Number", Rec."Batch Number");
        if PaymentLine.FindSet() then
            repeat
                NewPaymentLine.Init();
                NewPaymentLine := PaymentLine;
                NewPaymentLine."Batch Number" := NewPaymentHeader."Batch Number";
                NewPaymentLine."Reference Number" := '';
                //To remove after test******
                NewPaymentLine.Status := PaymentLine.Status;
                NewPaymentLine."Status Description" := PaymentLine."Status Description";
                NewPaymentLine.Insert(true);
                if NewPaymentLine."Reference Type" = NewPaymentLine."Reference Type"::"Gen Journal" then begin
                    GeneralJournalLine.Reset();
                    GeneralJournalLine.SetFilter("Journal Template Name", '%1', 'PAYMENTS');
                    GeneralJournalLine.SetFilter("Journal Batch Name", '%1', 'OKTOPUS');
                    GeneralJournalLine.FindFirst();
                    //GeneralJournalLine.Get(0, NewPaymentLine."Source No.");
                    // if GeneralJournalLine."Payment ID" <> NewPaymentHeader."Batch Number" Then begin
                    //     GeneralJournalLine."Payment ID" := NewPaymentHeader."Batch Number";
                    //     GeneralJournalLine.Modify();
                    // end;
                end;
                PostedPaymentLine.TransferFields(PaymentLine);
                PostedPaymentLine.Insert();
            until PaymentLine.Next() = 0;
        PostedPaymentHeader.TransferFields(Rec);
        PostedPaymentHeader."Reason For Archive" := PostedPaymentHeader."Reason For Archive"::Recreated;
        PostedPaymentHeader.Insert();
        PaymentLine.SetRange("Batch Number", Rec."Batch Number");
        PaymentLine.DeleteAll();
        if Rec.HasLinks Then
            Rec.DeleteLinks();
        Rec.Delete();
    end;

    procedure ArchiveOnly()
    var
        PaymentLine: Record "Payment Window Line";
        PostedPaymentHeader: Record "Posted Payment Trans Hdr";
        ReasonForA: Integer;
        Errer001Txt: Label 'Action not allowed';
    begin
        if (Rec."Submission Status Code" = '16') and
         (Rec."Check Status Response Code" in ['00', '06', '']) then
            error(Errer001Txt);
        ReasonForA := StrMenu('Posted,Recreated,Rejected', 3, 'Select the reason for archiving');

        PostedPaymentHeader.TransferFields(Rec);
        case ReasonForA of
            1:
                PostedPaymentHeader."Reason For Archive" := PostedPaymentHeader."Reason For Archive"::Posted;
            2:
                begin
                    Recreate();
                    exit;
                end;
            3:
                PostedPaymentHeader."Reason For Archive" := PostedPaymentHeader."Reason For Archive"::Rejected
        end;
        PostedPaymentHeader.Insert();
        PaymentLine.SetRange("Batch Number", Rec."Batch Number");
        PaymentLine.DeleteAll();
        if Rec.HasLinks then
            Rec.DeleteLinks();
        Rec.Delete();
    end;

}


