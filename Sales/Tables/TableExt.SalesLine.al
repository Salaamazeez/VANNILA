tableextension 50105 SalesLineExt extends "Sales Line"
{
    fields
    {
        modify("Description 2"){
            Caption = 'Narration';
        }
        field(50000; "Tax Type"; Option)
        {
            OptionMembers = " ",VAT,WHT;
            Editable = false;
        }
        field(50001; "Tax Attached to Line"; Integer)
        {
            Editable = false;
        }
        field(50002; "Unit Price b/f Adjusted"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Base Unit Price"; Decimal)
        {
            Editable = true;
            trigger OnValidate()
            begin
                Rec.Validate("Unit Price", Rec."Base Unit Price")
            end;
        }
    }


    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnAfterDelete()
    begin
        CheckAndDeleteVATLine();
    end;



    procedure CheckAndDeleteVATLine()
    var
        SaleLine: Record "Sales Line";
        RecDoc: Code[20];
    begin
        RecDoc := Rec."Document No.";
        SaleLine.SetRange("Document Type", Rec."Document Type");
        SaleLine.SetRange("Document No.", Rec."Document No.");
        //SaleLine.SetRange("Tax Attached to Line", Rec."Line No.");
        SaleLine.SetRange("Tax Type", Rec."Tax Type"::VAT);
        if not SaleLine.FindFirst() then begin
            SaleLine.Reset();
            SaleLine.SetRange("Document Type", Rec."Document Type");
            SaleLine.SetRange("Document No.", Rec."Document No.");
            SaleLine.SetRange("Line No.", Rec."Tax Attached to Line");
            SaleLine.SetRange("Tax Type", Rec."Tax Type"::" ");
            if SaleLine.FindFirst() then begin
                SaleLine.Validate("Unit Price", SaleLine."Unit Price b/f Adjusted");
                SaleLine.Modify()
            end;
        end;
    end;

}