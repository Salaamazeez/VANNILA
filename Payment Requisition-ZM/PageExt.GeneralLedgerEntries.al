pageextension 50023 GeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        //addbefore(Amount)
        //{
        //     field(CurrencyCode; Rec."Source Currency Code")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Currency Code';
        //     }
        //     field("Source Type "; Rec."Source Type") { ApplicationArea = All; }
        //     field("Source Code "; Rec."Source Code") {ApplicationArea = All; }
        //     field("Source No. "; Rec."Source No.") {ApplicationArea = All; }
        //     field("Description 2";Rec."Description 2") {ApplicationArea = All; }
        // }

        addafter(Description)
        {
            field("G/L Account Name "; Rec."G/L Account Name") {ApplicationArea = All; }
             field(CurrencyCode; Rec."Source Currency Code")
            {
                ApplicationArea = All;
                Caption = 'Currency Code';
            }
            field("Source Type "; Rec."Source Type") { ApplicationArea = All; }
            field("Source Code "; Rec."Source Code") {ApplicationArea = All; }
            field("Source No. "; Rec."Source No.") {ApplicationArea = All; }
            field("Description 2";Rec."Description 2") {ApplicationArea = All; }
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