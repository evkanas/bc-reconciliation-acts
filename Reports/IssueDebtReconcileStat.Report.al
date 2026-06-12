report 70123 "EVK IssueDebtReconcileStat"
{
    ProcessingOnly = true;
    Caption = 'Issue Debt Reconcile Statement', Comment = 'lt-LT="Išrašyti skolų suderinimo ataskaitą"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("EVK Reconcil. Statement Header"; "EVK Reconcil. Statement Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'lt-LT="Parinktys"';
                    field(EVKPrintDoc; PrintDoc)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print', Comment = 'lt-LT="Spausdinti"';
                        OptionCaption = ' ,Print,Email', Comment = 'lt-LT=" ,Spausdinti,Siųsti el. paštu"';
                        Enabled = NOT IsOfficeAddin;
                        ToolTip = 'Specifies it you want to print or email the reminders when they are issued.', Comment = 'lt-LT="Nurodo, ar norite spausdinti ar siųsti el. paštu priminimus, kai jie yra išrašomi"';
                    }
                    field(HideEmailDialog; HideDialog)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Hide Email Dialog', Comment = 'lt-LT="Slėpti el. pašto dialogą"';
                        ToolTip = 'Specifies if you want to hide email dialog.', Comment = 'lt-LT="Nurodo, ar norite slėpti el. pašto dialogą"';
                    }
                    field(PrintDtls; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details', Comment = 'lt-LT="Spausdinti išsamią informaciją"';
                        ToolTip = 'Specifies how to print rows.', Comment = 'lt-LT="Nurodo, kaip spausdinti eilutes"';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        ReconsilStatementCU.IssueReconiclationStatement("EVK Reconcil. Statement Header", PrintDoc, HideDialog, PrintDetails);
    end;

    var
        ReconsilStatementCU: Codeunit "EVK ReconsilStatement";
        PrintDoc: Option " ",Print,Email;
        HideDialog: Boolean;
        IsOfficeAddin: Boolean;
        PrintDetails: Boolean;

}
