pageextension 50030 BankAccReconciliation extends 379
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Ba&nk")
        {
            action(CustomImportBankStatement)
            {
                ApplicationArea = All;
                Caption = 'Upload Bank Statement';
                Image = Import;
                RunObject = xmlport "Bank Recon Import";
                Promoted = true;
            }
        }
        modify(ImportBankStatement)
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;
}