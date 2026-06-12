page 70119 "EVK IssuedReconStatementList"
{
    PageType = List;
    SourceTable = "EVK Issued Rec. Stat. Header";
    UsageCategory = Lists;
    Caption = 'Issued Debt Reconcilation Statements', Comment = 'lt-LT="Išrašyto skolų suderinimo aktai"';
    ApplicationArea = Suite;
    CardPageId = "EVK Issued Reconcil. Statement";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendras"';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies reconcilation statement no..', Comment = 'lt-LT="Nurodo suderinimo akto numerį"';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies statement type.', Comment = 'lt-LT="Nurodo akto tipą"';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer no..', Comment = 'lt-LT="Nurodo pirkėjo numerį"';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies vendor No..', Comment = 'lt-LT="Nurodo tiekėjo numerį"';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor name.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo pavadinimą"';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies document date.', Comment = 'lt-LT="Nurodo dokumento datą"';
                }
                field("Reconcile Date"; Rec."Reconcile Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies reconcile date.', Comment = 'lt-LT="Nurodo suderinimo datą"';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Remaining Amt. (LCY).', Comment = 'lt-LT="Rodo likusią sumą (LCY)."';
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = All;
                    ToolTip = 'Statement sent', Comment = 'lt-LT="Akto išsiųsta"';
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies cancelled statement.', Comment = 'lt-LT="Nurodo atšauktą akto"';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send by &Email")
            {
                Caption = 'Send by &Email', Comment = 'lt-LT="Išsiųsti el. paštu"';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.', Comment = 'lt-LT="Pasiruoškite išsiųsti dokumentą el. paštu. Išsiverčia el. pašto langas, iš anksto užpildytas klientui, kuriam galite pridėti ar pakeisti informaciją prieš išsiunčiant el. laišką."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    EVKIssuedRecStatementHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(EVKIssuedRecStatementHeader);
                    EVKIssuedRecStatementHeader.PrintRecords(FALSE, TRUE, FALSE);
                end;
            }
        }
        area(Reporting)
        {
            action(ShowReconcilationStatementReport)
            {
                ApplicationArea = All;
                Caption = 'Debt Reconc. Report', Comment = 'lt-LT="Skolų suderinimo ataskaita"';
                ToolTip = 'View debt reconciliation report.', Comment = 'lt-LT="Peržiūrėti dėl skolų suderinimo ataskaitą"';
                Image = Report;

                trigger OnAction()
                begin
                    Clear(EVKIssuedDebtReconcilStatement);
                    Clear(EVKIssuedRecStatementHeader);
                    EVKIssuedRecStatementHeader.Reset();
                    if Rec."No." <> '' then
                        EVKIssuedRecStatementHeader.setrange("No.", Rec."No.");
                    if Rec."Customer No." <> '' then
                        EVKIssuedRecStatementHeader.setrange("Customer No.", Rec."Customer No.");
                    if Rec."Vendor No." <> '' then
                        EVKIssuedRecStatementHeader.setrange("Vendor No.", Rec."Vendor No.");
                    EVKIssuedDebtReconcilStatement.SetTableView(EVKIssuedRecStatementHeader);
                    EVKIssuedDebtReconcilStatement.run();
                end;
            }

        }
    }
    var
        EVKIssuedRecStatementHeader: record "EVK Issued Rec. Stat. Header";
        EVKIssuedDebtReconcilStatement: Report "EVK Issued Debt Recon. Stat.";

}
