#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 90221 "Payment Schedule Notification"
{

    fields
    {
        field(1; "Batch Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Schedule Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Payment Reference"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Created On"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; Status; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Debit Account"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; Narration; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Transaction Status"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50000; "Trans. Status"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50001; "Merchant Id"; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50002; "Payment Schedule Id"; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50003; "Resolved Account Name"; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50004; "Status Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50005; "Payment Successful"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'For ';
        }
        field(50006; "Reference Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Posting Status"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "External Document No."; Text[30])
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
}

