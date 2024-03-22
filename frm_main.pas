unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DateUtils, Math;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnLBYL: TButton;
    btnEAFP: TButton;
    txtNumTest: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    procedure btnEAFPClick(Sender: TObject);
    procedure btnLBYLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    function singleTest(const testType: integer): double;
    procedure mainTest(const testType: integer);

  public

  end;

var
  FormMain: TFormMain;

implementation

const
  TEST_LBYL = 1; // Look Before You Leap
  TEST_EAFP = 2; // Easier to Ask for Forgiveness than Permission

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]); // necessary to have manage exception on division by zero
end;

procedure TFormMain.btnLBYLClick(Sender: TObject);
begin
  mainTest(TEST_LBYL);
end;

procedure TFormMain.btnEAFPClick(Sender: TObject);
begin
  mainTest(TEST_EAFP);
end;

function TFormMain.singleTest(const testType: integer): double;
const MAX_ITER = 20000;
var
  i, j: integer;
  x, y, z, res: double;
  dt1, dt2: TDateTime;
begin

  x := 1.1;
  y := 0;
  res := 0;

  dt1 := Date() + Time();
  for i := 0 to MAX_ITER - 1 do begin
    for j := 0 to MAX_ITER - 1 do begin

      if testType = TEST_LBYL then begin

         if y = 0 then begin
           res := res + 1;
         end else begin
           res := res + (x / y);
         end;

      end else begin

        try
          z := (x / y);
          res := res + z;
        except
          res := res + 1;
        end;

      end;

    end;

  end;

  dt2 := Date() + Time();
  Result := MilliSecondSpan(dt2, dt1);
end;

procedure TFormMain.mainTest(const testType: integer);
var
  timeDiff: double;
  i, iterMax: integer;
begin
  iterMax := StrToInt(txtNumTest.Text);

  Screen.Cursor := crHourGlass;

  timeDiff := 0;
  for i := 0 to iterMax - 1 do begin
    timeDiff := timeDiff + singleTest(TEST_LBYL);
  end;

  Screen.Cursor := crDefault;

  if testType = TEST_LBYL then begin
    Memo1.Append('----- LBYL - Look Before You Leap');
  end else begin
    Memo1.Append('----- EAFP - Easier to Ask for Forgiveness than Permission');
  end;

  Memo1.Append(Format('Total time: %f s', [timeDiff / 1000]));
  Memo1.Append(Format('Avg. time: %f ms', [timeDiff / iterMax]));
end;

end.

