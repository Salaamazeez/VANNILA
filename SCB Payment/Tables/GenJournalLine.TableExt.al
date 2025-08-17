// tableextension 52092178 "GenJournalLineExt" extends "Gen. Journal Line"
// {
//     fields
//     {
//         field(52092178; "Schedule Amount"; Decimal)
//         {
//             Caption = 'Schedule Amount';
//             FieldClass = FlowField;
//             CalcFormula = sum("Payment Schedule".Amount where("Source Document No." = field("Document No."), "Source Line No." = field("Line No.")));
//         }
//         field(52092179; "Payment ID"; Code[20])
//         {
//             Caption = 'Payment ID';
//             DataClassification = CustomerContent;
//         }
//     }

//     procedure "Import Incentive"()
//     var
//         PaymentSchedule: Record "Payment Schedule";
//     begin
//         TestField("Document No.");
//         TestField("Line No.");
//         TestField("Account No.");
//         PaymentSchedule.ImportStdExcel("Document No.", "Line No.", "Account No.", "Journal Template Name", "Journal Batch Name");
//         Rec.CalcFields("Schedule Amount");
//         if Rec."Schedule Amount" <> 0 then
//             Rec.Validate(Amount, Rec."Schedule Amount");
//     end;

//     trigger OnAfterDelete()
//     var
//         PaymentSchedule: Record "Payment Schedule";
//     begin
//         PaymentSchedule.Reset();
//         PaymentSchedule.SetRange("Source Document No.", "Document No.");
//         PaymentSchedule.SetRange("Source Line No.", "Line No.");
//         PaymentSchedule.SetRange("General Journal Template", "Journal Template Name");
//         PaymentSchedule.SetRange("General Journal Batch", "Journal Batch Name");
//         PaymentSchedule.DeleteAll();
//     end;
// }


