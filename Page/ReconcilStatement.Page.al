page 70121 "EVK Reconcil Statement"
{
    PageType = Document;
    SourceTable = "EVK Reconcil. Statement Header";
    UsageCategory = None;
    Caption = 'Reconcilation Statement', Comment = 'lt-LT="Suderinimo aktas"';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendra informacija"';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies reconcilation statement no..', Comment = 'lt-LT="Nurodo suderinimo akto numerį"';
                    Importance = Promoted;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies type.', Comment = 'lt-LT="Nurodo tipą"';

                    trigger OnValidate()
                    begin
                        customer_enabled := false;
                        vendor_enabled := false;
                        apply_entries := false;
                        case Rec.Type of
                            Rec.Type::"Customer":
                                customer_enabled := true;
                            Rec.Type::"Vendor":
                                vendor_enabled := true;
                            Rec.Type::"Vendor/Customer":
                                begin
                                    customer_enabled := true;
                                    vendor_enabled := true;
                                    apply_entries := true;
                                end
                        end;
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer no..', Comment = 'lt-LT="Nurodo kliento numerį"';
                    Editable = customer_enabled;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies vendor No..', Comment = 'lt-LT="Nurodo tiekėjo numerį"';
                    editable = vendor_enabled;
                }
                field("Apply Entries"; Rec."Apply Entries")
                {
                    ApplicationArea = All;
                    ToolTip = 'Apply Entries', Comment = 'lt-LT="Taikyti įrašus"';
                    editable = apply_entries;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor name.', Comment = 'lt-LT="Nurodo kliento/tiekėjo vardą"';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor Registration No..', Comment = 'lt-LT="Nurodo kliento/tiekėjo registracijos numerį"';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor VAT Registration No..', Comment = 'lt-LT="Nurodo kliento/tiekėjo PVM registracijos numerį"';
                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor address.', Comment = 'lt-LT="Nurodo kliento/tiekėjo adresą"';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor additional address.', Comment = 'lt-LT="Nurodo kliento/tiekėjo papildomą adresą"';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal Code.', Comment = 'lt-LT="Nurodo pašto kodą"';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city name of the customer/vendor.', Comment = 'lt-LT="Nurodo kliento/tiekėjo miesto pavadinimą"';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.', Comment = 'lt-LT="Nurodo datos, kai buvo sukurtas susijęs dokumentas"';
                }
                field("Reconcile Date"; Rec."Reconcile Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile date.', Comment = 'lt-LT="Nurodo suderinimo datą"';
                    Enabled = not statementDateVisible;
                }
                field("Reconcile Start Date"; Rec."Reconcile Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile start date.', Comment = 'lt-LT="Nurodo suderinimo pradžios datą"';
                    Enabled = statementDateVisible;
                }
                field("Reconcile End Date"; Rec."Reconcile End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile end date.', Comment = 'lt-LT="Nurodo suderinimo pabaigos datą"';
                    Enabled = statementDateVisible;
                }
                field("Use Period"; Rec."Use Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies reconcilation statement period.', Comment = 'lt-LT="Nurodo suderinimo akto laikotarpį"';
                    trigger OnValidate()
                    begin
                        statementDateVisible := Rec."Use Period";
                    end;
                }

                field(Accountant; Rec.Accountant)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows accountant.', Comment = 'lt-LT="Rodo buhalterį"';

                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer or vendor reconcile statement language Code.', Comment = 'lt-LT="Nurodo kliento ar tiekėjo suderinimo akto kalbos kodą"';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Remaining Amt. (LCY).', Comment = 'lt-LT="Rodo likusią sumą (LCY)"';
                }
                field("Debit (LCY)"; Rec."Debit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Debit (LCY).', Comment = 'lt-LT="Rodo debetą (LCY)"';
                }
                field("Credit (LCY)"; Rec."Credit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Credit (LCY).', Comment = 'lt-LT="Rodo kreditą (LCY)"';
                }
                field("Beginning Balance (LCY)"; Rec."Beginning Balance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies beginning balance (lcy).', Comment = 'lt-LT="Nurodo pradžios likutį (lcy)"';
                }
                field("Ending Balance (LCY)"; Rec."Ending Balance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies ending balance (lcy).', Comment = 'lt-LT="Nurodo pabaigos likutį (lcy)"';
                    Enabled = statementDateVisible;
                }

            }
            part("EVK Reconcil. Statement Lines"; "EVK Reconcil. Statement Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Reconcilation Statement No." = FIELD("No.");
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
                Caption = 'Issue', Comment = 'lt-LT="Išduoti"';
                Ellipsis = true;
                Image = ReleaseDoc;
                ShortCutKey = 'F9';
                ToolTip = 'Post the specified debt reconcilation statement.', Comment = 'lt-LT="Įrašykite nurodytą skolų suderinimo aktą"';

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
            action(SuggestReconcilationStatementLines)
            {
                ApplicationArea = All;
                Caption = 'Suggest Reconcilation Statement Lines', Comment = 'lt-LT="Pasiūlyti suderinimo akto eilutes"';
                ToolTip = 'Create reconcilation statement lines.', Comment = 'lt-LT="Sukurti suderinimo akto eilutes"';
                Image = Report;

                trigger OnAction()
                begin
                    Rec.TestField(Type);
                    case Rec.Type of
                        Rec.Type::"Customer":
                            Rec.TestField("Customer No.");
                        Rec.Type::"Vendor":
                            Rec.TestField("Vendor No.");
                        Rec.Type::"Vendor/Customer":
                            begin
                                Rec.TestField("Customer No.");
                                Rec.TestField("Vendor No.");
                            end;
                    end;

                    Clear(ReconcilStatementLine);
                    ReconcilStatementLine.Reset();
                    ReconcilStatementLine.Setrange("Reconcilation Statement No.", Rec."No.");

                    if ReconcilStatementLine.Count() > 0 then
                        if confirm(RowsWillBeDeletedLbl) then
                            ReconcilStatementLine.DeleteAll(false)
                        else
                            error(ActionCanceledErr);
                    Commit();

                    Clear(DebtReconcStatementSuggest);
                    DebtReconcStatementSuggest.SetParameter(Rec."Customer No.", Rec."Vendor No.", Rec.Type, Rec."Document Date", Rec."Use Period", Rec."Reconcile Date", Rec."Reconcile Start Date", Rec."Reconcile End Date", Rec.Accountant, Rec."No.");
                    DebtReconcStatementSuggest.run();
                end;
            }

            action(ShowReconcilationStatementReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test Report', Comment = 'lt-LT="Bandomoji ataskaita"';
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

    trigger OnOpenPage()
    begin
        customer_enabled := false;
        vendor_enabled := false;
        apply_entries := false;
        case Rec.Type of
            Rec.Type::"Customer":
                customer_enabled := true;
            Rec.Type::"Vendor":
                vendor_enabled := true;
            Rec.Type::"Vendor/Customer":
                begin
                    customer_enabled := true;
                    vendor_enabled := true;
                    apply_entries := true;
                end
        end
    end;

    trigger OnAfterGetRecord()
    begin
        statementDateVisible := Rec."Use Period";
    end;

    var
        ReconcilStatementHeader: Record "EVK Reconcil. Statement Header";
        ReconcilStatementLine: Record "EVK Reconcil. Statement Line";
        DebtReconcStatementSuggest: Report "EVK DebtReconcStatementSuggest";
        DebtReconcileStatement: Report "EVK Debt Reconcile Stat.";
        customer_enabled: boolean;
        vendor_enabled: boolean;
        apply_entries: boolean;
        RowsWillBeDeletedLbl: Label 'The rows will be deleted.', Comment = 'lt-LT="Busenos eilės bus ištrintos."';
        ActionCanceledErr: Label 'Action canceled.', Comment = 'lt-LT="Veiksmas atšauktas."';
        statementDateVisible: boolean;

}
