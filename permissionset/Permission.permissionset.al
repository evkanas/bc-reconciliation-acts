permissionset 70100 "EVK Permission"
{
    Assignable = true;
    Caption = 'Permission', MaxLength = 30, Locked = true;
    Permissions = tabledata "EVK Debt Reconciliation Setup" = RIMD,
        tabledata "EVK Issued Debt Rec. StatLine" = RIMD,
        tabledata "EVK Issued Rec. Stat. Header" = RIMD,
        tabledata "EVK Reconcil. Statement Header" = RIMD,
        tabledata "EVK Reconcil. Statement Line" = RIMD,
        table "EVK Debt Reconciliation Setup" = X,
        table "EVK Issued Debt Rec. StatLine" = X,
        table "EVK Issued Rec. Stat. Header" = X,
        table "EVK Reconcil. Statement Header" = X,
        table "EVK Reconcil. Statement Line" = X,
        report "EVK Issued Debt Recon. Stat." = X,
        report "EVK Debt Reconcile Stat." = X,
        report "EVK DebtReconcilStatCreate" = X,
        report "EVK IssueDebtReconcileStat" = X,
        Codeunit "EVK ReconsilStatement" = X,
        page "EVK Debt Reconciliation Setup" = X,
        page "EVK Issued Reconcil. Statement" = X,
        page "EVK IssuedReconStatementLines" = X,
        page "EVK IssuedReconStatementList" = X,
        page "EVK Reconcil Statement" = X,
        page "EVK Reconcil. Statement Lines" = X,
        page "EVK Reconsil Statement List" = X,
        page "EVK ReportSelectionDebtRecStat" = X,
        page "EVK RSAllObj" = X,
        report "EVK DebtReconcStatementSuggest" = X;
}