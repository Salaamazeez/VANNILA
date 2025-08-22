
// pageextension 90215 "EmployeeExt" extends "Employee Card"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addafter("A&bsences")
//         {
//             action("Bank Accounts")
//             {
//                 ApplicationArea = All;
//                 Caption = 'Bank Accounts';
//                 Image = BankAccount;
//                 ToolTip = 'This action can be used to create employee bank account';
//                 RunObject = Page "Employee Bank Account List";
//                 RunPageLink = "Employee No." = field("No.");
//             }
//         }
//     }

// }