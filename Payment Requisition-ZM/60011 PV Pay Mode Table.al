table 60011 "Pay Mode"
{

    //Created by Akande
    DataClassification = ToBeClassified;
    LookupPageId = "Pay Mode";
    DrillDownPageId = "Pay Mode";

    fields
    {
        field(1; Primary; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Pay Mode"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Description; Text[50])
        {

        }
        field(34; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account",Employee;

            DataClassification = ToBeClassified;
        }
        field(27; "Bal. Account No."; Code[10])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"."No." ELSE
            IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Bal. Account No.");
                            "Bal. Account Name" := GLAcc.Name;
                        END;
                    "Bal. Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Bal. Account No.");
                            "Bal. Account Name" := BankAccount.Name;
                        END;
                END;
            end;
        }
        field(6; "Bal. Account Name"; Text[50]) { }
        // field(5; "Bank Account No."; Code[20])
        // {
        //     TableRelation = "Bank Account";

        //     trigger OnValidate()
        //     var
        //         BankAccount: Record "Bank Account";
        //     begin

        //         //  BEGIN
        //         BankAccount.GET("Bank Account No.");
        //         "Bank Account Name" := BankAccount.Name;
        //         //  END;
        //     END;
        //     // end;
        // }
        // field(3; "Bank Account Name"; Text[20])
        // {

        // }
        field(4; "Payment to"; Text[50]) { }

    }

    keys
    {
        key(Key1; "Pay Mode")
        {
            Clustered = true;
        }
    }

    var
        GLAcc: Record "G/L Account";
        BankAccount: Record "Bank Account";

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