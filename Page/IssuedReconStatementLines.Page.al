page 70120 "EVK IssuedReconStatementLines"
{
    PageType = ListPart;
    SourceTable = "EVK Issued Debt Rec. StatLine";
    UsageCategory = None;
    Caption = 'Issued Reconcilation Statement Lines', Comment = 'lt-LT="Išrašyto suderinimo akto eilutės"';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendri parametrai"';
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
