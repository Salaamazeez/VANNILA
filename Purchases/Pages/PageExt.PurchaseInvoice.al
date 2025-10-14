// pageextension 50207 PurchaseOrderExt extends "Purchase Order"
// {
//     layout
//     {
//         modify("Location Code")
//         {
//             Visible = false;
//         }
//         modify("VAT Bus. Posting Group")
//         {
//             Visible = false;
//         }
//         modify("Promised Receipt Date")
//         {
//             Visible = false;
//         }
//     }

//     actions
//     {
//         modify("Create &Whse. Receipt")
//         {
//             Visible = false;
//         }
//         modify("Create Inventor&y Put-away/Pick")
//         {
//             Visible = false;
//         }
//         modify("Send Intercompany Purchase Order")
//         {
//             Visible = false;
//         }
//         modify(SendApprovalRequest)
//         {
//             trigger OnBeforeAction()
//             begin
//                 Rec.CheckPurchaseAmount();
//                 Rec.TestField()
//             end;
//         }
//         modify(Release) {  
//             trigger OnBeforeAction()
//             begin
//                 Rec.CheckPurchaseAmount();
//                 Rec.TestField()
//             end;
//         }      
//     }
// }
