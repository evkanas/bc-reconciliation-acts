page 70122 "EVK Reconcil. Statement Lines"
{
    PageType = ListPart;
    SourceTable = "EVK Reconcil. Statement Line";
    UsageCategory = None;
    Caption = 'Reconcilation Statement Lines', Comment = 'lt-LT="Suderinimo akto eilutės"';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendras"';
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Document Type.', Comment = 'lt-LT="Nurodo dokumento tipą"';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Document No..', Comment = 'lt-LT="Nurodo dokumento numerį"';

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Document Date.', Comment = 'lt-LT="Nurodo dokumento datą"';

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Currency Code.', Comment = 'lt-LT="Nurodo valiutos kodą"';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Amount.', Comment = 'lt-LT="Nurodo sumą"';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Amount (LCY).', Comment = 'lt-LT="Nurodo sumą (LCY)"';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Remaining Amt. (LCY).', Comment = 'lt-LT="Nurodo likusią sumą (LCY)"';
                }
                field("Debit (LCY)"; Rec."Debit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Debit (LCY).', Comment = 'lt-LT="Nurodo debetą (LCY)"';
                }
                field("Credit (LCY)"; Rec."Credit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Credit (LCY).', Comment = 'lt-LT="Nurodo kreditą (LCY)"';
                }
            }
        }
    }
}
