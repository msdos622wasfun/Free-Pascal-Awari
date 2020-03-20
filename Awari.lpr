program Awari;

{$mode objfpc}{$H+}

uses
    Crt, Classes;

{$R *.res}

var
   KEY_ENTER : char;
   KEY_ESC : char;
   KEY_H : char;
   KEY_T : char;
   APOSTROPHE : char;
   PLAYER_USER : byte;
   PLAYER_COMPUTER : byte;
   WINNER_NONE : byte;
   WINNER_USER : byte;
   WINNER_COMPUTER : byte;
   WINNER_TIE : byte;
   pits : byte;
   beans : byte;
   pit_array : array[1..20] of byte;
   home_user : byte;
   home_computer : byte;
   current_player : byte;
   winner : byte;
   quit_early : byte;

procedure clear;
var
   row : byte;
begin
     for row := 11 to 25 do
     begin
       gotoxy(1, row);
       ClrEol;
     end;
end;

procedure press_enter;
var
   key_press : char;
begin
     repeat
       key_press := ReadKey;
     until key_press = KEY_ENTER;
end;

procedure coin_toss;
var
   coin : string;
   row : byte;
   key_press : char;
begin
     gotoxy(7, 18);
     write('We will now perform a coin toss.  Press H for heads or T for tails.');
     repeat
       key_press := UpCase(ReadKey);
     until (key_press = KEY_H) or (key_press = KEY_T);
     clear;
     if random > 0.5 then coin := 'TAILS' else coin := 'HEADS';
     for row := 24 downto 12 do
     begin
          if coin = 'HEADS' then coin := 'TAILS' else coin := 'HEADS';
          gotoxy(38, row);
          write(coin);
          Delay(200);
          gotoxy(38, row);
          write('     ');
     end;
     for row := 13 to 24 do
     begin
          if coin = 'HEADS' then coin := 'TAILS' else coin := 'HEADS';
          gotoxy(38, row);
          write(coin);
          Delay(200);
          if row <> 24 then
          begin
               gotoxy(38, row);
               write('     ');
          end;
     end;
     if key_press = coin[1] then
     begin
          gotoxy(20, 18);
          write('You move first.  Press Enter to begin.');
          current_player := PLAYER_USER;
     end
     else
     begin
          gotoxy(17, 18);
          write('Computer moves first.  Press Enter to begin.');
          current_player := PLAYER_COMPUTER;
     end;
     press_enter;
     clear;
end;

procedure draw_pits;
var
   pit : byte;
   left_col : byte;
begin
     left_col := 21 - (2 * (pits - 6));
     textbackground(Green);
     for pit := 1 to home_user - 1 do
     begin
          gotoxy(left_col + (5 * pit), 18);
          write('    ');
          gotoxy(left_col + (5 * pit), 19);
          write('    ');
          gotoxy(left_col + (5 * pit), 20);
          write('    ');
          gotoxy(left_col + (5 * pit) + 1, 19);
          write(pit_array[pit]);
     end;
     gotoxy(left_col + (5 * home_user), 16);
     write('    ');
     gotoxy(left_col + (5 * home_user), 17);
     write('    ');
     gotoxy(left_col + (5 * home_user), 18);
     write('    ');
     gotoxy(left_col + (5 * home_user) + 1, 17);
     textcolor(Yellow);
     write(pit_array[home_user]);
     textbackground(Red);
     textcolor(White);
     for pit := home_computer - 1 downto home_user + 1 do
     begin
          gotoxy(left_col + (5 * (home_computer - pit)), 14);
          write('    ');
          gotoxy(left_col + (5 * (home_computer - pit)), 15);
          write('    ');
          gotoxy(left_col + (5 * (home_computer - pit)), 16);
          write('    ');
          gotoxy(left_col + (5 * (home_computer - pit)) + 1, 15);
          write(pit_array[pit]);
     end;
     gotoxy(left_col, 16);
     write('    ');
     gotoxy(left_col, 17);
     write('    ');
     gotoxy(left_col, 18);
     write('    ');
     gotoxy(left_col + 1, 17);
     textcolor(Yellow);
     write(pit_array[home_computer]);
     textbackground(Blue);
     textcolor(White);
     for pit := 1 to pits do
     begin
          gotoxy(left_col + (5 * pit) + 1, 21);
          write('#', pit);
          gotoxy(left_col + (5 * ((pits + 1) - pit)) + 1, 13);
          write('#', pit);
     end;
end;

procedure draw_main_screen;
begin
     textbackground(Blue);
     ClrScr;
     textcolor(Yellow);
     gotoxy(6, 2);
     write('      *       *           *       *       ************  *************');
     gotoxy(6, 3);
     write('     * *      *           *      * *      *           *       *');
     gotoxy(6, 4);
     write('    *   *     *           *     *   *     *           *       *');
     gotoxy(6, 5);
     write('   *******    *     *     *    *******    ************        *');
     gotoxy(6, 6);
     write('  *       *   *     *     *   *       *   *         *         *');
     gotoxy(6, 7);
     write(' *         *  *     *     *  *         *  *          *        *');
     gotoxy(6, 8);
     write('*           *  ***** *****  *           * *           * *************');
     textcolor(LightCyan);
     gotoxy(6, 10);
     write('< Free Pascal Awari v1.01 >-----------< Copyleft 2020 by Erich Kohl >');
end;

procedure game_setup;
var
   pit : byte;
   key_press : char;
begin
     beans := 0;
     pits := 0;
     clear;
     gotoxy(15, 14);
     write('Type a number from 3 to 6 for the number of beans: ');
     repeat
       key_press := ReadKey;
       if key_press in ['3'..'6'] then beans := Ord(key_press) - 48;
     until beans >= 3;
     write(beans);
     gotoxy(15, 18);
     write('Type a number from 6 to 9 for the number of pits: ');
     repeat
       key_press := ReadKey;
       if key_press in ['6'..'9'] then pits := Ord(key_press) - 48;
     until pits >= 6;
     write(pits);
     home_user := pits + 1;
     home_computer := home_user + pits + 1;
     for pit := 1 to home_computer - 1 do
     begin
          pit_array[pit] := beans;
     end;
     pit_array[home_user] := 0;
     pit_array[home_computer] := 0;
     gotoxy(29, 22);
     write('Press Enter to continue.');
     press_enter;
end;

procedure init;
begin
     KEY_ENTER := Char(13);
     KEY_ESC := Char(27);
     KEY_H := 'H';
     KEY_T := 'T';
     APOSTROPHE := Char(39);
     PLAYER_USER := 1;
     PLAYER_COMPUTER := 2;
     WINNER_NONE := 0;
     WINNER_USER := 1;
     WINNER_COMPUTER := 2;
     WINNER_TIE := 3;
end;

procedure make_move(simulate : byte; pit_start : byte; var pit_end : byte; var points : byte);
var
   beans_to_sow : byte;
   next_pit : byte;
   pit_opposite : byte;
   beans_original_user : byte;
   beans_original_computer : byte;
   pit_array_temp : array[1..20] of byte;
   a : byte;
begin
     { This routine assumes the move is legal, that there are beans in the chosen pit. }
     if simulate = 1 then
     begin
          for a := 1 to 20 do
          begin
               pit_array_temp[a] := pit_array[a];
          end;
     end;
     beans_to_sow := pit_array[pit_start];
     next_pit := pit_start + 1;
     beans_original_user := pit_array[home_user];
     beans_original_computer := pit_array[home_computer];
     pit_array[pit_start] := 0;
     repeat
       if next_pit = home_computer + 1 then next_pit := 1;
       pit_array[next_pit] := pit_array[next_pit] + 1;
       beans_to_sow := beans_to_sow - 1;
       next_pit := next_pit + 1;
     until beans_to_sow = 0;
     pit_end := next_pit - 1;
     if pit_end = 0 then pit_end := home_computer;
     if (pit_end <> home_user) and (pit_end <> home_computer) then
     begin
       if pit_array[pit_end] = 1 then
       begin
         pit_opposite := home_computer - pit_end;
         if pit_start < home_user then
         begin
           pit_array[home_user] := pit_array[home_user] + pit_array[pit_end] + pit_array[pit_opposite];
         end
         else
         begin
              pit_array[home_computer] := pit_array[home_computer] + pit_array[pit_end] + pit_array[pit_opposite];
         end;
         pit_array[pit_end] := 0;
         pit_array[pit_opposite] := 0;
       end;
     end;
     points := 0;
     if pit_start < home_user then
     begin
       points := pit_array[home_user] - beans_original_user;
     end
     else
     begin
          points := pit_array[home_computer] - beans_original_computer;
     end;
     if simulate = 1 then
     begin
       for a := 1 to 20 do
       begin
            pit_array[a] := pit_array_temp[a];
       end;
     end;
end;

procedure check_for_winner;
var
   empty : byte;
   pit : byte;
begin
     winner := WINNER_NONE;
     empty := 1;
     for pit := 1 to home_user - 1 do
     begin
          if pit_array[pit] <> 0 then empty := 0;
     end;
     if empty = 0 then
     begin
       empty := 1;
       for pit := home_user + 1 to home_computer - 1 do
       begin
            if pit_array[pit] <> 0 then empty := 0;
       end;
     end;
     if empty = 1 then
     begin
       if pit_array[home_user] > pit_array[home_computer] then winner := WINNER_USER;
       if pit_array[home_computer] > pit_array[home_user] then winner := WINNER_COMPUTER;
       if pit_array[home_user] = pit_array[home_computer] then winner := WINNER_TIE;
     end;
end;

procedure turn_computer;
var
   point_values : array[1..9] of byte;
   highest : byte;
   move : byte;
   pit_end : byte = 0;
   points : byte = 0;
   a : byte;
begin
     repeat
       gotoxy(32, 24);
       write('Computer', APOSTROPHE, 's turn: ');
       Delay(1500);
       for a := 1 to 9 do
       begin
            point_values[a] := 0;
       end;
       highest := 0;
       for a := home_user + 1 to home_computer - 1 do
       begin
            if pit_array[a] <> 0 then
            begin
                 make_move(1, a, pit_end, points);
                 point_values[a - home_user] := points;
                 if points > highest then highest := points;
            end;
       end;
       repeat
         move := random(pits) + 1;
       until (point_values[move] = highest) and (pit_array[move + home_user] <> 0);
       move := move + home_user;
       write(move - home_user);
       Delay(1500);
       make_move(0, move, pit_end, points);
       draw_pits;
       gotoxy(1, 24);
       ClrEol;
       Delay(1500);
       check_for_winner;
     until (pit_end <> home_computer) or (winner <> WINNER_NONE);
end;

procedure turn_user;
var
   move : byte;
   pit_end : byte = 0;
   points : byte = 0;
   key_press : char;
begin
     repeat
       gotoxy(18, 24);
       write('Type a number from 1 to ', home_user - 1, ' to make your move: ');
       repeat
         repeat
           key_press := ReadKey;
         until ((Ord(key_press) >= 49) and (Ord(key_press) <= 54 + (home_user - 7))) or (key_press = KEY_ESC);
         move := Ord(key_press) - 48;
       until (pit_array[move] <> 0) or (key_press = KEY_ESC);
       if key_press <> KEY_ESC then
       begin
            write(move);
            Delay(1500);
            make_move(0, move, pit_end, points);
            draw_pits;
            gotoxy(1, 24);
            ClrEol;
            Delay(1500);
       end
       else
       begin
            quit_early := 1;
       end;
       check_for_winner;
     until (pit_end <> home_user) or (winner <> WINNER_NONE) or (quit_early = 1);
end;

procedure game_end;
var
   s : string;
begin
     case winner of
          1 : s := 'Congratulations, you won the game!';
          2 : s := 'The computer is the winner.';
          3 : s := 'The game is a draw.';
     end;
     s := s + '  Press Enter to continue.';
     gotoxy((81 div 2) - ((length(s) - 1) div 2), 24);
     write(s);
     press_enter;
     clear;
end;

procedure play_game;
begin
     game_setup;
     clear;
     coin_toss;
     draw_pits;
     quit_early := 0;
     repeat
       if current_player = PLAYER_USER then
       begin
         turn_user;
         current_player := PLAYER_COMPUTER;
       end
       else
       begin
            turn_computer;
            current_player := PLAYER_USER;
       end;
     until (winner <> WINNER_NONE) or (quit_early = 1);
     if quit_early = 0 then game_end else clear;
end;

procedure prog_begin;
begin
     init;
     randomize;
     cursoroff;
     draw_main_screen;
end;

procedure prog_end;
begin
     textbackground(Black);
     textcolor(LightGray);
     ClrScr;
end;

procedure prog_main;
var
   key_press : char;
begin
     repeat
       textcolor(White);
       gotoxy(25, 16);
       write('Press Enter to begin a new game.');
       gotoxy(32, 20);
       write('Press Esc to quit.');
       repeat
         key_press := ReadKey;
       until (key_press = KEY_ENTER) or (key_press = KEY_ESC);
       if key_press = KEY_ENTER then play_game;
     until key_press = KEY_ESC;
end;

begin
     prog_begin;
     prog_main;
     prog_end;
end.

