pageextension 50103 PurchaseHeaderArchiveExt extends "Purchase Order Archive"
{
    actions
    {//modify(Print_Promoted)
        addafter(Print)
        {
            action("Force Convert To PO")
            {

                ApplicationArea = Suite;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to convert back to PO', FALSE) THEN
                        EXIT;
                    PurchHeader.TRANSFERFIELDS(Rec);
                    PurchHeader.INSERT;

                    PurchLineArch.SETRANGE(PurchLineArch."Document Type", Rec."Document Type");
                    PurchLineArch.SETRANGE(PurchLineArch."Document No.", Rec."No.");
                    PurchLineArch.SETRANGE(PurchLineArch."Doc. No. Occurrence", Rec."Doc. No. Occurrence");
                    PurchLineArch.SETRANGE(PurchLineArch."Version No.", Rec."Version No.");
                    IF PurchLineArch.FINDFIRST THEN
                        REPEAT
                            IF NOT PurchLine.GET(PurchLineArch."Document Type", PurchLineArch."Document No.", PurchLineArch."Line No.") THEN BEGIN
                                PurchLine.TRANSFERFIELDS(PurchLineArch);
                                PurchLine.INSERT;
                            END;
                            PurchLineArch.DELETE;
                        UNTIL PurchLineArch.NEXT = 0;
                    OnMoveDocAttachFromPOArchiveToPO(Rec, PurchHeader);
                    MESSAGE('Successfully Completed');
                    Rec.DELETE;
                end;
            }
        }
    }

    var
        DocPrint: Codeunit "Document-Print";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLineArch: Record "Purchase Line Archive";

    [IntegrationEvent(false, false)]
    local procedure OnMoveDocAttachFromPOArchiveToPO(var Rec1: Record "Purchase Header Archive"; var Rec2: Record "Purchase Header")
    begin
    end;
}