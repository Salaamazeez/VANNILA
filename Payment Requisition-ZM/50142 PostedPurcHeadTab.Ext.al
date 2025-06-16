tableextension 50142 "Posted Purch. Header" extends "Purch. Inv. Header"
{
    //Created by Akande

    fields
    {
        // modify("Sell-to Customer No.")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         TestField("User Code");
        //         Error('Fill the user code first');
        //     end;
        // }
        //  modify()

        // Add changes to table fields here
        field(50109; "Purch REQ Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50000; Description; Text[250])
        {

        }
        //  field(8; Status; Option)
        // {
        //     Editable = false;
        //     OptionMembers = Open,"Pending Approval",Approved,Rejected;
        // }
        field(50111; "Actual User"; Text[100])
        {

        }
        field(50112; Comments; Text[200])
        {

        }
        // field(50002; "User Code"; Code[40])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }

        // field(50012; "User Code 2"; Code[40])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code 2") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User 2" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }

        // field(50022; "Actual User 2"; Text[100])
        // {

        // }
        // field(50023; "User Code 3"; Code[40])
        // {
        //     trigger OnValidate()
        //     var
        //         UserAuth: Record "User Authentication";
        //     begin
        //         if UserAuth.Get("User Code 3") then
        //             //if UserAuth.Status = UserAuth.Status::Active then
        //                 "Actual User 3" := UserAuth."User Name"
        //         else
        //             Error('You are not an authenticated user');
        //     end;

        //     //  end;
        // }


        // field(50034; "Actual User 3"; Text[100])
        // {

        // }

        // // field(50104; "WHT Code"; Code[20])
        // {
        //     TableRelation = "Tariff Codes".Code;
        // // }
        // field(50103; "WHT Amount"; Decimal)
        // {
        //     trigger OnValidate()

        //     var
        //     //  WHtPostingGr: Record "WHT Post Grp Tabl";
        //     begin
        //     end;


        // }
        // field(50101; "WHT Amount (LCY)"; Decimal)
        // {
        //     trigger OnValidate()

        //     var
        //     //  WHtPostingGr: Record "WHT Post Grp Tabl";
        //     begin
        //     end;


        // }
        // field(50104; "WHT Code"; Code[20])
        // {
        //     TableRelation = "Tariff Codes".Code;

        //     trigger OnValidate()
        //     begin
        //         TestStatusOpen;
        //         "WHT Amount" := 0;
        //         "WHT Rate" := 0;
        //         IF TCode.GET("WHT Code") THEN BEGIN
        //             "WHT Rate" := TCode.Percentage;
        //             //  GetPurchHeader;
        //             IF PurchHeader."Prices Including VAT" THEN
        //                 "WHT Amount" := ("WHT Rate" / (100 + "WHT Rate")) * "Amount Including VAT"
        //             ELSE
        //                 IF NOT PurchHeader."Prices Including VAT" THEN
        //                     "WHT Amount" := ("WHT Rate" / (100)) * Amount;
        //         END;
        //     end;

        // }
        // field(50100; "WHT Rate"; Decimal)
        // {

        // }
        field(50001; "Posted No Series"; Code[20])
        {

        }
        field(50002; "PInv Order No"; Code[20])
        {

        }
    }

    var
        myInt: Integer;
}