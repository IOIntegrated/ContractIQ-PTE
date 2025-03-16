namespace IOI.ContractIQ;

page 70006 "ContractIQ Setting List IOI"
{
    ApplicationArea = All;
    Caption = 'ContractIQ Setting List';
    PageType = List;
    SourceTable = "ContractIQ Settings IOI";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                    DrillDownPageId = "ContractIQ Setting Card IOI";
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Version; Rec."Version")
                {
                    ToolTip = 'Specifies the value of the Version field.', Comment = '%';
                }
                field("ID Range from"; Rec."ID Range from")
                {
                    ToolTip = 'Specifies the value of the ID Range from field.', Comment = '%';
                }
                field("ID Range to"; Rec."ID Range to")
                {
                    ToolTip = 'Specifies the value of the ID Range to field.', Comment = '%';
                }
            }
        }
    }
}
