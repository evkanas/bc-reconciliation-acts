tableextension 70178 "EVK Vendor" extends Vendor
{
    fields
    {
        field(70151; "EVK DEBTBALANCE"; Decimal)
        {
            Caption = 'Balance at Date', Comment = 'lt-LT="Likutis datą"';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD("EVK DEBDATEFILTER")));
        }
        field(70152; "EVK DEBDATEFILTER"; Date)
        {
            Caption = 'Date FILTER (Debt. Reconc.)', Comment = 'lt-LT="Data FILTRAS (Skolų suderinimas)"';
            FieldClass = FlowFilter;
        }

    }
}
