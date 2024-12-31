table 60012 "Expense Code"
{
    //Created by Salaam Azeez
    DataClassification = ToBeClassified;
    LookupPageId = "Expense Code";
    DrillDownPageId = "Expense Code";

    fields
    {
        field(1; Primary; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Expense Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Description; Text[50])
        {

        }
        field(34; "Account Type"; Option)
        {
            OptionMembers = "Bank Account","G/L Account",Customer,"Fixed Asset";

            DataClassification = ToBeClassified;
        }
        field(27; "Account No."; Code[10])
        {
            TableRelation = IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No." else
            if ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) else
            if ("Account Type" = const(Customer)) Customer."No." else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"."No.";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CASE "Account Type" OF

                    "Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Account No.");
                            "Account Name" := BankAccount.Name;
                        END;
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Account No.");
                            "Account Name" := GLAcc.Name;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            CustAccount.GET("Account No.");
                            "Account Name" := CustAccount.Name;
                        END;
                    "Account Type"::"Fixed Asset":
                        BEGIN
                            FixedAsset.GET("Account No.");
                            "Account Name" := FixedAsset.Description;
                        END;
                END;
            end;
        }
        field(6; "Account Name"; Text[100]) { }
        // field(5; "Bank Account No."; Code[20])  // field(5; "Bank Account No."; Code[20])
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
        key(Key1; "Expense Code")
        {
            Clustered = true;
        }
    }

    var
        CustAccount: Record Customer;
        GLAcc: Record "G/L Account";
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";

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