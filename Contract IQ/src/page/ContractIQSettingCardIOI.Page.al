namespace IOI.ContractIQ;

page 70007 "ContractIQ Setting Card IOI"
{
    ApplicationArea = All;
    Caption = 'ContractIQ Setting Card';
    PageType = Card;
    SourceTable = "ContractIQ Settings IOI";
    DataCaptionFields = Name, Version;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Publisher; Rec.Publisher)
                {
                    ToolTip = 'Specifies the value of the Publisher field.', Comment = '%';
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';

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
                field("Input Type"; Rec."Input Type")
                {
                    ToolTip = 'Specifies the value of the Input Type field.', Comment = '%';
                }
            }
            group(Publishing)
            {
                Caption = 'Publishing';
                field(Brief; Rec.Brief)
                {
                    ToolTip = 'Specifies the value of the Brief field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(EULA; Rec.EULA)
                {
                    ToolTip = 'Specifies the value of the EULA field.', Comment = '%';
                }
                field(Website; Rec.Website)
                {
                    ToolTip = 'Specifies the value of the Website field.', Comment = '%';
                }
                field("Help URL"; Rec."Help URL")
                {
                    ToolTip = 'Specifies the value of the Help URL field.', Comment = '%';
                }
                field("Privacy Statement"; Rec."Privacy Statement")
                {
                    ToolTip = 'Specifies the value of the Privacy Statement field.', Comment = '%';
                }
            }
        }
    }
}
