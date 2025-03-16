namespace IOI.ContractIQ;

page 70005 "Translation List IOI"
{
    ApplicationArea = All;
    Caption = 'Translation List';
    PageType = List;
    SourceTable = "Translation IOI";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.', Comment = '%';
                }
                field(Translation; Rec.Translation)
                {
                    ToolTip = 'Specifies the value of the Translation field.', Comment = '%';
                }
            }
        }
    }
}
