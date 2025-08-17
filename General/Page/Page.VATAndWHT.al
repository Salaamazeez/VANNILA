page 50029 VATAndWHTEntries
{
    ApplicationArea = All;
    Caption = 'VATAndWHT';
    PageType = List;
    SourceTable = VATAndWHTEntry;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    Visible = false;
                }

                field("VAT/WHT Percent"; Rec."VAT/WHT Percent")
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("VAT/WHT Posting Group"; Rec."VAT/WHT Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT/WHT Posting Group field.', Comment = '%';
                }
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                }
                field(Credit; Rec.Credit)
                {
                    ApplicationArea = All;
                }

                field("Adjustment %"; Rec."Adjustment %")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Linked to VAT/WHT"; Rec."Linked to VAT/WHT")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then
            CreateLines;
    end;

    local procedure CreateLines()
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        //GetPaymentVoucher.SetPaymentTranHeader(PaymentHeader);
        //GetPaymentVoucher.CreatePaymentLines(Rec);

        if Rec."Document Type" in ['PURCH ' + Format(PDocType::Order), 'PURCH ' + Format(PDocType::Invoice)] then
            GeneralCodeunit.CreatePurchaseLine(Rec);
        if Rec."Document Type" in ['SALES ' + Format(SDocType::Order), 'SALES ' + Format(SDocType::Invoice)] then
            GeneralCodeunit.CreateSalesLine(Rec);
    end;

    // local procedure CreatePurchaseLine(Rec: Record VATAndWHTEntry)
    // var
    //     LastNo: Integer;
    //     NextNo: Integer;
    // begin
    //     PurchaseLine.SetRange("Document No.", Rec."Document No.");
    //     //PurchaseLine.SetRange("Line No.", Rec."Line No.");
    //     PurchaseLine.FindLast();
    //     LastNo := PurchaseLine."Line No.";
    //     Rec.SetRange("Document No.", Rec."Document No.");
    //     Rec.SetRange(Selected, true);
    //     if Rec.FindSet() then
    //         repeat
    //             PurchLine.Init;
    //             PurchLine.TransferFields(PurchaseLine);
    //             if NextNo <> 0 then
    //                 LastNo := NextNo;
    //             if LastNo = PurchLine."Line No." then begin
    //                 PurchLine."Line No." := PurchLine."Line No." + 10000;
    //                 NextNo := PurchLine."Line No." + 10000;
    //             end
    //             else begin
    //                 NextNo := NextNo + 10000;
    //                 PurchLine."Line No." := NextNo;
    //             end;
    //             PurchLine.Insert();
    //             PurchaseLine."Unit Cost b/f Adjusted" := PurchaseLine."Unit Cost b/f Adjusted";
    //             PurchLine.Type := 1;
    //             PurchLine.Validate("No.", Rec."Tax Account");
    //             PurchLine.Validate(Quantity, 1);
    //             PurchLine.Validate("Direct Unit Cost", PurchaseLine."Direct Unit Cost" * Rec."VAT/WHT Percent" / 100);
    //             PurchLine.Modify();
    //         until Rec.Next() = 0;
    //     Rec.ModifyAll(Selected, false);
    // end;

    // local procedure CreateSalesLine(Rec: Record VATAndWHTEntry)
    // var
    //     LastNo: Integer;
    //     NextNo: Integer;
    // begin
    //     SalesLine.SetRange("Document No.", Rec."Document No.");
    //     //SalesLine.SetRange("Line No.", Rec."Line No.");
    //     SalesLine.FindLast();
    //     LastNo := SalesLine."Line No.";
    //     Rec.SetRange("Document No.", Rec."Document No.");
    //     Rec.SetRange(Selected, true);
    //     if Rec.FindSet() then
    //         repeat
    //             SaleLine.Init;
    //             SaleLine.TransferFields(SalesLine);
    //             if NextNo <> 0 then
    //                 LastNo := NextNo;
    //             if LastNo = SaleLine."Line No." then begin
    //                 SaleLine."Line No." := SaleLine."Line No." + 10000;
    //                 NextNo := SaleLine."Line No." + 10000;
    //             end
    //             else begin
    //                 NextNo := NextNo + 10000;
    //                 SaleLine."Line No." := NextNo;
    //             end;
    //             SaleLine.Insert();
    //             SaleLine.Type := 1;
    //             SaleLine.Validate("No.", Rec."Tax Account");
    //             SaleLine.Validate(Quantity, 1);
    //             SaleLine.Validate("Unit Price", SalesLine."Unit Price" * Rec."VAT/WHT Percent" / 100);
    //             SaleLine.Modify();
    //         until Rec.Next() = 0;
    //     Rec.ModifyAll(Selected, false);
    // end;


    var
        //     PurchaseLine: Record "Purchase Line";
        //     SalesLine: Record "Sales Line";
        //     PurchLine: Record "Purchase Line";
        //     SaleLine: Record "Sales Line";
        PDocType: Enum "Purchase Document Type";
        SDocType: Enum "Sales Document Type";
        GeneralCodeunit: Codeunit GeneralCodeunit;
}
