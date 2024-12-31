
// page 50014 "User Authentication"
// {


//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "User Authentication";

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("User Code"; REC."User Code")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("User Code 2"; REC."User Code 2")
//                 {
//                     ApplicationArea = All;
//                     Editable = true;
//                 }
//                 field("User Code 3"; REC."User Code 3")
//                 {
//                     ApplicationArea = All;
//                     Editable = true;
//                 }
//                 field("User Name"; REC."User Name")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("User Email"; REC."User Email")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Status; REC.Status)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//             //   }

//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin

//                 end;
//             }
//         }
//     }
// }

