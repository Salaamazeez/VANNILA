codeunit 50102 GeneralCodeunit
{



    procedure CreatePurchaseLine(Rec: Record VATAndWHTEntry)
    var
        LastNo: Integer;
        NextNo: Integer;
        CountNo: Integer;
        TempVATWHT: Record VATAndWHTEntry;
        TempPurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        //PurchaseLine.SetRange("Line No.", Rec."Line No.");
        PurchaseLine.FindLast();
        LastNo := PurchaseLine."Line No.";
        Rec.SetRange("Document No.", Rec."Document No.");
        Rec.SetRange("Transaction Type", Rec."Transaction Type"::Purchase);
        Rec.SetRange(Selected, true);
        if Rec.FindSet() then
            repeat
                CountNo += 1;
                PurchLine.Init;
                PurchLine.TransferFields(PurchaseLine);
                if Rec.Type = Rec.Type::VAT then
                    TempVATWHT := Rec;
                if NextNo <> 0 then
                    LastNo := NextNo;
                if LastNo = PurchLine."Line No." then begin
                    PurchLine."Line No." := PurchLine."Line No." + 10000;
                    NextNo := PurchLine."Line No." + 10000;
                end
                else begin
                    NextNo := NextNo + 10000;
                    PurchLine."Line No." := NextNo;
                end;
                PurchLine.Insert();
                if CountNo = 1 then
                    PurchaseLine."Unit Cost b/f Adjusted" := PurchaseLine."Unit Cost";

                PurchLine.Type := 1;
                PurchLine.Validate("No.", Rec."Tax Account");
                PurchLine.Validate(Quantity, 1);
                if Rec.Credit then
                    PurchLine.Validate("Direct Unit Cost", -1 * PurchaseLine."Direct Unit Cost" * Rec."VAT/WHT Percent" / 100)
                else
                    PurchLine.Validate("Direct Unit Cost", PurchaseLine."Direct Unit Cost" * Rec."VAT/WHT Percent" / 100);
                PurchLine."Tax Type" := Rec.Type;
                PurchLine."Tax Attached to Line" := PurchaseLine."Line No.";
                PurchLine.Modify();
            until Rec.Next() = 0;
        PurchaseLine.Validate("Direct Unit Cost", PurchaseLine."Unit Cost b/f Adjusted" + PurchaseLine."Unit Cost b/f Adjusted" * Abs(TempVATWHT."VAT/WHT Percent") / 100);
        PurchaseLine.Modify();
        // PurchaseLine.Modify();
        TempVATWHT.Reset();
        TempVATWHT.SetRange("Document No.", PurchaseLine."Document No.");
        TempVATWHT.SetRange("Line No.", PurchaseLine."Line No.");
        TempVATWHT.SetRange("Transaction Type", TempVATWHT."Transaction Type"::Purchase);
        TempVATWHT.DeleteAll();
    end;

    procedure CreateSalesLine(Rec: Record VATAndWHTEntry)
    var
        LastNo: Integer;
        NextNo: Integer;
        TempVATWHT: Record VATAndWHTEntry;
        CountNo: Integer;
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", Rec."Document No.");
        //SalesLine.SetRange("Line No.", Rec."Line No.");
        SalesLine.FindLast();
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange("Line No.", Rec."Line No.");
        SalesLine.FindFirst();
        SalesLine.Validate("Base Unit Price");
        LastNo := SalesLine."Line No.";
        Rec.SetRange("Document No.", Rec."Document No.");
        Rec.SetRange("Transaction Type", Rec."Transaction Type"::Sales);
        Rec.SetRange(Selected, true);
        if Rec.FindSet() then
            repeat
                CountNo += 1;
                SaleLine.Init;
                SaleLine.TransferFields(SalesLine);
                if Rec.Type = Rec.Type::VAT then
                    TempVATWHT := Rec;
                if NextNo <> 0 then
                    LastNo := NextNo;
                if LastNo = SaleLine."Line No." then begin
                    SaleLine."Line No." := SaleLine."Line No." + 10000;
                    NextNo := SaleLine."Line No." + 10000;
                end
                else begin
                    NextNo := NextNo + 10000;
                    SaleLine."Line No." := NextNo;
                end;
                SaleLine.Insert();
                if CountNo = 1 then
                    SalesLine."Unit Price b/f Adjusted" := SalesLine."Unit Price";

                SaleLine.Type := 1;
                SaleLine.Validate("No.", Rec."Tax Account");
                SaleLine.Validate(Quantity, 1);
                if Rec.Credit then
                    SaleLine.Validate("Unit Price", -1 * SalesLine."Unit Price b/f Adjusted" * Rec."VAT/WHT Percent" / 100)
                else
                    SaleLine.Validate("Unit Price", SalesLine."Unit Price b/f Adjusted" * Rec."VAT/WHT Percent" / 100);
                SaleLine."Tax Type" := Rec.Type;
                SaleLine."Tax Attached to Line" := SalesLine."Line No.";
                SaleLine.Modify();
            //SalesLine.Modify();
            until Rec.Next() = 0;

        SalesLine.Validate("Base Unit Price");
        SalesLine.Modify();
        TempVATWHT.Reset();
        TempVATWHT.SetRange("Document No.", SalesLine."Document No.");
        TempVATWHT.SetRange("Line No.", SalesLine."Line No.");
        TempVATWHT.SetRange("Transaction Type", TempVATWHT."Transaction Type"::Sales);
        TempVATWHT.DeleteAll();
    end;


    var
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        SaleLine: Record "Sales Line";
        PDocType: Enum "Purchase Document Type";
        SDocType: Enum "Sales Document Type";

    procedure PurchaseVATEntry(Rec: Record "Purchase Line")
    var
        VATAndWHTEntry: Record VATAndWHTEntry;
        VATAndWHTEntries: Page VATAndWHTEntries;
        VATWHTPostingGrp: Record "VAT/WHT Posting Group";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine := Rec;
        PurchaseLine.SetRecFilter();
        VATAndWHTEntry.SetRange("Document No.", Rec."Document No.");
        VATAndWHTEntry.SetRange("Line No.", Rec."Line No.");
        VATAndWHTEntry.SetRange("Transaction Type", VATAndWHTEntry."Transaction Type"::Purchase);
        VATAndWHTEntry.DeleteAll();
        VATAndWHTEntry.Reset();
        VATAndWHTEntry.SetRange("Document No.", Rec."Document No.");
        VATAndWHTEntry.SetRange("Line No.", Rec."Line No.");
        VATAndWHTEntry.SetRange("Transaction Type", VATAndWHTEntry."Transaction Type"::Purchase);
        if not VATAndWHTEntry.FindSet() then begin
            VATWHTPostingGrp.SetRange("Transaction Type", VATWHTPostingGrp."Transaction Type"::Purchase);
            VATWHTPostingGrp.FindSet();
            repeat
                VATAndWHTEntry.Init();
                VATAndWHTEntry."Document Type" := 'PURCH ' + Format(PurchaseLine."Document Type");
                VATAndWHTEntry."Document No." := PurchaseLine."Document No.";
                VATAndWHTEntry."Line No." := PurchaseLine."Line No.";
                VATAndWHTEntry.Quantity := 1;
                VATAndWHTEntry."VAT/WHT Posting Group" := VATWHTPostingGrp.Code;
                VATAndWHTEntry."VAT/WHT Percent" := VATWHTPostingGrp."WithHolding Tax %";
                VATAndWHTEntry."Tax Account" := VATWHTPostingGrp."Tax Account";
                VATAndWHTEntry.Description := VATWHTPostingGrp.Description;
                VATAndWHTEntry."Adjustment %" := VATAndWHTEntry."Adjustment %";
                VATAndWHTEntry.Credit := VATWHTPostingGrp.Credit;
                VATAndWHTEntry.Type := VATWHTPostingGrp.Type;
                VATAndWHTEntry."Linked to VAT/WHT" := VATWHTPostingGrp."Linked to VAT/WHT";
                VATAndWHTEntry."Transaction Type" := VATWHTPostingGrp."Transaction Type"::Purchase;
                VATAndWHTEntry.Insert();
            until VATWHTPostingGrp.Next() = 0;
            Commit();
        end;
        VATAndWHTEntries.LOOKUPMODE := TRUE;

        VATAndWHTEntries.SETTABLEVIEW(VATAndWHTEntry);
        VATAndWHTEntries.Editable := true;
        VATAndWHTEntries.RUNMODAL;
    end;

    procedure SalesVATEntry(Rec: Record "Sales Line")

    var
        VATAndWHTEntry: Record VATAndWHTEntry;
        VATAndWHTEntries: Page VATAndWHTEntries;
        VATWHTPostingGrp: Record "VAT/WHT Posting Group";
        SalesLine: Record "Sales Line";

    begin
        SalesLine := Rec;
        SalesLine.SetRecFilter();
        VATAndWHTEntry.SetRange("Document No.", Rec."Document No.");
        VATAndWHTEntry.SetRange("Line No.", Rec."Line No.");
        VATAndWHTEntry.SetRange("Transaction Type", VATAndWHTEntry."Transaction Type"::Sales);
        VATAndWHTEntry.DeleteAll();
        VATAndWHTEntry.Reset();
        VATAndWHTEntry.SetRange("Document No.", Rec."Document No.");
        VATAndWHTEntry.SetRange("Line No.", Rec."Line No.");
        VATAndWHTEntry.SetRange("Transaction Type", VATAndWHTEntry."Transaction Type"::Sales);
        if not VATAndWHTEntry.FindSet() then begin
            VATWHTPostingGrp.SetRange("Transaction Type", VATWHTPostingGrp."Transaction Type"::Sales);
            VATWHTPostingGrp.FindSet();
            repeat
                VATAndWHTEntry.Init();
                VATAndWHTEntry."Document Type" := 'SALES ' + Format(SalesLine."Document Type");
                VATAndWHTEntry."Document No." := SalesLine."Document No.";
                VATAndWHTEntry."Line No." := SalesLine."Line No.";
                VATAndWHTEntry.Quantity := 1;
                VATAndWHTEntry."VAT/WHT Posting Group" := VATWHTPostingGrp.Code;
                VATAndWHTEntry."VAT/WHT Percent" := VATWHTPostingGrp."WithHolding Tax %";
                VATAndWHTEntry."Tax Account" := VATWHTPostingGrp."Tax Account";
                VATAndWHTEntry.Description := VATWHTPostingGrp.Description;
                VATAndWHTEntry.Type := VATWHTPostingGrp.Type;
                VATAndWHTEntry.Credit := VATWHTPostingGrp.Credit;
                VATAndWHTEntry."Transaction Type" := VATWHTPostingGrp."Transaction Type"::Sales;
                VATAndWHTEntry."Linked to VAT/WHT" := VATWHTPostingGrp."Linked to VAT/WHT";
                VATAndWHTEntry.Insert();
            until VATWHTPostingGrp.Next() = 0;
            Commit();
        end;
        VATAndWHTEntries.LOOKUPMODE := TRUE;
        VATAndWHTEntries.SETTABLEVIEW(VATAndWHTEntry);
        VATAndWHTEntries.Editable := true;
        VATAndWHTEntries.RUNMODAL;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostInvPostBuffer', '', false, false)]
local procedure "Sales-Post_OnBeforePostInvPostBuffer"(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean)
begin
end;

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnPostLinesOnBeforeGenJnlLinePost, '', false, false)]
local procedure "Sales Post Invoice Events_OnPostLinesOnBeforeGenJnlLinePost"(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
begin
   GenJnlLine."Description 2" := TempInvoicePostingBuffer."Description 2"
end;

// [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterFillInvoicePostBuffer, '', false, false)]
// local procedure "Sales-Post_OnAfterFillInvoicePostBuffer"(var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; SalesLine: Record "Sales Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; CommitIsSuppressed: Boolean)
// begin
// end;
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnPrepareLineOnAfterFillInvoicePostingBuffer, '', false, false)]
local procedure "Sales Post Invoice Events_OnPrepareLineOnAfterFillInvoicePostingBuffer"(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; SalesLine: Record "Sales Line")
begin
    InvoicePostingBuffer."Description 2" := SaleLine."Description 2"
end;
[EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
begin
    GLEntry."Description 2" := GenJournalLine."Description 2"
end;

}