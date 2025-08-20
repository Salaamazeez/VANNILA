#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90233 "Payment-DebitAccounts"
{
    PageType = List;
    SourceTable = "Payment-DebitAccounts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Number"; Rec."Account Number")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Common Name"; Rec."Common Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field(Authorized; Rec.Authorized)
                {
                    ApplicationArea = All;
                }
                field("Allow Debit"; Rec."Allow Debit")
                {
                    ApplicationArea = All;
                }
                field("Has Debit Mandate"; Rec."Has Debit Mandate")
                {
                    ApplicationArea = All;
                }
                field("Mandate Ref Encrypted"; Rec."Mandate Ref Encrypted")
                {
                    ApplicationArea = All;
                }
                field("Synced To Nibss"; Rec."Synced To Nibss")
                {
                    ApplicationArea = All;
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field("Modified At"; Rec."Modified At")
                {
                    ApplicationArea = All;
                }
                field("Deleted At"; Rec."Deleted At")
                {
                    ApplicationArea = All;
                }
                field("Service Merchant Id"; Rec."Service Merchant Id")
                {
                    ApplicationArea = All;
                }
                field("Merchant Id"; Rec."Merchant Id")
                {
                    ApplicationArea = All;
                }
                field("Nibss Account Id"; Rec."Nibss Account Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Debit Accounts")
            {
                action("Fetch Debit Accounts")
                {
                    ApplicationArea = All;


                    trigger OnAction()
                    var
                        PaymentIntgrHook: Codeunit "Payment-Integr. Hook";
                    begin
                       // PaymentIntgrHook.GetDebitAccount();
                    end;
                }
            }
        }
    }
}

