Table 90225 "Posted Payment Schedule Line"
{

    fields
    {
        field(4; "Batch Number"; Code[12])
        {
            DataClassification = CustomerContent;
            Description = 'Unique Batch Details no, Part of the Primary Key';
        }
        field(5; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Bank CBN Code"; Code[6])
        {
            Editable = true;
            TableRelation = "Bank";
            DataClassification = CustomerContent;
        }
        field(16; "Reference Number"; Code[25])
        {
            Description = 'Unique Ref no., Part of the Primary Key';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; TransactionType; Option)
        {
            OptionCaption = '50';
            DataClassification = CustomerContent;
            OptionMembers = "50";
        }
        field(18; "To Account Number"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(19; "To Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = '10,20';
            OptionMembers = "10","20";
        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(22; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Bank Name"; Text[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(26; "Interswitch Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Created,Error cannot process,In Queue/Still Processing,Processed Ok,Processed with Error';
            OptionMembers = "-1","0","1","2","3";
            DataClassification = CustomerContent;
        }
        field(27; "Line No"; Integer)
        {
            Description = 'Part of the Primary Key';
            DataClassification = CustomerContent;
        }
        field(32; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33; "Source Type"; Option)
        {
            OptionCaption = 'Bank Account,Vendor,Staff,Customer,Import,Retieree,Pension Fund Administrator';
            OptionMembers = "Bank Account",Vendor,Staff,Customer,Import,Retieree,"Pension Fund Administrator";
            DataClassification = CustomerContent;
        }
        field(34; Payee; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(36; "Record ID"; RecordID)
        {
            DataClassification = CustomerContent;
        }
        field(37; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(39; Status; Code[10])
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(40; "Status Description"; Text[50])
        {
            Caption = ' Status Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; "Reason Code"; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(42; Processed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(43; "Payee No."; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = filter(Staff)) Employee
            else
            if ("Source Type" = filter(Vendor)) Vendor
            else
            if ("Source Type" = filter(Customer)) Customer
            else
            if ("Source Type" = filter("Bank Account")) "Bank Account";
        }
        field(44; "Payee BVN"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50000; "Line Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "External Document No."; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(52132419; "Schedule Page No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'This is the page number used to upload this record';
        }
        field(52132420; "Schedule Serial No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'This is the serial number used to upload this record';
        }
        field(52132421; "Upload Status Text"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(52132422; "Upload Status Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(52132423; "Payment Batch"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Batch Number", "Reference Number", "Line No")
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
}

