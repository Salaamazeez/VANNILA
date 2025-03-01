tableextension 50104 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50000; "Tax Type"; Option)
        {
            OptionMembers = " ",VAT,WHT;
            Editable = false;
        }
        field(50001; "Tax Attached to Line"; Integer)
        {
            Editable = false;
        }
        field(50002; "Unit Cost b/f Adjusted"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Base Unit Cost"; Decimal)
        {
            Editable = true;
            trigger OnValidate()
            begin
                Rec.Validate("Direct Unit Cost", Rec."Base Unit Cost")
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
        CheckAndDeleteVATLine()
    end;

    procedure CheckAndDeleteVATLine()
    var
        Purchline: Record "Purchase Line";
        RecDoc: Code[20];
    begin
        RecDoc := Rec."Document No.";
        Purchline.SetRange("Document Type", Rec."Document Type");
        Purchline.SetRange("Document No.", Rec."Document No.");
        //Purchline.SetRange("Tax Attached to Line", Rec."Line No.");
        Purchline.SetRange("Tax Type", Rec."Tax Type"::VAT);
        if not Purchline.FindFirst() then begin
            Purchline.Reset();
            Purchline.SetRange("Document Type", Rec."Document Type");
            Purchline.SetRange("Document No.", Rec."Document No.");
            Purchline.SetRange("Line No.", Rec."Tax Attached to Line");
            Purchline.SetRange("Tax Type", Rec."Tax Type"::" ");
            if Purchline.FindFirst() then begin
                Purchline.Validate("Direct Unit Cost", Purchline."Unit Cost b/f Adjusted");
                Purchline.Modify()
            end;
        end;
    end;
}