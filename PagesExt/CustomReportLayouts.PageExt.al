pageextension 70151 "EVK Custom Report Layouts" extends "Custom Report Layouts"
{
    layout
    {
        addafter(Type)
        {
            field("EVK Language Code"; Rec."EVK Language Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies template lanugage.', Comment = 'lt-LT="Nurodo šablono kalbą"';
            }
        }
    }
}
