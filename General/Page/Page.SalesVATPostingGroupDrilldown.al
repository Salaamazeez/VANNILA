// Page 50210 "Sales VAT/WHT Post GrDrillDown"
// {
//     ApplicationArea = Basic;
//     PageType = List;
//     SourceTable = "VAT/WHT Posting Group";
//     UsageCategory = Lists;
//     SourceTableView = where("Transaction Type" = filter(Sales));
//     layout
//     {
//         area(content)
//         {
//             repeater(Control1000000000)
//             {
//                 field("Code"; Rec.Code)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(WithHoldingTax; Rec."WithHolding Tax %")
//                 {
//                     Caption = 'Tax %';
//                     ApplicationArea = Basic;
//                 }
//                 field("Tax Account"; Rec."Tax Account")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(WHTAuthority; Rec."WHT Authority")
//                 {
//                     Visible = false;
//                     ApplicationArea = Basic;
//                 }
//                 field(WHTCalculationType; Rec."WHT Calculation Type")
//                 {
//                     Visible = false;
//                     ApplicationArea = Basic;
//                 }
//                 field("Adjustment %"; Rec."Adjustment %")
//                 {
//                     Visible = false;
//                     ApplicationArea = Basic;
//                 }
//                 field(Credit; Rec.Credit)
//                 {
//                     Editable = false;
//                     ApplicationArea = Basic;
//                 }
//                 field(Type; Rec.Type)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Transaction Type";Rec."Transaction Type")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Linked to VAT/WHT";Rec."Linked to VAT/WHT"){
//                     ApplicationArea = Basic;
//                     Visible = false;
//                 }
//             }

//         }
//     }


//     actions
//     {
//     }

//     trigger OnOpenPage()
//     begin
//         if CurrPage.LookupMode then
//             CurrPage.Editable := false;
//     end;
// }

