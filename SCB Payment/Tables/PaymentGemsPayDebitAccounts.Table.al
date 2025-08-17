#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 90217 "Payment-DebitAccounts"
{
    Permissions = tabledata "Payment Window Header" = r;

    fields
    {
        field(1; Id; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Account Number"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Bank Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Common Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Bank Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; Authorized; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Allow Debit"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Has Debit Mandate"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Mandate Ref Encrypted"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Synced To Nibss"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Created At"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Modified At"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Deleted At"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Service Merchant Id"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Merchant Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Nibss Account Id"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        // field(19; Status; Enum "DebitAccountsStatus")
        // {
        //    DataClassification = CustomerContent;
        // }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PaymentTranHdr.SetRange("Debit Account Id", Id);
        PaymentTranHdr.SetRange("Bank Account Number", "Account Number");
        PaymentTranHdr.SetRange("Bank CBN Code", "Bank Code");
        if PaymentTranHdr.FindFirst() then
            Error(Text004, PaymentTranHdr."Bank Account Number", PaymentTranHdr."Bank CBN Code");
    end;

    trigger OnModify()
    begin
        PaymentTranHdr.SetRange("Debit Account Id", Id);
        PaymentTranHdr.SetRange("Bank Account Number", "Account Number");
        PaymentTranHdr.SetRange("Bank CBN Code", "Bank Code");
        if PaymentTranHdr.FindFirst() then
            Error(Text004, PaymentTranHdr."Bank Account Number", PaymentTranHdr."Bank CBN Code");
    end;

    var
        PaymentTranHdr: Record "Payment Window Header";
        Text004: label 'Account No. %1,Bank Code %2 can be found on the related debit accounts. Kindly contact your administrator.';
}

