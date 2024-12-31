table 60007 "Document Approval Entry1"
{
    //Created by Salaam Azeez
    DataClassification = CustomerContent;

    fields
    {
        field(1; Sequence; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Sender; Code[40])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Approver; Code[40])
        {
            DataClassification = ToBeClassified;

        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
        }
        field(8; "Record ID to Approve"; RecordID)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Document Description"; Text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Document Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Open; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key("PK"; Sequence, "Document No.")
        {
            Clustered = true;
        }
        key("SK"; "Document No.", Status, Approver)
        {

        }

    }

    var
        PageManagement: Codeunit "Page Management";

    procedure ShowRecord()
    var
        RecRef: RecordRef;
    begin
        IF NOT RecRef.GET("Record ID to Approve") THEN
            EXIT;
        RecRef.SETRECFILTER;
        PageManagement.PageRun(RecRef);
    end;

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