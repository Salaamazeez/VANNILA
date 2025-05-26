table 50137 "Purchase Requisition Line"
{
    //Created by Akande

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Required Item/Service"; Text[150])
        {
            //FieldClass = FlowField;
            // CalcFormula=Lookup("Stores Requisition"."Project/Job Description" WHERE ("No."=FIELD("Document No."))); 
            // CalcFormula=Lookup( ."Project/Job Description" WHERE ("No."=FIELD("Document No."))); 
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            BlankZero = true;
            trigger OnValidate()
            BEGIN
                TestStatusOpen;
                Amount := Quantity * "Unit Cost";
                VALIDATE(Amount);
            END;

        }
        field(7; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            trigger OnValidate()
            BEGIN
                Amount := Quantity * "Unit Cost";
                VALIDATE(Amount);
            END;

        }
        field(8; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Editable = false;
            trigger OnValidate()
            BEGIN
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    VALIDATE("Amount (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                    "Posting Date", "Currency Code", Amount, "Currency Factor"))));
                END;
                //--------This is not part of the code-------
                // IF "Amount (LCY)" > "Budget Remaning Amount" THEN
                //  MESSAGE('Be informed that total amount, %1, is greater than the remaining budget balance of %2',"Amount (LCY)","Budget Remaning Amount");
                //BudgetAmountGreater;
                //BudgetAmountGreater;
            end;

        }
        field(10; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            BEGIN
                //BudgetAmountGreater;
            END;

        }

        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(21; "Requisition Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(22; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            // OptionCaptionML=ENU=,Asset,Stock,Service;
            OptionMembers = " ","Asset","Stock","Service";
            trigger OnValidate()
            BEGIN
                TestStatusOpen;
                PurchRequistion.RESET;
                IF PurchRequistion.GET("Document No.") THEN BEGIN
                    // PurchRequistion.TESTFIELD(PurchRequistion."Budget Name");
                    VALIDATE("Budget Name", PurchRequistion."Budget Name");
                END;
                CalculateAmount;
            END;


        }
        field(23; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = FILTER(Asset)) "Fixed Asset"."No."
            ELSE
            IF (Type = FILTER(Stock)) "Item"."No."
            ELSE
            IF (Type = FILTER(Service)) "G/L Account"."No.";
            trigger OnValidate()
            BEGIN
                TestStatusOpen;
                IF (Type = Type::Asset) OR (Type = Type::Service) THEN
                    IF FA.GET("No.") THEN
                        VALIDATE(Description, FA.Description);

                IF (Type = Type::Stock) THEN
                    IF ItemRec.GET("No.") THEN
                        VALIDATE(Description, ItemRec.Description);
                Validate("Unit of Measure", ItemRec."Base Unit of Measure");

                IF Vendor.GET("No.") THEN
                    Description := Vendor.Name;
                "Unit of Measure" := ItemRec."Base Unit of Measure";

                //Attach Sundry Vendor
                PaymentMgtSetup.Get();
                "Vendor No." := PaymentMgtSetup."Dummy Vendor";
                "Vendor Name" := PaymentMgtSetup."Dummy Vendor"
            END;

        }
        field(25; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
            trigger OnValidate()
            BEGIN
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            END;

        }
        field(26; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
            trigger OnValidate()
            BEGIN
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            END;

        }
        field(27; "Budget Name"; Code[10])
        {
            TableRelation = "G/L Budget Name" WHERE(Blocked = FILTER(false));
            DataClassification = ToBeClassified;
        }
        field(28; "Currency Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Created By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(30; "Created Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(31; "Last Modified By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Budget Utilized"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Requisition Line".Amount WHERE("No." = FIELD("No."),
            "Shortcut Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
            "Shortcut Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
            "Line No." = FIELD("Line No.")));
            trigger OnValidate()
            BEGIN
                // IF "Budget Utilized" < "Budgetted Amount" THEN BEGIN
                //   "Budget Rem. Amount" := "Budgetted Amount" - "Budget Utilized";
                // END
                // ELSE
                //   MESSAGE('%1 CAN NOT BE GREATER THAN %2 ',FIELDCAPTION("Budget Utilized"),FIELDCAPTION("Budgetted Amount"));}
                //   BudgetAmountGreater;
            END;
        }
        field(34; "Budget Approved"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(35; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Budgetted Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Name" = FIELD("Budget Name"),
          "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
          "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));
        }
        field(38; "Budget Rem. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            //ValidateTableRelation = false;
            trigger OnValidate()
            begin
                if Vendor.get("Vendor No.") then
                    "Vendor Name" := Vendor.Name;
            end;
        }
        field(3; "Vendor Name"; Text[100])
        {

            // DataClassification = ToBeClassified;
            // TableRelation = Vendor;
            // ValidateTableRelation = false;
        }
        field(40; "Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
    }


    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        // key(Key1; "Line No.", "Document No.")
        // {


        // }
        // key(key2; Amount)
        // {

        // }
        key(Key2; Quantity)
        {

        }





    }



    trigger OnInsert()
    begin
        TestStatusOpen;
        "Created By" := USERID;
        "Created Date" := WORKDATE

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestStatusOpen;
    end;

    trigger OnRename()
    begin

    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        // OldDimSetID := PurchRequistion."Dimension Set ID";
        // PurchRequistion."Dimension Set ID" :=
        //   DimMgt.EditDimensionSet(
        //     PurchRequistion."Dimension Set ID", STRSUBSTNO('%1', "No."),
        //     PurchRequistion."Shortcut Dimension 1 Code", PurchRequistion."Shortcut Dimension 2 Code");
        // IF OldDimSetID <> PurchRequistion."Dimension Set ID" THEN
        //     MODIFY;

    end;

    procedure TestStatusOpen()
    var
        myInt: Integer;
    begin
        PurchRequistion.GET("Document No.");
        PurchRequistion.TESTFIELD(Status, PurchRequistion.Status::Open);

    end;

    procedure CalculateAmount()
    var
        myInt: Integer;
    begin
        AmountLVar := Quantity * "Unit Cost";
        IF "Currency Code" <> '' THEN BEGIN
            IF "Currency Factor" <> 0 THEN BEGIN
                Amount := AmountLVar;
                "Amount (LCY)" := AmountLVar / "Currency Factor";
            END ELSE
                TESTFIELD("Currency Factor");
        END ELSE BEGIN
            Amount := AmountLVar;
            "Amount (LCY)" := AmountLVar;
        end

    end;

    procedure CalCBudgRemAmount()
    var
        myInt: Integer;
    begin
        BudgRemAmtVar := "Budgetted Amount" - "Budget Utilized";
        "Budget Rem. Amount" := BudgRemAmtVar;
    end;

    procedure BudgetAmountGreater()
    var
        myInt: Integer;
    begin
        "Budget Rem. Amount" := ("Budgetted Amount" - "Budget Utilized");
        IF "Budget Rem. Amount" < 0 THEN
            MESSAGE('%1 CAN NOT BE GREATER THAN %2', FIELDCAPTION("Budget Utilized"), FIELDCAPTION("Budgetted Amount"));
    end;

    var
        PurchRequistion: Record "Purch. Requistion";
        //DimMgt: Codeunit DimensionManagement;
        AmountLVar: Decimal;
        BudgRemAmtVar: Decimal;
        FA: Record "Fixed Asset";
        ItemRec: Record Item;
        Vendor: Record Vendor;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentMgtSetup: Record "Payment Mgt Setup";

}