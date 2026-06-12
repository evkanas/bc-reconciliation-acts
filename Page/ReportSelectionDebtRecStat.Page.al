page 70125 "EVK ReportSelectionDebtRecStat"
{
    ApplicationArea = Suite;
    Caption = 'Report Selection - Debt Reconcilation Statement', Comment = 'lt-LT="Ataskaitos pasirinkimas - skolų suderinimo aktas"';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                ApplicationArea = Suite;
                Caption = 'Usage', Comment = 'lt-LT="Naudojimas"';
                OptionCaption = 'Debt Reconciliation Statement', Comment = 'lt-LT="Skolų suderinimo aktas"';
                ToolTip = 'Specifies which type of document the report is used for.', Comment = 'lt-LT="Nurodo, kokio tipo dokumentui naudojama ataskaita"';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.', Comment = 'lt-LT="Nurodo skaičių, kuris nurodo, kur ši ataskaita yra spausdinimo tvarkoje"';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the object ID of the report.', Comment = 'lt-LT="Nurodo ataskaitos objekto ID"';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the display name of the report.', Comment = 'lt-LT="Nurodo ataskaitos rodymo pavadinimą"';
                }
                field("Use for Email Body"; Rec."Use for Email Body")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to insert summarized information, such as invoice number, due date in the body of the email that you send.', Comment = 'lt-LT="Nurodo, ar įterpti suvestines informacijos, tokios kaip sąskaitos faktūros numeris, terminas el. laiške, kurį siunčiate"';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to attach the related document to the email.', Comment = 'lt-LT="Nurodo, ar prisegtį susijusį dokumentą prie el. laiško"';
                }
                field("Email Body Layout Code"; Rec."Email Body Layout Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the email body layout that is used.', Comment = 'lt-LT="Nurodo el. laiško kūno išdėstymo ID, kuris naudojamas"';
                    Visible = false;
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the email body layout that is used.', Comment = 'lt-LT="Nurodo el. laiško kūno išdėstymo aprašymą"';

                    trigger OnDrillDown()
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
                            Rec.Validate("Email Body Layout Code", CustomReportLayout.Code);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord();
    end;

    trigger OnOpenPage()
    begin
        InitUsageFilter();
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option "Debt Reconciliation Statement";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
            if Rec.Modify() then;
        Rec.FilterGroup(2);
        case ReportUsage2 of
            ReportUsage2::"Debt Reconciliation Statement":
                Rec.SetRange(Usage, Rec.Usage::"EVK DEBTRECONCILATIONSTATEMENT");
        end;
        Rec.FilterGroup(0);
        CurrPage.Update();
    end;

    local procedure InitUsageFilter()
    var
        DummyReportSelections: Record "Report Selections";
    begin
        if Rec.GetFilter(Usage) <> '' then begin
            if Evaluate(DummyReportSelections.Usage, Rec.GetFilter(Usage)) then
                case DummyReportSelections.Usage of
                    Rec.Usage::Reminder:
                        ReportUsage2 := ReportUsage2::"Debt Reconciliation Statement";
                end;
            Rec.SetRange(Usage);
        end;
    end;
}
