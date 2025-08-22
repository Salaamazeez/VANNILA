// pageextension 90220 "Payment Journal" extends "Payment Journal"
// {
//     layout
//     {

//     }

//     actions
//     {
//         addafter(SuggestEmployeePayments)
//         {
//             action("Import Payment Schedule")
//             {
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 ApplicationArea = All;
//                 Caption = 'Import Payment Schedule';
//                 Visible = true;
//                 ToolTip = 'This action is to import payment schedule from excel template. This can be used for employee, salary and vendor payment';
//                 Image = Process;
//                 trigger OnAction()
//                 begin
//                     Rec."Import Incentive"();
//                 end;
//             }
//             action("Payment Schedule")
//             {
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 ApplicationArea = All;
//                 Caption = 'Payment Schedule';
//                 Visible = true;
//                 ToolTip = 'This is the action to view the payment schedule';
//                 Image = List;
//                 trigger OnAction()
//                 var
//                     PScheduleLine: Record "Payment Schedule";
//                     PScheduleLines: page "Payment Schedules";
//                 begin
//                     Rec.TestField("Document No.");
//                     Rec.TestField("Line No.");
//                     PScheduleLine.SetRange("Source Document No.", Rec."Document No.");
//                     PScheduleLine.SetRange("Source Line No.", Rec."Line No.");
//                     PScheduleLine.SetRange("General Journal Template", Rec."Journal Template Name");
//                     PScheduleLine.SetRange("General Journal Batch", Rec."Journal Batch Name");
//                     PScheduleLine.SetRange("Source Line No.", Rec."Line No.");
//                     PScheduleLines.SetTableView(PScheduleLine);
//                     PScheduleLines.RunModal();
//                     Rec.CalcFields("Schedule Amount");
//                     Rec.VALIDATE(Amount, Rec."Schedule Amount");
//                 end;

//             }

//         }
//     }

// }