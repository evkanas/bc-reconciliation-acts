page 70123 "EVK Reconsil Statement List"
{
    PageType = List;
    SourceTable = "EVK Reconcil. Statement Header";
    UsageCategory = Lists;
    Caption = 'Debt Reconcilation Statement List', Comment = 'lt-LT="Skolų suderinimo aktų sąrašas"';
    ApplicationArea = Suite;
    CardPageId = "EVK Reconcil Statement";
    Editable = true;
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
                    ToolTip = 'Specifies statement type.', Comment = 'lt-LT="Nurodo aktų tipą"';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer no..', Comment = 'lt-LT="Nurodo kliento numerį"';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies vendor No..', Comment = 'lt-LT="Nurodo tiekėjo numerį"';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor name.', Comment = 'lt-LT="Nurodo kliento/tiekėjo vardą"';
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
                    ToolTip = 'Shows Remaining Amt. (LCY).', Comment = 'lt-LT="Rodo likusią sumą (LCY)"';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Issue)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Issue', Comment = 'lt-LT="Paskelbti"';
                Ellipsis = true;
                Image = ReleaseDoc;
                ShortCutKey = 'F9';
                ToolTip = 'Post the specified debt reconcilation statement.', Comment = 'lt-LT="Paskelbti nurodytą skolų suderinimo aktą"';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ReconcilStatementHeader);
                    REPORT.RunModal(REPORT::"EVK IssueDebtReconcileStat", true, true, ReconcilStatementHeader);
                    CurrPage.Update(false);
                end;
            }

        }
        area(Reporting)
        {
            action(CreateReconcilationStatements)
            {
                ApplicationArea = All;
                Caption = 'Create Reconcilation Statements', Comment = 'lt-LT="Sukurti suderinimo aktus"';
                ToolTip = 'Create reconcilation statements.', Comment = 'lt-LT="Sukurti suderinimo aktus"';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Clear(DebtReconcilStatementCreate);
                    DebtReconcilStatementCreate.Run();
                end;
            }
            action(ShowReconcilationStatementReport)
            {
                ApplicationArea = All;
                Caption = 'Test Report', Comment = 'lt-LT="Bandomasis ataskaita"';
                ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.', Comment = 'lt-LT="Peržiūrėti testinį ataskaitą, kad galėtumėte rasti ir pataisyti bet kokius klaidas prieš atliekant tikrąjį žurnalo ar dokumento įrašymą"';
                Image = TestReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Ellipsis = true;
                trigger OnAction()
                begin
                    Clear(DebtReconcileStatement);
                    Clear(ReconcilStatementHeader);
                    ReconcilStatementHeader.Reset();
                    if Rec."No." <> '' then
                        ReconcilStatementHeader.setrange("No.", Rec."No.");
                    if Rec."Customer No." <> '' then
                        ReconcilStatementHeader.setrange("Customer No.", Rec."Customer No.");
                    if Rec."Vendor No." <> '' then
                        ReconcilStatementHeader.setrange("Vendor No.", Rec."Vendor No.");
                    DebtReconcileStatement.SetTableView(ReconcilStatementHeader);

                    DebtReconcileStatement.Run();

                end;
            }
        }
    }
    var
        ReconcilStatementHeader: Record "EVK Reconcil. Statement Header";
        DebtReconcilStatementCreate: Report "EVK DebtReconcilStatCreate";
        DebtReconcileStatement: Report "EVK Debt Reconcile Stat.";
}
