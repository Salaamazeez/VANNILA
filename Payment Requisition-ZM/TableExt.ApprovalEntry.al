TableExtension 50109 ApprovalEntryExt extends "Approval Entry"
{
    fields
    {
        modify("Document Type")
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';

        }
        field(50000; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Description 2"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Workflow User Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}