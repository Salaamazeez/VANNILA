Table 90224 "Posted Payment Trans Hdr"
{
    DrillDownPageID = "Payment Window List";
    LookupPageID = "Payment Window List";

    fields
    {
        field(4; "Batch Number"; Code[12])
        {
            Description = 'Unique Batch Details no';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5; "Currency Code"; Code[10])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Bank CBN Code"; Code[6])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Bank Account Number"; Code[25])
        {
            Description = 'This is the corresponding bank account no';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "Record Count"; Integer)
        {
            CalcFormula = count("Posted Payment Trans Line" where("Batch Number" = field("Batch Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Bank Name"; Text[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(25; Submitted; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(26; "Submision Response"; Text[250])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(27; "Created by"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(28; "Submitted by"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(29; Confirmed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Confirmed by"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(31; "Date Created"; DateTime)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(32; "Date Submitted"; DateTime)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(33; "Last modified by"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(34; "Last Modified Date"; DateTime)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(35; "Bank Account Code"; Code[20])
        {
            Description = 'This is Navision''s bank account no.';
            TableRelation = "Payment Bank Mapping";
            DataClassification = CustomerContent;
        }
        field(36; "Recipient Email"; Text[250])
        {
            Description = 'For Mail Notification';
            DataClassification = CustomerContent;
        }
        field(37; Description; Text[100])
        {
            DataClassification = CustomerContent;
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
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
            DataClassification = CustomerContent;
        }
        field(40; "Old Batch Number"; Code[12])
        {
            Description = 'To keep the last Batch No. if copied to another batch';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; Processed; Integer)
        {
            CalcFormula = count("Posted Payment Trans Line" where("Batch Number" = field("Batch Number"),
                                                                    "Interswitch Status" = filter("-1" | "1" | "2")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; ClientID; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(43; "API Platform"; Option)
        {
            OptionCaption = 'Interswitch,NIBSS,UBA';
            OptionMembers = Interswitch,NIBSS,UBA;
            DataClassification = CustomerContent;
        }
        field(44; "Check Status Response"; Text[250])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52132424; "Reason For Archive"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Posted,Recreated,Rejected';
            OptionMembers = Posted,Recreated,Rejected;
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

