codeunit 50001 "DocAttchMgt Extension"
{
    trigger OnRun()
    begin

    end;

    local procedure CopyAttachments(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        FromDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        FromLineNo: Integer;
        FromNo: Code[20];
        ToNo: Code[20];
        RecNo: Code[20];
        ToDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ToLineNo: Integer;
    begin
        FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);
        if FromDocumentAttachment.IsEmpty then
            exit;
        case FromRecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Requisition":
                begin
                    FromFieldRef := FromRecRef.Field(1);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;

        end;

        if FromDocumentAttachment.FindSet
        then begin
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init;
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                case ToRecRef.Number of
                    Database::"Payment Voucher Header",
                     Database::Retirement:
                        begin
                            ToFieldRef := ToRecRef.Field(1);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                        end;

                end;
                if not ToDocumentAttachment.Insert(true) then;

            until FromDocumentAttachment.Next = 0;
        end;
    end;

    local procedure DeleteAttachedDocuments(RecRef: RecordRef)
    var
        DocumentAttachment: Record "Document Attachment";
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecNo1: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        if RecRef.IsTemporary then
            exit;
        if DocumentAttachment.IsEmpty then
            exit;
        DocumentAttachment.SetRange("Table ID", RecRef.Number);
        case RecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Voucher Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        DocumentAttachment.DeleteAll;
    end;


    [EventSubscriber(Objecttype::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnOpenDocAttach(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option "Payment Voucher","Cash Advance",Retirement;
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Voucher Header",
            Database::"Payment Requisition",
            Database::Retirement:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeInsertAttachment', '', false, false)]
    local procedure OnSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Cash Advance",
           Database::"Payment Voucher Header",
           Database::"Payment Requisition",
           Database::Retirement:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Advance", 'OnMoveDocAttachFromCashAdvanceToVoucher', '', false, false)]
    local procedure OnMoveDocAttachFromCashAdvanceToVoucher(var Rec1: Record "Cash Advance"; var Rec2: Record "Payment Voucher Header");
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Cash Advance");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::"Payment Voucher Header");
        ToRecRef.GetTable(Rec2);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Requisition", 'OnMoveDocAttachFromPaymentReqToVoucher', '', false, false)]
    local procedure OnMoveDocAttachFromPaymentReqToVoucher(var Rec1: Record "Payment Requisition"; var Rec2: Record "Payment Voucher Header");
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Payment Requisition");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::"Payment Voucher Header");
        ToRecRef.GetTable(Rec2);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::Retirement, 'OnMoveDocAttachFromCashAdvanceToRetirement', '', false, false)]
    local procedure OnMoveDocAttachFromCashAdvanceToRetirement(var Rec1: Record "Cash Advance"; var Rec2: Record Retirement);
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Cash Advance");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::Retirement);
        ToRecRef.GetTable(Rec2);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Advance", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteCashAdv(var Rec: Record "Cash Advance"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        CashAdvance: Record "Cash Advance";
        PaymentReq: Record "Payment Requisition";
        Retirement: Record Retirement;
        PmntVoucher: Record "Payment Voucher Header";
    begin
        CASE DocumentAttachment."Table ID" OF
            DATABASE::"Cash Advance":
                begin
                    RecRef.Open(DATABASE::"Cash Advance");
                    if CashAdvance.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(CashAdvance);
                end;
            DATABASE::"Payment Requisition":
                begin
                    RecRef.Open(DATABASE::"Cash Advance");
                    if PaymentReq.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PaymentReq);
                end;
            DATABASE::Retirement:
                begin
                    RecRef.Open(DATABASE::"Cash Advance");
                    if Retirement.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(Retirement);
                end;
            DATABASE::"Payment Voucher Header":
                begin
                    RecRef.Open(DATABASE::"Payment Voucher Header");
                    if PmntVoucher.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PmntVoucher);
                end;
        end;
    end;



}