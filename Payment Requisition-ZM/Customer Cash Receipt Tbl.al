// table 50002 "Customer Cash Receipt"
// {
//     //Created by Akande
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "No."; code[10])
//         {
//             DataClassification = CustomerContent;
//             // Editable = false;
//         }
//         field(2; "Date"; Date)
//         {
//             DataClassification = CustomerContent;
//         }
//         field(4; "Requester"; Text[60])
//         {
//             DataClassification = CustomerContent;
//             Editable = false;
//             TableRelation = "User Setup"."User ID";
//         }
//         field(5; "Shortcut Dimension 1 Code"; Code[20])
//         {
//             DataClassification = CustomerContent;
//             CaptionClass = '1,2,1';
//             CaptionML = ENU = 'Shortcut Dimension 1 Code';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

//             trigger OnValidate()
//             begin
//                 ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
//             end;
//         }
//         field(6; "Shortcut Dimension 2 Code"; Code[20])
//         {
//             DataClassification = CustomerContent;
//             CaptionML = ENU = 'Shortcut Dimension 2 Code';
//             CaptionClass = '1,2,2';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

//             trigger OnValidate()
//             begin
//                 ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
//             end;
//         }
//         field(7; "No. Series"; Code[10])
//         {
//             DataClassification = CustomerContent;
//             TableRelation = "No. Series".Code;
//         }
//         field(8; Status; Option)
//         {
//             DataClassification = CustomerContent;
//             OptionMembers = Open,Approved,"Pending Approval",Rejected;
//             OptionCaption = 'Open,Approved,Pending Approval,Rejected';
//             Editable = false;
//         }
//         field(9; Posted; Boolean)
//         {
//             Editable = false;
//             DataClassification = CustomerContent;

//         }

//         field(24; "Bal Account Type"; Option)
//         {
//             Caption = 'Paying Account Type';
//             OptionMembers = "G/L Account",Customer,Vendor,"Bank Account",Employee;
//         }
//         field(25; "Bal Account No."; Code[20])
//         {
//             Caption = 'Paying Account No.';
//             DataClassification = CustomerContent;
//             TableRelation = "G/L Account"."No.";

//             trigger OnValidate()
//             begin
//                 IF GLAccount2.GET("Bal Account No.") THEN
//                     "Bal Account Name" := GLAccount2.Name
//                 ELSE
//                     "Bal Account Name" := '';
//             end;
//         }
//         field(11; "Bal Account Name"; Text[50])
//         {
//             Caption = 'Paying Account Name';
//             DataClassification = CustomerContent;
//             Editable = false;
//         }
//         field(12; "Shortcut Dimension 4 Code"; Code[20])
//         {
//             DataClassification = CustomerContent;
//             CaptionClass = '1,2,3';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));

//             trigger OnValidate()
//             begin
//                 ValidateShortcutDimCode(3, "Shortcut Dimension 4 Code");
//             end;
//         }
//         field(13; "Request Description"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(17; "Current Pending Approver"; Code[50])
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(19; "Request Amount (LCY)"; Decimal)
//         {
//             FieldClass = FlowField;
//             CalcFormula = Sum("Payment Voucher Line"."Amount (LCY)" WHERE("Document No." = FIELD("No.")));
//         }
//         field(20; "Request Amount"; Decimal)
//         {
//             FieldClass = FlowField;
//             CalcFormula = Sum("Payment Voucher Line".Amount WHERE("Document No." = FIELD("No.")));
//         }
//         field(480; "Dimension Set ID"; Integer)
//         {
//             CaptionML = ENU = 'Dimension Set ID';
//             Editable = false;
//             TableRelation = "Dimension Set Entry";
//             DataClassification = CustomerContent;

//             trigger OnLookup()
//             begin
//                 // ShowDocDim;
//             end;
//         }


//     }

//     keys
//     {
//         key(Key1; "No.")
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

//     LOCAL procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
//     var
//         OldDimSetID: Integer;
//     begin
//         OldDimSetID := "Dimension Set ID";
//         // DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
//         IF "No." <> '' THEN
//             MODIFY;
//     end;

//     var
//         //DimMgt: Codeunit DimensionManagement;
//         GLAccount2: Record "G/L Account";
// }