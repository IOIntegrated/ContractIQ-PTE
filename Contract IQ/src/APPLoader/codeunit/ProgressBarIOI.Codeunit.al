namespace IOI.ContractIQ;

codeunit 70012 "Progressbar IOI"
{
    SingleInstance = true;

    var
        ProgressDialog: Dialog;
        IsOpen: Boolean;
        PlaceholderLabel: Text;
        Label1Text: Text;
        Label2Text: Text;
        Label3Text: Text;

    procedure ProgressbarInit();
    var
        ProcessingLbl: Label '#3###################\#1###################\#2###################';
    begin
        if not IsOpen then begin
            this.ProgressDialog.OPEN(ProcessingLbl);
            this.PlaceholderLabel := ProcessingLbl;
            this.IsOpen := true;
        end;
    end;

    procedure ProgressbarUpdate(Section: Integer; MessageText: Text);
    begin
        if this.IsOpen then begin
            this.ProgressDialog.UPDATE(Section, MessageText);
            case Section of
                1:
                    this.Label1Text := MessageText;
                2:
                    this.Label2Text := MessageText;
                3:
                    this.Label3Text := MessageText;
            end;
        end else begin
            this.ProgressbarInit();
            this.ProgressbarUpdate(1, Label1Text);
            this.ProgressbarUpdate(2, Label2Text);
            this.ProgressbarUpdate(3, Label3Text);
            this.IsOpen := true;
        end;
    end;

    procedure ProgressbarClose();
    begin
        if this.IsOpen then begin
            ProgressDialog.CLOSE();
            this.IsOpen := false;
        end;
    end;
}
