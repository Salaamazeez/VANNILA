Table 90216 "Payment Bank Mapping"
{
    fields
    {
        field(1; "Bank Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'No.';
            NotBlank = true;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                BankRec.Get("Bank Code");
                BankRec.TestField("Bank Account No.");
                BankRec.TestField("Bank Code");
                Name := BankRec.Name;
                "Bank Account No." := BankRec."Bank Account No.";
                "Bank CBN Code" := BankRec."Bank Code";
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Created By"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Last Modified By"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; Blocked; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70000; "Bank CBN Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Bank";

            trigger OnValidate()
            begin
                if "Bank CBN Code" <> '' then begin
                    CbnBankCode.Get("Bank CBN Code");
                    "Bank CBN Code Description" := CbnBankCode."Name";
                end;
                DebitAccount.SetRange("Bank Code", "Bank CBN Code");
                DebitAccount.SetRange("Account Number", "Bank Account No.");

                if NOT DebitAccount.FINDFIRST() then
                    error(Text004, "Bank Account No.", "Bank CBN Code");
                "Debit Account Id" := DebitAccount.Id
            end;
        }
        field(70001; CardPAN; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70002; CardPINBlock; Text[25])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70003; CardExpiryDay; Code[2])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70004; CardExpiryMonth; Code[2])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70005; CardExpiryYear; Code[4])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70006; CardSequenceNumber; Integer)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70007; CardTerminalId; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70008; "Payment Currency Code"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80000; Submitted; Boolean)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80001; "Submission Response Code"; Text[250])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80002; "Submitted by"; Code[50])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80003; "Date Submitted"; DateTime)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80004; "Submission Status Code"; Code[10])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80005; "Account Balance"; Decimal)
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80006; "Nibbs Bank"; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(80007; "Bank CBN Code Description"; Text[30])
        {
            CalcFormula = lookup("Bank"."Name" where("Code" = field("Bank Code")));
            FieldClass = FlowField;
        }
        field(80008; "Debit Account Id"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
            Description = 'For ';
        }
    }

    keys
    {
        key(Key1; "Bank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := Format(UserId);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := Format(UserId);
    end;

    var
        BankRec: Record "Bank Account";
        CbnBankCode: Record "Bank";
        DebitAccount: Record "Payment-DebitAccounts";
        Text004: label 'Account No. %1,Bank Code %2 cannot be found on the related debit accounts';
}

