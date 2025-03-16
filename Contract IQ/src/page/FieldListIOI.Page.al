namespace IOI.ContractIQ;

page 70001 "Field List IOI"
{
    ApplicationArea = All;
    Caption = 'Field List';
    PageType = List;
    SourceTable = "Fields IOI";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the PK field.', Comment = '%';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the App Fields Type field.', Comment = '%';
                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the value of the Length field.', Comment = '%';
                }
                field(IsPk; Rec.IsPk)
                {
                    ToolTip = 'Specifies the value of the PK field.', Comment = '%';
                }
                field(DataClassification; Rec."DataClassification")
                {
                    ToolTip = 'Specifies the value of the DataClassification field.', Comment = '%';
                }
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the caption field.', Comment = '%';
                    trigger OnAssistEdit()
                    var
                        Translations: record "Translation IOI";
                    begin
                        Rec.Caption := Translations.AssitEdit(Rec.Caption, Rec."Table No.", Rec."No.", Rec.SystemId);
                    end;
                }
            }
        }
    }
}
