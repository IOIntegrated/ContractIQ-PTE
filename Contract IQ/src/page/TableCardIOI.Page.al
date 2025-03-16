namespace IOI.ContractIQ;

page 70004 "Table Card IOI"
{
    ApplicationArea = All;
    Caption = 'Table Card';
    PageType = Card;
    SourceTable = "Tables IOI";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the name field.', Comment = '%';
                }
                field(DataClassification; Rec."DataClassification")
                {
                    ToolTip = 'Specifies the value of the DataClassification field.', Comment = '%';
                }
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.', Comment = '%';
                    trigger OnAssistEdit()
                    var
                        Translations: record "Translation IOI";
                    begin
                        Rec.Caption := Translations.AssitEdit(Rec.Caption, Rec."No.", 0, Rec.SystemId);
                    end;
                }
            }
            // Add the ListPart here
            part(FieldListPartIOI; "Field ListPart IOI")
            {
                ApplicationArea = All;
                SubPageLink = "Table No." = field("No."), ID = field(ID), Usage = field(Usage);
            }
        }
    }
}