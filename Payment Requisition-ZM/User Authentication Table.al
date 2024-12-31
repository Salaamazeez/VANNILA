// table 50001 "User Authentication"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "User Code"; Code[20])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(2; "User Name"; Text[100])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(3; "User Email"; Text[50])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(4; Status; Option)
//         {
//             OptionMembers = Active,Inactive;
//         }
//         field(5; "User Code 2"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(6; "User Code 3"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }

//     }

//     keys
//     {
//         key(Key1; "User Code")
//         {
//             Clustered = true;
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

// }