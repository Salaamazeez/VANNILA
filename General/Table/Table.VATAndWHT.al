table 50101 VATAndWHTEntry
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Code[20])
        {
            Caption = 'Document Type';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            //TableRelation = "Purchase Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "VAT/WHT Posting Group"; Code[20])
        {
            TableRelation = "VAT/WHT Posting Group";
            trigger OnValidate()
            var
                VATWHTPostingGrp: Record "VAT/WHT Posting Group";
            begin
                VATWHTPostingGrp.Get("VAT/WHT Posting Group");
                Quantity := 1;
                "VAT/WHT Percent" := VATWHTPostingGrp."WithHolding Tax %";
                "Tax Account" := VATWHTPostingGrp."Tax Account";
                //"Purchase WHT Tax Account" := VATWHTPostingGrp."Purchase WHT Tax Account"
            end;
        }
        field(6; Quantity; Integer)
        {

        }
        field(7; "VAT/WHT Percent"; Decimal)
        {

        }
        field(8; "Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; Selected; Boolean)
        {

        }
        field(10; Description; Text[100])
        {
        }
        field(11; "Adjustment %"; Decimal) { }
        field(12; Credit; Boolean) { }
         field(13; Type; Option)
        {
            Editable = false;
            OptionMembers = " ",VAT,WHT;
        }
        field(14; "Transaction Type"; Option)
        {
            OptionMembers = " ",Purchase,Sales;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Tax Account","Transaction Type","VAT/WHT Posting Group", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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