﻿program game2;
{$APPTYPE CONSOLE}
uses SysUtils;
const N_MAX = 101;
type TMas = array[1..N_MAX] of string;
     IMas = array[1..3] of integer;
var game: boolean;
    i: integer;
    word: string;
    show: string;
    definition: string;
    len_word: integer;
    turn: boolean;
    player: integer;
    ball: integer;
    score: IMas;
procedure input(var word: string;
                var definition: string;
                var len_word: integer);
var mass: TMas;
    f: TextFile;
    amount: integer;
    r: integer;
    pos: integer;
    i: integer;
begin
randomize;
amount := 0;
AssignFile(f, 'input.txt');
Reset(f);
while (not EOF(f)) do
    begin
    Inc(amount);
    Readln(f, mass[amount]);
    mass[amount]:= UTF8ToAnsi(mass[amount]);
    end;
CloseFile(f);
r := random(amount) + 1;
i := 1;
while mass[r, i] <> ':' do Inc(i);
len_word := length(mass[r]) - i;
word := AnsiUpperCase(copy(mass[r], i+1, len_word));
definition := copy(mass[r], 1, i - 1);
end;

procedure sektorplus(var word: string;
                     var show: string);
var k: integer;
    number: integer;
    letter: char;
    position: integer;
    flag: boolean;
begin
writeln('Выберите номер буквы  ');
flag := true;
while flag do
    begin
    flag := false;
    try
        readln(number);
    except
        begin
        writeln('Повторите попытку');
        writeln('Выберите номер буквы(число)');
        flag := true;
        end;
    end;
    if not flag then
        begin
        if (number <= 0) or (number > len_word) then
            begin
            flag := true;
            writeln('Вы ввели неправильное число, попробуйте сново');
            writeln('Выберите номер буквы в слове (1 - ', len_word,')');
            end
        else if show[number] <> '_' then
            begin
            flag := true;
            writeln('Повторите попытку');
            writeln('Введите номер закрытой буквы');
            end;
        end;
    end;
letter := word[number];
position := pos(letter, word);
k := 0;
while position > 0 do
    begin
    Inc(k);
    show[position] := letter;
    word[position] := '-';
    position := pos(letter, word);
    end;
end;

procedure rotation(var ball: integer);
var chance: integer;

begin
randomize;
chance := random(11);
if chance <= 8 then
    begin
    ball := random(21)*10 + 100;
    end
else if chance = 9 then
    begin
    ball := -1;
    end
else ball := 0;
end;


procedure search(var check: string;
                 var word: string;
                 var score: IMas;
                 var player: integer);
var k: integer;
    letter: char;
    position: integer;

begin
readln(letter);
letter := Ansiuppercase(letter)[1];
position := pos(letter, word);
k := 0;
if position > 0 then
    begin
    while position > 0 do
        begin
        Inc(k);
        check[position] := letter;
        word[position] := '-';
        position := pos(letter, word);
        end;
    score[player] := score[player] + k * ball;
    player := player - 1;                //повтор хода
    end
else
    begin
    writeln('Нет такой буквы');
    end;
end;

begin
input(word, definition, len_word);
for i := 1 to 3 do score[i] := 0;
for i := 1 to len_word do
    begin
    if word[i] = '-' then show := show + '-'
    else
        begin
        show := show + '_';
        end;
    end;
writeln('Начнём игру');
game := True;
while game do
    begin
    for player := 1 to 3 do
        begin
        writeln;
        write(definition, ': ');
        for i := 1 to len_word do write(show[i], ' ');
        writeln;
        writeln('Баланс игроков:      1 игрок     2 игрок     3 игрок');
        writeln('             ',score[1]:12,score[2]:12,score[3]:12);
        writeln;
        writeln('Ход игрока ', player);
        write('НА БАРАБАНЕ');
        rotation(ball);
        if ball = 0 then
            begin
            writeln('Переход хода':20);
            end
        else if ball = -1 then
            begin
            writeln('Сектор +':10);
            sektorplus(word, show);
            end
        else
            begin
            writeln(ball:10, ' ОЧКОВ');
            //write('БУКВА...   ');
            writeln('██████  ██    ██ ██   ██ ██████   █████ ');
            writeln('██       ██  ██  ██  ██  ██   ██ ██   ██');
            writeln('██████    ████   █████   ██████  ███████');
            writeln('██   ██    ██    ██  ██  ██   ██ ██   ██');
            writeln('██████    ██     ██   ██ ██████  ██   ██');
            search(show, word, score, player);
            end;
        end;
    end;
end.