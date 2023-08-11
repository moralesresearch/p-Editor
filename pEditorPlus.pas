{$mode objfpc}{$H+}{$J-}

program PascalEditor;

uses
  Crt, SysUtils, StrUtils, Classes;

const
  ProgramName = 'p-Editor';
  Version = '1.0';
  Copyright = '© 2023 Morales Research Inc';
  DictionaryFileName = 'dictionary.txt';

type
  TTextStyles = (Normal, Heading, Subtitle, Title, Bold, Italics);

var
  FileName: string;
  FileText: TStringList;
  CursorX, CursorY: Integer;
  Command: char;
  Dictionary: TStringList;
  ScrollOffset: Integer;
  RulerVisible: Boolean = True;

procedure SetTextColor(Color: Byte);
begin
  TextColor(Color);
end;

function LoadDictionary(FileName: string): TStringList;
begin
  Result := TStringList.Create;
  try
    Result.LoadFromFile(FileName);
  except
    on E: Exception do
      writeln('Error loading dictionary: ', E.Message);
  end;
end;

procedure SaveDictionary(FileName: string; Dictionary: TStringList);
begin
  try
    Dictionary.SaveToFile(FileName);
    writeln('Dictionary updated and saved.');
  except
    on E: Exception do
      writeln('Error saving dictionary: ', E.Message);
  end;
end;

function IsWordInDictionary(Word: string): Boolean;
begin
  Result := Dictionary.IndexOf(Word) >= 0;
end;

procedure DisplayInformation;
begin
  SetTextColor(LightCyan);
  WriteLn(ProgramName, ' ', Version);
  SetTextColor(LightGray);
  WriteLn(Copyright);
end;

procedure DisplayRuler;
var
  i: Integer;
begin
  SetTextColor(LightGray);
  write('1');
  for i := 1 to WindowWidth - 1 do
    write('0');
  writeln;
end;

procedure DisplayFileContents;
var
  Line: string;
  i: Integer;
  LineNumber: Integer;
  DisplayedLines: Integer;
begin
  ClrScr;
  GotoXY(1, 1);
  LineNumber := ScrollOffset + 1;
  DisplayedLines := 0;

  if RulerVisible then
  begin
    DisplayRuler;
    Inc(DisplayedLines);
  end;

  for i := ScrollOffset to FileText.Count - 1 do
  begin
    if DisplayedLines >= WindowHeight then
      Break;

    Line := FileText[i];
    if Pos('# ', Line) = 1 then
    begin
      // Heading style
      SetTextColor(LightCyan);
      writeln(Copy(Line, 3, MaxInt));
    end
    else if Pos('## ', Line) = 1 then
    begin
      // Subtitle style
      SetTextColor(Yellow);
      writeln(Copy(Line, 4, MaxInt));
    end
    else if Pos('### ', Line) = 1 then
    begin
      // Title style
      SetTextColor(Yellow);
      writeln(Copy(Line, 5, MaxInt));
    end
    else if Pos('* ', Line) = 1 then
    begin
      // Bold style
      SetTextColor(LightGray + Blink);
      writeln(Copy(Line, 3, MaxInt));
    end
    else if Pos('_ ', Line) = 1 then
    begin
      // Italics style
      SetTextColor(LightGray);
      writeln(Copy(Line, 3, MaxInt));
    end
    else
      writeln(LineNumber, ': ', Line);

    Inc(LineNumber);
    Inc(DisplayedLines);
  end;

  GotoXY(CursorX, CursorY - ScrollOffset);
end;

function AskToAddToDictionary(Word: string): Boolean;
var
  Response: char;
begin
  writeln('The word "', Word, '" is not in the dictionary.');
  write('Do you want to add it to the dictionary? (Y/N): ');
  readln(Response);
  Result := UpCase(Response) = 'Y';
end;

procedure InsertTextAtCursor(Text: string);
var
  Line: string;
  Words: TStringList;
  i: Integer;
begin
  Words := TStringList.Create;
  try
    Line := FileText[CursorY - 1];
    Insert(Text, Line, CursorX);

    // Split the line into words
    ExtractStrings([' ', ',', '.', ';', ':', '!', '?'], [], PChar(Line), Words);

    // Check each word for spelling
    for i := 0 to Words.Count - 1 do
    begin
      if not IsWordInDictionary(Words[i]) then
      begin
        if AskToAddToDictionary(Words[i]) then
        begin
          Dictionary.Add(Words[i]);
          SaveDictionary(DictionaryFileName, Dictionary);
        end;
      end;
    end;

    FileText[CursorY - 1] := Line;
    Inc(CursorX, Length(Text));
  finally
    Words.Free;
  end;
end;

procedure ApplyStyleToLine(var LineToStyle: string; Style: TTextStyles);
begin
  case Style of
    Heading: LineToStyle := '# ' + LineToStyle;
    Subtitle: LineToStyle := '## ' + LineToStyle;
    Title: LineToStyle := '### ' + LineToStyle;
    Bold: LineToStyle := '* ' + LineToStyle;
    Italics: LineToStyle := '_ ' + LineToStyle;
  end;
end;

procedure InsertStyledTextAtCursor(Text: string; Style: TTextStyles);
var
  Line: string;
begin
  Line := Text;

  if Style <> Normal then
    ApplyStyleToLine(Line, Style);

  InsertTextAtCursor(Line);
end;

procedure MoveCursorLeft;
begin
  if CursorX > 1 then
    Dec(CursorX);
end;

procedure MoveCursorRight;
var
  MaxX: Integer;
begin
  MaxX := Length(FileText[CursorY - 1]) + 1;
  if CursorX < MaxX then
    Inc(CursorX);
end;

procedure MoveCursorUp;
begin
  if CursorY > 1 then
  begin
    Dec(CursorY);
    CursorX := 1;
    if CursorY < ScrollOffset + 1 then
      Dec(ScrollOffset);
  end;
end;

procedure MoveCursorDown;
var
  MaxY: Integer;
begin
  MaxY := FileText.Count;
  if CursorY < MaxY then
  begin
    Inc(CursorY);
    CursorX := 1;
    if CursorY > ScrollOffset + WindowHeight then
      Inc(ScrollOffset);
  end;
end;

procedure DeleteCharAtCursor;
var
  Line: string;
begin
  if CursorX > 1 then
  begin
    Line := FileText[CursorY - 1];
    Delete(Line, CursorX, 1);
    FileText[CursorY - 1] := Line;
    MoveCursorLeft;
  end;
end;

procedure ToggleRuler;
begin
  RulerVisible := not RulerVisible;
end;

procedure CreateDictionaryFile;
begin
  writeln('The dictionary file ("', DictionaryFileName, '") is missing.');
  write('Do you want to generate a new empty dictionary file? (Y/N): ');
  if UpCase(ReadKey) = 'Y' then
  begin
    Dictionary := TStringList.Create;
    SaveDictionary(DictionaryFileName, Dictionary);
    writeln('Empty dictionary file ("', DictionaryFileName, '") generated.');
  end
  else
    writeln('Bypassing dictionary requirement.');
end;

procedure CreateNewFile;
begin
  writeln('Creating a new empty file.');
  FileText.Clear;
  FileText.Add('');
  CursorX := 1;
  CursorY := 1;
  ScrollOffset := 0;
end;

procedure OpenFile;
var
  NewFileName: string;
begin
  writeln('Enter the name of the file to open (leave empty to cancel):');
  write('> ');
  readln(NewFileName);
  if NewFileName <> '' then
  begin
    try
      FileText.LoadFromFile(NewFileName);
      FileName := NewFileName;
      CursorX := 1;
      CursorY := 1;
      ScrollOffset := 0;
    except
      on E: Exception do
        writeln('Error opening file: ', E.Message);
    end;
  end;
end;

procedure SaveFile;
begin
  if FileName <> '' then
  begin
    try
      FileText.SaveToFile(FileName);
      writeln('File saved: ', FileName);
    except
      on E: Exception do
        writeln('Error saving file: ', E.Message);
    end;
  end
  else
    writeln('No file is currently open. Use "Save As" to specify a new file.');
end;

procedure SaveFileAs;
var
  NewFileName: string;
begin
  writeln('Enter the name of the file to save as:');
  write('> ');
  readln(NewFileName);
  if NewFileName <> '' then
  begin
    try
      FileText.SaveToFile(NewFileName);
      writeln('File saved as: ', NewFileName);
      FileName := NewFileName;
    except
      on E: Exception do
        writeln('Error saving file: ', E.Message);
    end;
  end;
end;

procedure PerformSpellCheck;
var
  Line: string;
  Words: TStringList;
  i: Integer;
begin
  writeln('Performing spell check...');
  Words := TStringList.Create;
  try
    for Line in FileText do
    begin
      // Split the line into words
      ExtractStrings([' ', ',', '.', ';', ':', '!', '?'], [], PChar(Line), Words);

      // Check each word for spelling
      for i := 0 to Words.Count - 1 do
      begin
        if not IsWordInDictionary(Words[i]) then
          writeln('Spelling error: "', Words[i], '" on line ', FileText.IndexOf(Line) + 1);
      end;
    end;
  finally
    Words.Free;
  end;
  writeln('Spell check completed.');
end;

begin
  // Load the dictionary
  Dictionary := LoadDictionary(DictionaryFileName);

  if Dictionary.Count = 0 then
    CreateDictionaryFile;

  FileText := TStringList.Create;
  DisplayInformation;

  writeln('Commands:');
  writeln('  N - New File');
  writeln('  O - Open File');
  writeln('  S - Save File');
  writeln('  A - Save File As');
  writeln('  Q - Quit');
  writeln('  Arrow keys - Move cursor');
  writeln('  I - Insert text at cursor');
  writeln('  DEL - Delete character at cursor');
  writeln('  B - Bold style');
  writeln('  I - Italics style');
  writeln('  T - Title style');
  writeln('  S - Subtitle style');
  writeln('  H - Heading style');
  writeln('  C - Perform Spell Check');
  writeln('  R - Toggle Ruler');
  writeln('');

  Command := #0;
  CreateNewFile;

  while Command <> 'Q' do
  begin
    DisplayFileContents;
    Command := UpCase(ReadKey);
    case Command of
      'N': CreateNewFile;
      'O': OpenFile;
      'S': SaveFile;
      'A': SaveFileAs;
      'C': PerformSpellCheck;
      'R': ToggleRuler;
      #72: MoveCursorUp;    // Up arrow
      #80: MoveCursorDown;  // Down arrow
      #75: MoveCursorLeft;  // Left arrow
      #77: MoveCursorRight; // Right arrow
      'I': InsertTextAtCursor('Hello, world!');
      #8: DeleteCharAtCursor;  // DEL key
      'B': InsertStyledTextAtCursor('Bold text', Bold);
      'T': InsertStyledTextAtCursor('Title', Title);
     // 'S': InsertStyledTextAtCursor('Subtitle', Subtitle);
     // 'H': InsertStyledTextAtCursor('Heading', Heading);
    end;
  end;

  writeln('Goodbye!');
end.
