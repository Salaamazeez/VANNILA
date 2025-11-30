Table 90218 "Payment Schedule Setup"
{
    Caption = 'Payment Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; "Batch No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Reference No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Get Payment Schedule URL"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(19; Surcharge; Decimal)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(22; "Payment Platform"; Option)
        {
            OptionCaption = 'SCB';
            OptionMembers = SCB;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(25; "Single View Request No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(30; "Get Payroll on Payment"; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(31; "General Journal Template"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Template";

        }

        field(32; "Charges Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(33; "General Journal Batch"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("General Journal Template"));
        }
        field(34; "Payment Method"; Text[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Payment Method";
        }
        field(50061; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(50062; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));

            trigger OnValidate()
            begin
                // UpdateJournalBatchID();
            end;
        }


        field(50063; "Create Schedule URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(50064; "Secret Key"; Text[2048])
        {
            DataClassification = CustomerContent;
            //ExtendedDatatype = Masked;
        }
        field(50065; "Payment Auto Post"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50066; "Charges Auto Post"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50067; "Update Schedule URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50068; "Use Pmt Authomation"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }





}

