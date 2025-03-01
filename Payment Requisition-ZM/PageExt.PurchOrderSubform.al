pageextension 50050 PurchOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Gen. Bus. Posting Group "; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
            field("Gen. Prod. Posting Group  "; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
            field("VAT Bus. Posting Group "; Rec."VAT Bus. Posting Group") { ApplicationArea = All; }
            field("VAT Prod. Posting Group "; Rec."VAT Prod. Posting Group") { ApplicationArea = All; }
            field("FA Posting Type "; Rec."FA Posting Type") { ApplicationArea = All; }
            field("Maintenance Code"; Rec."Maintenance Code") { ApplicationArea = All; }
        }
        addafter("Line Amount")
        {
            field("Tax Type"; Rec."Tax Type")
            {
                ApplicationArea = All;
            }
            field("Unit Cost b/f Adjusted"; Rec."Unit Cost b/f Adjusted")
            {
                ApplicationArea = All;
            }
        }
        modify("Direct Unit Cost")
        {
            Editable = false;
        }
        addbefore("Direct Unit Cost")
        {
            field("Base Unit Cost"; Rec."Base Unit Cost")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        addafter("O&rder")
        {
            group(WHTVAT)
            {
                Caption = 'WHT/VAT';
                action(WHTVATEntries)
                {
                    Caption = 'WHT/VAT Entries';
                    ApplicationArea = All;
                    Image = VATEntries;

                    trigger OnAction()
                    begin
                        GeneralCodeunit.PurchaseVATEntry(Rec)
                    end;
                }
            }
        }
    }
    // local procedure PurchaseVATEntry(Rec: Record "Purchase Line")
    // var
    //     VATAndWHTEntry: Record VATAndWHTEntry;
    //     VATAndWHTEntries: Page VATAndWHTEntries;
    //     VATWHTPostingGrp: Record "VAT/WHT Posting Group";
    //     PurchaseLine: Record "Purchase Line";
    // begin
    //     PurchaseLine := Rec;
    //     PurchaseLine.SetRecFilter();
    //     VATAndWHTEntry.SetRange("Document No.", Rec."Document No.");
    //     VATAndWHTEntry.SetRange("Line No.", Rec."Line No.");
    //     if not VATAndWHTEntry.FindSet() then begin
    //         VATWHTPostingGrp.FindSet();
    //         repeat
    //             VATAndWHTEntry.Init();
    //             VATAndWHTEntry."Document Type" := 'PURCH ' + Format(PurchaseLine."Document Type");
    //             VATAndWHTEntry."Document No." := PurchaseLine."Document No.";
    //             VATAndWHTEntry."Line No." := PurchaseLine."Line No.";
    //             VATAndWHTEntry.Quantity := 1;
    //             VATAndWHTEntry."VAT/WHT Posting Group" := VATWHTPostingGrp.Code;
    //             VATAndWHTEntry."VAT/WHT Percent" := VATWHTPostingGrp."WithHolding Tax %";
    //             VATAndWHTEntry."Tax Account" := VATWHTPostingGrp."Tax Account";
    //             VATAndWHTEntry.Description := VATWHTPostingGrp.Description;
    //             VATAndWHTEntry."Adjustment %" := VATAndWHTEntry."Adjustment %";
    //             VATAndWHTEntry.Insert();
    //         until VATWHTPostingGrp.Next() = 0;
    //         Commit();
    //     end;
    //     VATAndWHTEntries.LOOKUPMODE := TRUE;


    //     VATAndWHTEntries.SETTABLEVIEW(VATAndWHTEntry);

    //     //VATAndWHTEntries.SetPaymentHeader(CashLiteTransHeader);
    //     VATAndWHTEntries.RUNMODAL;
    // end;

    var
        GeneralCodeunit: Codeunit GeneralCodeunit;
}