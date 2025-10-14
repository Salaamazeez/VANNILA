pageextension 50104 "Sales Order Archive Ext" extends "Sales Order Archive"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(Restore) { Visible = false; }
        addafter(Print)
        {
            action(CreateSalesOrder)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Suite;
                Caption = 'Force-Create Sales Order';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesHeaderArchive: Record "Sales Header Archive";
                    ReleaseSalesDoc: Codeunit "Release Sales Document";
                begin
                    SalesHeaderArchive := Rec;
                    SalesHeader.Init();
                    SalesHeader.SetHideValidationDialog(true);
                    SalesHeader."Document Type" := SalesHeaderArchive."Document Type";
                    SalesHeader."No." := SalesHeaderArchive."No.";
                    //OnBeforeSalesHeaderInsert(SalesHeader, SalesHeaderArchive);
                    SalesHeader.Insert(true);
                    //OnRestoreSalesDocumentOnAfterSalesHeaderInsert(SalesHeader, SalesHeaderArchive);
                    SalesHeader.TransferFields(SalesHeaderArchive);
                    SalesHeader.Status := SalesHeader.Status::Open;
                    if SalesHeaderArchive."Sell-to Contact No." <> '' then
                        SalesHeader.Validate("Sell-to Contact No.", SalesHeaderArchive."Sell-to Contact No.")
                    else
                        SalesHeader.Validate("Sell-to Customer No.", SalesHeaderArchive."Sell-to Customer No.");
                    if SalesHeaderArchive."Bill-to Contact No." <> '' then
                        SalesHeader.Validate("Bill-to Contact No.", SalesHeaderArchive."Bill-to Contact No.")
                    else
                        SalesHeader.Validate("Bill-to Customer No.", SalesHeaderArchive."Bill-to Customer No.");
                    SalesHeader.Validate("Salesperson Code", SalesHeaderArchive."Salesperson Code");
                    SalesHeader.Validate("Payment Terms Code", SalesHeaderArchive."Payment Terms Code");
                    SalesHeader.Validate("Payment Discount %", SalesHeaderArchive."Payment Discount %");
                    SalesHeader."Shortcut Dimension 1 Code" := SalesHeaderArchive."Shortcut Dimension 1 Code";
                    SalesHeader."Shortcut Dimension 2 Code" := SalesHeaderArchive."Shortcut Dimension 2 Code";
                    SalesHeader."Dimension Set ID" := SalesHeaderArchive."Dimension Set ID";
                    RecordLinkManagement.CopyLinks(SalesHeaderArchive, SalesHeader);
                    //SalesHeader.LinkSalesDocWithOpportunity(OldOpportunityNo);
                    //OnAfterTransferFromArchToSalesHeader(SalesHeader, SalesHeaderArchive);
                    SalesHeader.Modify(true);
                    Rec.RestoreSalesLinesExt(SalesHeaderArchive, SalesHeader);
                    SalesHeader.Status := SalesHeader.Status::Released;
                    ReleaseSalesDoc.Reopen(SalesHeader);
                    //OnAfterRestoreSalesDocument(SalesHeader, SalesHeaderArchive);
                end;
            }
        }
    }

    var

        RecordLinkManagement: Codeunit "Record Link Management";
        DeferralUtilities: Codeunit "Deferral Utilities";


    // local procedure RestoreSalesLinesExt(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    // var
    //     SalesLine: Record "Sales Line";
    //     SalesLineArchive: Record "Sales Line Archive";
    // begin
    //     RestoreSalesLineComments(SalesHeaderArchive, SalesHeader);

    //     SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
    //     SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
    //     SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
    //     SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
    //     if SalesLineArchive.FindSet then
    //         repeat
    //             with SalesLine do begin
    //                 Init;
    //                 TransferFields(SalesLineArchive);
    //                 "GEM-No." := SalesLineArchive."No.";
    //                 Insert();
    //                 //OnRestoreSalesLinesOnAfterSalesLineInsert(SalesLine, SalesLineArchive);
    //                 if Type <> Type::" " then begin
    //                     Validate("No.");
    //                     if SalesLineArchive."Variant Code" <> '' then
    //                         Validate("Variant Code", SalesLineArchive."Variant Code");
    //                     if SalesLineArchive."Unit of Measure Code" <> '' then
    //                         Validate("Unit of Measure Code", SalesLineArchive."Unit of Measure Code");
    //                     Validate("Location Code", SalesLineArchive."Location Code");
    //                     if Quantity <> 0 then
    //                         Validate(Quantity, SalesLineArchive.Quantity);
    //                     //OnRestoreSalesLinesOnAfterValidateQuantity(SalesLine, SalesLineArchive);
    //                     Validate("Unit Price", SalesLineArchive."Unit Price");
    //                     Validate("Unit Cost (LCY)", SalesLineArchive."Unit Cost (LCY)");
    //                     Validate("Line Discount %", SalesLineArchive."Line Discount %");
    //                     if SalesLineArchive."Inv. Discount Amount" <> 0 then
    //                         Validate("Inv. Discount Amount", SalesLineArchive."Inv. Discount Amount");
    //                     if Amount <> SalesLineArchive.Amount then
    //                         Validate(Amount, SalesLineArchive.Amount);
    //                     Validate(Description, SalesLineArchive.Description);
    //                 end;
    //                 "Shortcut Dimension 1 Code" := SalesLineArchive."Shortcut Dimension 1 Code";
    //                 "Shortcut Dimension 2 Code" := SalesLineArchive."Shortcut Dimension 2 Code";
    //                 "Dimension Set ID" := SalesLineArchive."Dimension Set ID";
    //                 "Deferral Code" := SalesLineArchive."Deferral Code";
    //                 RestoreDeferrals(
    //                     "Deferral Document Type"::Sales.AsInteger(),
    //                     SalesLineArchive."Document Type".AsInteger(), SalesLineArchive."Document No.", SalesLineArchive."Line No.",
    //                     SalesHeaderArchive."Doc. No. Occurrence", SalesHeaderArchive."Version No.");
    //                 RecordLinkManagement.CopyLinks(SalesLineArchive, SalesLine);
    //                 //OnAfterTransferFromArchToSalesLine(SalesLine, SalesLineArchive);
    //                 Modify(true);
    //             end;
    //             //OnAfterRestoreSalesLine(SalesHeader, SalesLine, SalesHeaderArchive, SalesLineArchive);
    //         until SalesLineArchive.Next = 0;

    //     //OnAfterRestoreSalesLines(SalesHeader, SalesLine, SalesHeaderArchive, SalesLineArchive);
    // end;


    // local procedure RestoreSalesLineComments(SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    // var
    //     SalesCommentLineArchive: Record "Sales Comment Line Archive";
    //     SalesCommentLine: Record "Sales Comment Line";
    //     NextLine: Integer;
    //     Text004: Label 'Document restored from Version %1.';
    // begin
    //     SalesCommentLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
    //     SalesCommentLineArchive.SetRange("No.", SalesHeaderArchive."No.");
    //     SalesCommentLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
    //     SalesCommentLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
    //     if SalesCommentLineArchive.FindSet then
    //         repeat
    //             SalesCommentLine.Init();
    //             SalesCommentLine.TransferFields(SalesCommentLineArchive);
    //             SalesCommentLine.Insert();
    //         until SalesCommentLineArchive.Next = 0;

    //     SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type");
    //     SalesCommentLine.SetRange("No.", SalesHeader."No.");
    //     SalesCommentLine.SetRange("Document Line No.", 0);
    //     if SalesCommentLine.FindLast then
    //         NextLine := SalesCommentLine."Line No.";
    //     NextLine += 10000;
    //     SalesCommentLine.Init();
    //     SalesCommentLine."Document Type" := SalesHeader."Document Type";
    //     SalesCommentLine."No." := SalesHeader."No.";
    //     SalesCommentLine."Document Line No." := 0;
    //     SalesCommentLine."Line No." := NextLine;
    //     SalesCommentLine.Date := WorkDate;
    //     SalesCommentLine.Comment := StrSubstNo(Text004, Format(SalesHeaderArchive."Version No."));
    //     SalesCommentLine.Insert();
    // end;

    // local procedure RestoreDeferrals(DeferralDocType: Integer; DocType: Integer; DocNo: Code[20]; LineNo: Integer; DocNoOccurrence: Integer; VersionNo: Integer)
    // var
    //     DeferralHeaderArchive: Record "Deferral Header Archive";
    //     DeferralLineArchive: Record "Deferral Line Archive";
    //     DeferralHeader: Record "Deferral Header";
    //     DeferralLine: Record "Deferral Line";
    // begin
    //     if DeferralHeaderArchive.Get(DeferralDocType, DocType, DocNo, DocNoOccurrence, VersionNo, LineNo) then begin
    //         // Updates the header if is exists already and removes all the lines
    //         DeferralUtilities.SetDeferralRecords(DeferralHeader,
    //           DeferralDocType, '', '',
    //           DocType, DocNo, LineNo,
    //           DeferralHeaderArchive."Calc. Method",
    //           DeferralHeaderArchive."No. of Periods",
    //           DeferralHeaderArchive."Amount to Defer",
    //           DeferralHeaderArchive."Start Date",
    //           DeferralHeaderArchive."Deferral Code",
    //           DeferralHeaderArchive."Schedule Description",
    //           DeferralHeaderArchive."Initial Amount to Defer",
    //           true,
    //           DeferralHeaderArchive."Currency Code");

    //         // Add lines as exist in the archives
    //         DeferralLineArchive.SetRange("Deferral Doc. Type", DeferralDocType);
    //         DeferralLineArchive.SetRange("Document Type", DocType);
    //         DeferralLineArchive.SetRange("Document No.", DocNo);
    //         DeferralLineArchive.SetRange("Doc. No. Occurrence", DocNoOccurrence);
    //         DeferralLineArchive.SetRange("Version No.", VersionNo);
    //         DeferralLineArchive.SetRange("Line No.", LineNo);
    //         if DeferralLineArchive.FindSet then
    //             repeat
    //                 DeferralLine.Init();
    //                 DeferralLine.TransferFields(DeferralLineArchive);
    //                 DeferralLine.Insert();
    //             until DeferralLineArchive.Next = 0;
    //     end else
    //         // Removes any lines that may have been defaulted
    //         DeferralUtilities.RemoveOrSetDeferralSchedule('', DeferralDocType, '', '', DocType, DocNo, LineNo, 0, 0D, '', '', true);
    // end;



}