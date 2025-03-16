namespace IOI.ContractIQ;

page 70002 "Table List IOI"
{
    ApplicationArea = All;
    Caption = 'Table List';
    PageType = List;
    SourceTable = "Tables IOI";

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
                field(Usage; Rec.Usage)
                {
                    ToolTip = 'Specifies the value of the Usage field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewCard)
            {
                Caption = 'View Card';
                ToolTip = 'View the details of the selected record.';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"Table Card IOI", Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        // CaptionLbl: A label control that displays a caption for the list.
        // The '%1' placeholder in the label text will be replaced with the name of the list.
#pragma warning disable AA0470
        CaptionLbl: Label '%1 List';
#pragma warning restore AA0470
    begin
        this.Caption := StrSubstNo(CaptionLbl, Rec.Usage);
    end;
}