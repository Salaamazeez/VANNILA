table 50130 "Purch. Requistion"
//table 50000 PurcRequistion
{
    //Created by Akande

    DataClassification = ToBeClassified;
    LookupPageId = "Purchase Req. List Dummy";
    //  DrillDownPageId = "Apprv. Purch. Requisition Lis";
    fields
    {

        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            trigger OnValidate()
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    PaymentMgtSetup.GET;
                    NoSeriesMgt.TestManual(PaymentMgtSetup."Purchase Requisition Nos.");
                    "No. Series" := '';
                END;
            END;
        }


        field(2; Date; Date)
        {

            DataClassification = ToBeClassified;
        }
        field(4; Requester; Text[100])
        {
            TableRelation = "User Setup"."User ID";
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            Editable = true;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
            trigger OnValidate()
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            Editable = true;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
            trigger OnValidate()
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

            END;

        }
        field(7; "No. Series"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
        }

        field(8; Status; Option)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';

        }

        field(9; Treated; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            //DataClassification = ToBeClassified;
        }

        field(10; "Request Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(11; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID';
            Editable = false;
            trigger OnLookup()
            BEGIN
                ShowDocDim;
            END;

        }
        field(12; "Requisition Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Requisition Line".Amount WHERE("Document No." = FIELD("No.")));
        }

        field(13; "Requester No."; Code[30])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(14; "Entry No."; Integer)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(15; PostIssuePrint; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(16; Sender; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Sent Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(18; "Mail Body"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(20; "Purchase Order Posted"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(21; "Prefered Vendor"; Code[20])
        {
            TableRelation = Vendor."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            BEGIN
                TestStatusOpen;
                IF SuppRec.GET("Prefered Vendor") THEN
                    "Prefered Vendor Name" := SuppRec.Name;
            END;

        }

        field(22; "Prefered Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(23; "Requisition No."; Code[50])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(26; "Purch. Invoice  Created"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(27; "SRQ Ref.No."; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(489; "Last Modified Date Time"; DateTime)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(490; "Last Date Modified"; Date)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(491; "Last Modified By"; Text[100])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(50000; "Purch. Quote Created?"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "Purch. Quote Ref. No."; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "Quote Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Quote Created"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50006; "Purchase Invoice Created"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50007; "Purchase Invoice Posted"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50008; "Purchase Invoice Code"; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(50010; "Purch.Order Ref.No."; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(50020; "Purch. Order Created?"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

        field(50021; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name" WHERE(Blocked = FILTER(false));
        }

        field(50022; "Budget Utilized"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Requisition Line"."Amount (LCY)" WHERE("Shortcut Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
            "Shortcut Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
             "Budget Name" = FIELD("Budget Name"),
             "Document No." = FIELD("No.")));
            // trigger OnValidate()
            // BEGIN
            //     IF "Budget Utilized" < "Budgetted Amount" THEN BEGIN
            //     "Budget Rem. Amount" := "Budgetted Amount" - "Budget Utilized";
            //     END
            //     ELSE
            //     MESSAGE('%1 CAN NOT BE GREATER THAN %2 ',FIELDCAPTION("Budget Utilized"),FIELDCAPTION("Budgetted Amount"));}
            // END;

        }
        field(50023; "Budgetted Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Name" = FIELD("Budget Name"),
            "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
            "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));
        }

        field(50024; "Budget Rem. Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        // field(50002; "User Code"; Code[20])
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


        // field(50111; "Actual User"; Text[250])
        // {

        // }
        // field(50012; "User Code 2"; Code[20])
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

        // field(3; "Actual User 2"; Text[250])
        // {

        // }
        // field(19; "User Code 3"; Code[20])
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


        // field(24; "Actual User 3"; Text[250])
        // {

        // }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    var
        custSetup: Record "Payment Mgt Setup";
    begin
        // TestField("User Code");
        //TestField("User Code 2");
        IF "No." = '' THEN BEGIN
            PaymentMgtSetup.GET;
            PaymentMgtSetup.TESTFIELD("Payment Requisition Nos.");
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Purchase Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "Requester No." := UserId;
            Requester := UserId;
        END;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        "Last Modified By" := USERID;

    end;

    trigger OnDelete()
    begin
        TestStatusOpen;
        PurchRequisitionLine.SETRANGE("Document No.", "No.");
        IF PurchRequisitionLine.FINDFIRST THEN
            PurchRequisitionLine.DELETEALL;
    end;

    trigger OnRename()
    begin
        TestStatusOpen;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        // DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        // OldDimSetID := "Dimension Set ID";
        // "Dimension Set ID" :=
        //   DimMgt.EditDimensionSet(
        //     "Dimension Set ID", STRSUBSTNO('%1', "No."),
        // //     "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        // IF OldDimSetID <> "Dimension Set ID" THEN
        //     MODIFY;
    end;

    procedure CreatePurchaseQuote()
    var
        PurchOrd2: Record "Purchase Header";
        PurchNo2: Code[20];
        PurchordLines2: Record "Purchase Line";
        PurchReqlines2: Record "Purchase Requisition Line";
        PurchReq2: Record "Purch. Requistion";
        LINENO2: Integer;
        FA2: Record "Fixed Asset";
        Stock2: Record "Item";
        GL2: Record "G/L Account";
        Text50210: TextConst ENU = 'Purchase quote %1 has been created for Purchase Requisition %2';

    begin
        IF "Quote Created" = TRUE THEN
            ERROR('PURCHASE QUOTE ALREADY CREATED FOR THIS PRQ')
        ELSE BEGIN
            IF CONFIRM('This Action  Will Create A Purchase Quote for This Purchase Requisition Continue?', FALSE) THEN
                MESSAGE(Text50210, PurchHeader.FIELDCAPTION("No."), "No.")
            ELSE
                ERROR('No Purchase Requisition Created');

            IF "Prefered Vendor" <> '' THEN BEGIN
                PurchaseSetup2.GET;
                PurchNo2 := NoSeriesMgt.GetNextNo(PurchaseSetup2."Quote Nos.", TODAY, TRUE);
                PurchOrd2.INIT;
                PurchOrd2."Document Type" := PurchOrd2."Document Type"::Quote;
                PurchOrd2."No." := PurchNo2;
                PurchOrd2."Purch REQ Ref No." := "No.";
                //PurchReq2.RESET; 
                "Quote Created" := TRUE;
                "Quote Code" := PurchOrd2."No.";
                PurchOrd2.INSERT(TRUE);
                PurchOrd2.VALIDATE(PurchOrd2."Buy-from Vendor No.", "Prefered Vendor");
                PurchOrd2.MODIFY(TRUE);

                //get requisition lines to upload to purchase lines
                PurchReqlines2.SETRANGE(PurchReqlines2."Document No.", "No.");
                IF PurchReqlines2.FINDSET THEN
                    REPEAT
                        PurchordLines2.INIT;
                        LINENO2 += 10000;
                        PurchordLines2."Document Type" := PurchOrd2."Document Type";
                        PurchordLines2."Document No." := PurchOrd2."No.";
                        PurchordLines2."Line No." := LINENO2;
                        PurchordLines2.INSERT;
                        PurchordLines2.VALIDATE(PurchordLines2."Buy-from Vendor No.", PurchOrd2."Buy-from Vendor No.");
                        IF (PurchReqlines2.Type = PurchReqlines2.Type::Asset) THEN BEGIN
                            PurchordLines2.VALIDATE(Type, PurchordLines2.Type::"Fixed Asset");
                            IF FA2.GET(PurchReqlines2."No.") THEN
                                PurchordLines2.VALIDATE("No.", PurchReqlines2."No.");
                        END;
                        IF PurchReqlines2.Type = PurchReqlines2.Type::Stock THEN BEGIN
                            PurchordLines2.VALIDATE(Type, PurchordLines2.Type::Item);
                            IF Stock2.GET(PurchReqlines2."No.") THEN
                                PurchordLines2.VALIDATE("No.", PurchReqlines2."No.");
                        END;
                        IF PurchReqlines2.Type = PurchReqlines2.Type::Service THEN BEGIN
                            PurchordLines2.VALIDATE(Type, PurchordLines2.Type::"G/L Account");
                            IF GL2.GET(PurchReqlines2."No.") THEN
                                PurchordLines2.VALIDATE("No.", "No.");
                        END;
                        PurchordLines2.VALIDATE("Shortcut Dimension 1 Code", PurchReqlines2."Shortcut Dimension 1 Code");
                        PurchordLines2.VALIDATE("Shortcut Dimension 2 Code", PurchReqlines2."Shortcut Dimension 2 Code");
                        PurchordLines2.VALIDATE(Quantity, PurchReqlines2.Quantity);
                        PurchordLines2.VALIDATE("Unit Cost", PurchReqlines2."Unit Cost");
                        PurchordLines2.VALIDATE("Direct Unit Cost", PurchReqlines2."Unit Cost");
                        PurchordLines2.VALIDATE("Line Amount", PurchReqlines2.Amount);
                        //PurchordLines.VALIDATE("Location code",PurchReqlines."location code");
                        PurchordLines2.MODIFY;

                    UNTIL PurchReqlines2.NEXT = 0;
                COMMIT;
                PAGE.RUNMODAL(49, PurchOrd2);
            END ELSE
                ERROR('Please Specify Prefered Vendor');
        END;



        // {PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
        // PurchaseHeader.INSERT(TRUE);
        // COMMIT;

        // PurchaseHeader."Requisition No.":= "No.";
        // PurchaseHeader.MODIFY;

        // PAGE.RUN(PAGE::"Purchase Quote",PurchaseHeader);}

    end;

    procedure CreatePurchaseInvoice()
    var
        PurchInv: Record "Purchase Header";
        PurchNo: Code[20];
        PurchinvLines: Record "Purchase Line";
        PurchReqlines: Record "Purchase Requisition Line";
        PurchReq: Record "Purch. Requistion";
        LINENO: Integer;
        FA: Record "Fixed Asset";
        Stock: Record Item;
        GL: Record "G/L Account";
    begin
        // // ERROR('Purchase Invoice already created for this Quote')
        //ELSE
        // BEGIN
        IF CONFIRM('This Action Will Create A Purchase Invoice for This requisition, Continue?', FALSE) THEN
            MESSAGE('Purchase Invoice has %1 has been generated for Purchase Requisition %2', PurchHeader."No.", "No.")

        ELSE
            ERROR('No Purchase Invoice Created');

        IF "Prefered Vendor" <> '' THEN BEGIN
            PurchaseSetup.GET;
            PurchNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Invoice Nos.", TODAY, TRUE);
            PurchInv.INIT;
            PurchInv."Document Type" := PurchInv."Document Type"::Invoice;
            PurchInv."No." := PurchNo;
            "Purchase Invoice Code" := PurchNo;
            "Purchase Invoice Created" := TRUE;
            PurchInv."Purch REQ Ref No." := "No.";
            PurchInv.INSERT(TRUE);
            PurchInv.VALIDATE(PurchInv."Buy-from Vendor No.", "Prefered Vendor");
            PurchInv.MODIFY(TRUE);
            PurchReqlines.SETRANGE(PurchReqlines."Document No.", "No.");
            IF PurchReqlines.FINDSET THEN
                REPEAT
                    PurchinvLines.INIT;
                    LINENO += 10000;
                    PurchinvLines."Document Type" := PurchInv."Document Type";
                    PurchinvLines."Document No." := PurchInv."No.";
                    PurchinvLines."Line No." := LINENO;
                    PurchinvLines.INSERT;
                    PurchinvLines.VALIDATE(PurchinvLines."Buy-from Vendor No.", PurchInv."Buy-from Vendor No.");
                    IF (PurchReqlines.Type = PurchReqlines.Type::Asset) THEN BEGIN
                        PurchinvLines.VALIDATE(Type, PurchinvLines.Type::"Fixed Asset");
                        IF FA.GET(PurchReqlines."No.") THEN
                            PurchinvLines.VALIDATE("No.", PurchReqlines."No.");
                    END;// ELSE ERROR('Pleaase Register This Asset In Assets Register Before Invoice');
                    IF PurchReqlines.Type = PurchReqlines.Type::Stock THEN BEGIN
                        PurchinvLines.VALIDATE(Type, PurchinvLines.Type::Item);
                        IF Stock.GET(PurchReqlines."No.") THEN
                            PurchinvLines.VALIDATE("No.", PurchReqlines."No.");
                    END;
                    IF PurchReqlines.Type = PurchReqlines.Type::Service THEN BEGIN
                        PurchinvLines.VALIDATE(Type, PurchinvLines.Type::"G/L Account");
                        IF GL.GET(PurchReqlines."No.") THEN
                            PurchinvLines.VALIDATE("No.", PurchReqlines."No.");
                    END;
                    PurchinvLines.VALIDATE("Shortcut Dimension 1 Code", PurchReqlines."Shortcut Dimension 1 Code");
                    PurchinvLines.VALIDATE("Shortcut Dimension 2 Code", PurchReqlines."Shortcut Dimension 2 Code");
                    PurchinvLines.VALIDATE(Quantity, PurchReqlines.Quantity);
                    PurchinvLines.VALIDATE("Direct Unit Cost", PurchReqlines."Unit Cost");
                    PurchinvLines.VALIDATE("Unit Cost", PurchReqlines."Unit Cost");
                    PurchinvLines.VALIDATE("Line Amount", PurchReqlines.Amount);

                    //PurchINVLines.VALIDATE("Location code",PurchReqlines."location code");
                    PurchinvLines.MODIFY;

                UNTIL PurchReqlines.NEXT = 0;

            COMMIT;
            PAGE.RUN(51, PurchInv);
        END ELSE
            ERROR('Specify Prefered Vendor Before Invoice');

    end;

    procedure CreatePurchaseOrder()
    var
        PurchOrd: Record "Purchase Header";
        PurchOrd3: Record "Purchase Header";
        PurchOrd4: Record "Purchase Header";
        PurchNo: Code[20];
        PurchordLines: Record "Purchase Line";
        PurchReqlines: Record "Purchase Requisition Line";
        PurchReq: Record "Purch. Requistion";
        LINENO: Integer;
        FA: Record "Fixed Asset";
        Stock: Record Item;
        GL: Record "G/L Account";
        PurchOrderReport: Report Order;
        mYsT: Text[200];
        mYsTs: List of [Text];
        i: Integer;
    begin
        IF CONFIRM('This Action Will Create A Purchase Order for This Requisition, Continue?', FALSE) THEN
            MESSAGE('Purchase Order %1 has been generated for Purchase Requisition %2', PurchHeader."No.", "No.")

        ELSE
            ERROR('No Purchase Order Created');
        IF "No." <> '' THEN BEGIN

            //get requisition lines to upload to purchase lines and headers
            PurchReqlines.SETRANGE(PurchReqlines."Document No.", "No.");
            IF PurchReqlines.FINDSET THEN
                REPEAT
                    PurchordLines.INIT;
                    //  Message(PurchReqlines."Vendor No.");
                    PurchOrd3.SetRange("Buy-from Vendor No.", PurchReqlines."Vendor No.");
                    PurchOrd3.SetRange("Purch REQ Ref No.", PurchReqlines."Document No.");
                    if PurchOrd3.Count = 0 then begin
                        PurchaseSetup.GET;
                        PurchNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Order Nos.", TODAY, TRUE);
                        PurchOrd.INIT;
                        //  PurchOrd."User Code" := "User Code";
                        PurchOrd."Document Type" := PurchOrd."Document Type"::Order;
                        //  PurchOrd."Actual User" := "User Code";
                        PurchOrd."No." := PurchNo;
                        // PurchOrd."Actual User" := "User Code";
                        "Purch.Order Ref.No." := PurchNo;
                        "Purch. Order Created?" := TRUE;
                        PurchOrd."Purch REQ Ref No." := "No.";

                        PurchOrd.INSERT(TRUE);
                        PurchOrd.VALIDATE(PurchOrd."Buy-from Vendor No.", PurchReqlines."Vendor No.");

                        PurchOrd.MODIFY(TRUE);
                    end;
                    mYsT := mYsT + '-' + PurchNo;
                    //Message(mYsT);
                    LINENO += 10000;
                    PurchordLines."Document Type" := PurchOrd."Document Type";
                    PurchordLines."Document No." := PurchOrd."No.";
                    PurchordLines."Line No." := LINENO;
                    PurchordLines.INSERT;
                    PurchordLines.VALIDATE(PurchordLines."Buy-from Vendor No.", PurchOrd."Buy-from Vendor No.");
                    IF (PurchReqlines.Type = PurchReqlines.Type::Asset) THEN BEGIN
                        PurchordLines.VALIDATE(Type, PurchordLines.Type::"Fixed Asset");
                        IF FA.GET(PurchReqlines."No.") THEN
                            PurchordLines.VALIDATE("No.", PurchReqlines."No.");
                    END;
                    IF PurchReqlines.Type = PurchReqlines.Type::Stock THEN BEGIN
                        PurchordLines.VALIDATE(Type, PurchordLines.Type::Item);
                        IF Stock.GET(PurchReqlines."No.") THEN
                            PurchordLines.VALIDATE("No.", PurchReqlines."No.");
                    END;
                    IF PurchReqlines.Type = PurchReqlines.Type::Service THEN BEGIN
                        PurchordLines.VALIDATE(Type, PurchordLines.Type::"G/L Account");
                        IF GL.GET(PurchReqlines."No.") THEN
                            PurchordLines.VALIDATE("No.", PurchReqlines."No.");
                    END;
                    PurchordLines.VALIDATE("Shortcut Dimension 1 Code", PurchReqlines."Shortcut Dimension 1 Code");
                    PurchordLines.VALIDATE("Shortcut Dimension 2 Code", PurchReqlines."Shortcut Dimension 2 Code");
                    PurchordLines.VALIDATE(Quantity, PurchReqlines.Quantity);
                    PurchordLines.VALIDATE("Unit Cost", PurchReqlines."Unit Cost");
                    PurchordLines.VALIDATE("Direct Unit Cost", PurchReqlines."Unit Cost");
                    PurchordLines.VALIDATE("Line Amount", PurchReqlines.Amount);
                    //PurchordLines.VALIDATE("Location code",PurchReqlines."location code");
                    PurchordLines.MODIFY;

                    mYsTs := mYsT.Split('-');
                    for i := 1 to mYsTs.Count() do begin


                        PurchOrd4.SetRange("No.", mYsTs.Get(i));
                        // if PurchOrd4.FindFirst() then begin
                        repeat
                            // Message(PurchOrd4."No.");
                            Report.Run(50105, false, true, PurchOrd4);
                        until PurchOrd4.Next() = 0;
                        // end;
                    end;
                UNTIL PurchReqlines.NEXT = 0;
            COMMIT;
            // PurchOrderReport.SetTableView(PurchOrd);

            //  PAGE.RUNMODAL(50, PurchOrd);
        END ELSE
            ERROR('Please Specify Prefered Vendor');
    end;
    //Recepients: List of [Text];
    procedure TestStatusOpen()
    var
        myInt: Integer;
    begin
        TESTFIELD(Status, Status::Open);
    end;

    procedure BudgetAmountGreater()
    var
        myInt: Integer;
    begin
        IF "Budget Rem. Amount" < 0 THEN
            MESSAGE('%1 CAN NOT BE GREATER THAN %2', FIELDCAPTION("Budget Utilized"), FIELDCAPTION("Budgetted Amount"));

    end;

    procedure CalCRemBudgAmount()
    var
        myInt: Integer;
    begin
        "Budget Rem. Amount" := ("Budgetted Amount" - "Budget Utilized");
    end;

    var
        PaymentMgtSetup: Record "Payment Mgt Setup";
        PurchaseSetup: Record "Purchases & Payables Setup";
        PurchaseSetup2: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        // DimMgt: Codeunit DimensionManagement;
        PurchHeader: Record "Purchase Header";
        PurchRequisitionLine: Record "Purchase Requisition Line";
        SuppRec: Record Vendor;
}