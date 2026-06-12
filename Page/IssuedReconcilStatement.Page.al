page 70118 "EVK Issued Reconcil. Statement"
{
    PageType = Document;
    SourceTable = "EVK Issued Rec. Stat. Header";
    UsageCategory = None;
    Caption = 'Issued Debt Reconcilation Statement', Comment = 'lt-LT="Išrašyto skolų suderinimo akto dokumentas"';
    Editable = false;

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
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies type.', Comment = 'lt-LT="Nurodo tipą"';
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
                    ToolTip = 'Specifies customer/vendor name.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo vardą"';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor Registration No..', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo registracijos numerį"';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor VAT Registration No..', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo PVM registracijos numerį"';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor address.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo adresą"';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer/vendor additional address.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo papildomą adresą"';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal Code.', Comment = 'lt-LT="Nurodo pašto kodą"';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city name of the customer/vendor.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo miesto vardą"';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.', Comment = 'lt-LT="Nurodo datą, kai buvo sukurtas susijęs dokumentas"';
                }
                field("Reconcile Date"; Rec."Reconcile Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile date.', Comment = 'lt-LT="Nurodo suderinimo datą"';
                }
                field("Reconcile Start Date"; Rec."Reconcile Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile start date.', Comment = 'lt-LT="Nurodo suderinimo pradžios datą"';
                }
                field("Reconcile End Date"; Rec."Reconcile End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconcile end date.', Comment = 'lt-LT="Nurodo suderinimo pabaigos datą"';
                }
                field("Use Period"; Rec."Use Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies reconcilation statement period.', Comment = 'lt-LT="Nurodo suderinimo aktų laikotarpį"';
                }
                field(Accountant; Rec.Accountant)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows accountant.', Comment = 'lt-LT="Rodo buhalterį"';
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies customer or vendor reconcile statement language Code.', Comment = 'lt-LT="Nurodo pirkėjo/tiekėjo suderinimo aktų kalbos kodą"';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Remaining Amt. (LCY).', Comment = 'lt-LT="Rodo likusį sumą (LCY)."';
                }
                field("Debit (LCY)"; Rec."Debit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Debit (LCY).', Comment = 'lt-LT="Rodo debetą (LCY)."';
                }
                field("Credit (LCY)"; Rec."Credit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows Credit (LCY).', Comment = 'lt-LT="Rodo kreditą (LCY)."';
                }
                field("Beginning Balance (LCY)"; Rec."Beginning Balance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies beginning balance (lcy).', Comment = 'lt-LT="Nurodo pradinį likutį (LCY)."';
                }
                field("Ending Balance (LCY)"; Rec."Ending Balance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies ending balance (lcy).', Comment = 'lt-LT="Nurodo pabaigos likutį (LCY)."';
                }
                field("Print Details"; Rec."Print Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies print details.', Comment = 'lt-LT="Nurodo spausdinimo detales"';
                    Editable = true;
                }
            }
            part("EVK Reconcil. Statement Line"; "EVK Reconcil. Statement Lines")
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
            action("Send by &Email")
            {
                Caption = 'Send by &Email', Comment = 'lt-LT="Siųsti el. paštu"';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.', Comment = 'lt-LT="Pasiruošimas siųsti dokumentą el. paštu. Atsidaro langas Siųsti el. paštu, kuris yra iš anksto užpildytas pirkėjo informacija, kur galite pridėti arba изменить информацию перед отправкой электронной почты."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    IssuedRecStatementHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(IssuedRecStatementHeader);
                    IssuedRecStatementHeader.PrintRecords(FALSE, TRUE, FALSE);
                end;
            }
        }
        area(Reporting)
        {
            action(ShowReconcilationStatementReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Debt Reconc. Report', Comment = 'lt-LT="Deksų suderinimo ataskaita"';
                ToolTip = 'View reconcilation statement report.', Comment = 'lt-LT="Peržiūrėti suderinimo aktų ataskaitą"';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Clear(IssuedDebtReconcilStatement);
                    Clear(IssuedDebtReconcilStatement);
                    IssuedRecStatementHeader.Reset();
                    if Rec."No." <> '' then
                        IssuedRecStatementHeader.setrange("No.", Rec."No.");
                    if Rec."Customer No." <> '' then
                        IssuedRecStatementHeader.setrange("Customer No.", Rec."Customer No.");
                    if Rec."Vendor No." <> '' then
                        IssuedRecStatementHeader.setrange("Vendor No.", Rec."Vendor No.");

                    IssuedDebtReconcilStatement.SetTableView(IssuedRecStatementHeader);
                    IssuedDebtReconcilStatement.run();

                end;
            }
        }
    }

    var
        IssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        IssuedDebtReconcilStatement: Report "EVK Issued Debt Recon. Stat.";
}
