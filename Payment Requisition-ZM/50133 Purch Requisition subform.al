page 50133 "Purchase Requisition Subform"
{
    //Created by Salaam Azeez

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Requisition Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = All;
                }
                field("Required Item/Service"; Rec."Required Item/Service")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                // field("Currency Code";Rec. "Currency Code")
                // {
                //     ApplicationArea = All;
                // }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                // field("Budget Name";Rec. "Budget Name")
                // {
                //     ApplicationArea = All;
                // }
                // field("Currency Factor";Rec. "Currency Factor")
                // {
                //     ApplicationArea = All;
                // }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                // field("Shortcut Dimension 2 Code";Rec. "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Currency Date";Rec. "Currency Date")
                // {
                //     ApplicationArea = All;
                // }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                // field("Budget Utilized";Rec. "Budget Utilized")
                // {
                //     ApplicationArea = All;
                // }
                // field("Budgetted Amount";Rec. "Budgetted Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Budget Rem. Amount";Rec. "Budget Rem. Amount")
                // {
                //     ApplicationArea = All;
                // }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }


            }
        }
        // area(System)
        // {
        // }
    }

    actions
    {
        area(Processing)
        {
            action("Item by Location")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    Item: Record Item;
                begin
                    Page.RunModal(Page::"Items by Location", Item);
                    //PAGE.RUN(PAGE::"Items by Location",Rec);
                end;
            }
        }
    }
    var
        sales: page "Sales Order Subform";
}