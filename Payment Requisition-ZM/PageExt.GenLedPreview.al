pageextension 50134 GLPostingPreviewExt extends "G/L Entries Preview"
{
    layout
    {
        addafter(Description)
        {
            field("G/L Account Name ";Rec."G/L Account Name") { ApplicationArea = All;}
        }
        addafter(Amount){
            field("Source Type";Rec."Source Type") {ApplicationArea = All; }
            field("Source Code ";Rec."Source Code") { ApplicationArea = All;}
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetRecord()
    begin
        GetVendor();
    end;

    local procedure GetVendor()
    begin
        if PurchInvHdr.Get(Rec."Document No.") then;
    end;
    var
        PurchInvHdr: Record "Purch. Inv. Header";
}