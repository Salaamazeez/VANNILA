pageextension 50134 GLPostingPreviewExt extends "G/L Entries Preview"
{
    layout
    {
        addafter(Description)
        {
            field("G/L Account Name "; Rec."G/L Account Name") { }
        }
        addafter(Amount){
            field("Source Type";Rec."Source Type") { }
            field("Source Code ";Rec."Source Code") { }
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