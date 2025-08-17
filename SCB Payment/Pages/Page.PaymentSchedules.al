page 90243 "Payment Schedules"
{
    PageType = List;
    SourceTable = "Payment Schedule";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntriesType; Rec."Entries Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entries Type field.';
                }
                field(PayeeNo; Rec."Payee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Rec."Entries Type" of
                            Rec."entries type"::"Saved Beneficiary":
                                LookUpSavedBeneficiaryINPaymentSchedule();
                            Rec."entries type"::Employee:
                                LookUpEmployee();
                        end;
                    end;
                }
                field(PayeeName; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee Name field.';
                }
                field(CBNBankCode; Rec."CBN Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CBN Bank Code field.';
                    Visible = false;
                }
                field(PayeeAccountNo; Rec."Payee Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee Account No. field.';
                }
                field(PayeeBankBranch; Rec."Payee Bank Branch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee Bank Branch field.';
                }
                field(PayeeBankSORTCODE; Rec."Payee Bank SORT-CODE")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee Bank SORT-CODE field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field(ICPartnerCode; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IC Partner Code field.';
                    Visible = false;
                }
                field(SaveBeneficiary; Rec."Save Beneficiary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Save Beneficiary field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField("IC Partner Code", '');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Entries Type" := Rec."Entries type"::"Imputed Entry";
        Rec."Line No." := Rec.GetNextLineNo(Rec."Source Document No.", Rec."Source Line No.");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("IC Partner Code", '');
    end;

    local procedure LookUpSavedBeneficiaryINPaymentSchedule()
    var
        MyPaymentSchedule: Record "Payment Schedule";
        PaymentSchedulesPage: Page "Payment Schedules";
    begin
        MyPaymentSchedule.SetRange("Save Beneficiary", true);
        MyPaymentSchedule.SetFilter("Source Document No.", '<>%1', Rec."Source Document No.");
        Clear(PaymentSchedulesPage);
        PaymentSchedulesPage.Editable := false;
        PaymentSchedulesPage.LookupMode := true;
        PaymentSchedulesPage.SetTableview(MyPaymentSchedule);
        if PaymentSchedulesPage.RunModal() = Action::LookupOK then begin
            PaymentSchedulesPage.GetRecord(MyPaymentSchedule);
            Rec.Validate("Payee No.", MyPaymentSchedule."Payee No.");
            Rec.Validate("Payee Account No.", MyPaymentSchedule."Payee Account No.");
            Rec.Validate("Payee Name", MyPaymentSchedule."Payee Name");
            Rec.Validate("CBN Bank Code", MyPaymentSchedule."CBN Bank Code");
            Rec.Validate("Payee Bank", MyPaymentSchedule."Payee Bank");
            Rec.Validate("Payee BVN", MyPaymentSchedule."Payee BVN");
            Rec.Validate("Posting Description", MyPaymentSchedule."Posting Description");
            Rec.Validate(Amount, MyPaymentSchedule.Amount);
        end;



    end;

    local procedure ValidateBankDetailsFromEmployeePreferedBank(EmpNo: Code[20])
    var
        Employee: Record Employee;
        //EmployeeBankAccountRec: Record "Employee Bank Account";
    begin
    //     Employee.Get(EmpNo);
    //     EmployeeBankAccountRec.SetRange("Employee No.", EmpNo);
    //     EmployeeBankAccountRec.SetRange("Use for Payroll", true);
    //     if EmployeeBankAccountRec.FindFirst() then begin
    //         if (EmployeeBankAccountRec."Bank Account Name" <> Employee.FullName()) and (EmployeeBankAccountRec."Bank Account Name" <> '') then
    //             Rec.Validate("Payee Name", EmployeeBankAccountRec."Bank Account Name");
    //         Rec.Validate("CBN Bank Code", EmployeeBankAccountRec."CBN Bank Code");
    //         Rec.Validate("Payee Account No.", EmployeeBankAccountRec."Bank Account No.");
    //         Rec.Validate("Payee Bank", EmployeeBankAccountRec."Bank Name");
    //         Rec.Validate("Payee BVN", EmployeeBankAccountRec."BVN Number");
    //     end;
    end;

    local procedure LookUpEmployee()
    var
        EmployeeRec: Record Employee;
        EmployeeList: Page "Employee List";
    begin
        Clear(EmployeeList);
        EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);
        EmployeeList.Editable := false;
        EmployeeList.LookupMode := true;
        EmployeeList.SetTableview(EmployeeRec);
        if EmployeeList.RunModal() = Action::LookupOK then begin
            EmployeeList.GetRecord(EmployeeRec);
            Rec.Validate("Payee No.", EmployeeRec."No.");
            Rec.Validate("Payee Name", EmployeeRec.FullName());
            ValidateBankDetailsFromEmployeePreferedBank(EmployeeRec."No.");
        end;
    end;
}

