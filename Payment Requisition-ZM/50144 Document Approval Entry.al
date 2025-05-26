table 50144 "Document Approval Entry"
{
    //Created by Akande

    DataClassification = ToBeClassified;

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
        field(3; "Document No."; Code[40])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Sender; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Approver; Code[100])
        {

            DataClassification = ToBeClassified;

        }
        field(7; Status; Option)
        {
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            DataClassification = ToBeClassified;

        }
        field(8; "Record ID to Approve"; RecordId)
        {

            DataClassification = ToBeClassified;

        }
        field(9; "Date-Time Sent for Approval"; Date)
        {

            DataClassification = ToBeClassified;

        }   //Due Date 

        field(10; "Due Date"; Date)
        {

            DataClassification = ToBeClassified;

        }



    }

    keys
    {
        key(key1; "Document No.", Sequence)
        {
            //   Clustered = true;
        }
        key(key2; Sequence, "Document No.")
        {
            //   Clustered = true;
        }
        key(key3; "Record ID to Approve")
        {

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