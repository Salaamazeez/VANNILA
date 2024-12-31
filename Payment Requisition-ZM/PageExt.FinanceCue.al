tableextension 50001 MyExtension extends "Finance Cue"
{
    fields
    {
        field(50000; "Approved Payment Req"; Integer)
        {
            CalcFormula = count("Payment Requisition" where(Status = filter(Approved)));
            Caption = 'Approved Payment Requisition';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}