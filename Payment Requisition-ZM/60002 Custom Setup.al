table 60002 "Payment Mgt Setup"
{
    //Created by Salaam Azeez
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Cash Advance Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7; "Purchase Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(8; "Payment Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(17; "VAT Payable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(18; "WHT Payable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(19; "NCDF Payable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(20; "Payment Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "Store Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "Store Return Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(10; "Retirement Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Cash Receipt Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Dummy Vendor"; Code[20])
        {
            TableRelation = Vendor;
        }

        field(12; "Payment Advice Voucher No."; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        //"Store Requisition Nos." "Store Return Nos."
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}