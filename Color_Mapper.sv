//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] DrawX, DrawY,
                       input logic clk,
                       input logic [3:0] startr, startg, startb, battler, battleg, battleb, spriter, spriteg, spriteb,
                       input logic [3:0] selr, selg, selb, winr, wing, winb, loser, loseg, loseb,
                       input logic [5:0] display_state,
                       input logic [7:0] player_hp_bar_length, enemy_hp_bar_length,
                       input logic [1:0] player_hp_bar_color, enemy_hp_bar_color,
                       input logic player_fainted, enemy_fainted,
                       input  logic [7:0]  keycode,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on;
parameter [9:0] player_x = 80;
parameter [9:0] player_y = 260;
parameter [9:0] enemy_x = 400;
parameter [9:0] enemy_y = 100;


logic [9:0] playerX, PlayerY;
logic [9:0] enemyX, enemyY;
//logic [9:0] player_sprite_x, player_sprite_y;
//logic [9:0] enemy_sprite_x, enemy_sprite_y;
logic playeron, enemyon;



logic player_hp_bar_on, enemy_hp_bar_on;
logic [9:0] player_hp_bar_width, enemy_hp_bar_width;

parameter [9:0] player_hp_bar_x = 400;
parameter [9:0] player_hp_bar_y = 225;
parameter [9:0] enemy_hp_bar_x = 80;
parameter [9:0] enemy_hp_bar_y = 85;
parameter [9:0] hp_bar_max_width = 100;
parameter [9:0] hp_bar_height = 8;

//always_comb begin
//    player_sprite_x   = DrawX - player_x;
//    player_sprite_y   = DrawY - player_y;
//    enemy_sprite_x = DrawX - enemy_x;
//    enemy_sprite_y = DrawY - enemy_y;
//    end
assign playeron = (DrawX >= player_x) && (DrawX < player_x + 80)&&(DrawY >= player_y) && (DrawY < player_y + 80);
assign enemyon = (DrawX >= enemy_x) && (DrawX < enemy_x + 80)&&(DrawY >= enemy_y) && (DrawY < enemy_y + 80);
	 
	 
	 
assign player_hp_bar_width = (player_hp_bar_length * hp_bar_max_width) / 100;

assign enemy_hp_bar_width = (enemy_hp_bar_length * hp_bar_max_width) / 100;

assign player_hp_bar_on = (DrawX >= player_hp_bar_x) && (DrawX < player_hp_bar_x + player_hp_bar_width) &&
                          (DrawY >= player_hp_bar_y) && (DrawY < player_hp_bar_y + hp_bar_height);
                          
assign enemy_hp_bar_on = (DrawX >= enemy_hp_bar_x) && (DrawX < enemy_hp_bar_x + enemy_hp_bar_width) &&
                         (DrawY >= enemy_hp_bar_y) && (DrawY < enemy_hp_bar_y + hp_bar_height);
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
    logic [11:0] magenta = 12'hF0D;
    int DistX, DistY, Size;
//    assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
  
//    always_comb
//    begin:Ball_on_proc
//        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
//            ball_on = 1'b1;
//        else 
//            ball_on = 1'b0;
//     end 
    
    enum logic [3:0] {
	start,
	select,
	battle,
	battle_select,
	idle,
	checkfaint,
	win,
	lose
	} state, state_nxt; 
    
    
    always_ff @ (posedge clk)
	begin
		
			state <= state_nxt;
	end
       
    always_comb
    begin
            Red = startr;
            Green = startg;
            Blue = startb;
        
            case (state)
                start: ;
                select:
                begin
                    Red = selr;
                    Green = selg;
                    Blue = selb;
                end
                
                
                battle:
                    begin
                        Red = battler;
                        Green = battleg;
                        Blue = battleb;
                          if(playeron || enemyon == 1'b1) begin
                            if ({spriter, spriteg, spriteb} != magenta) begin
                             Red   = spriter;
                             Green = spriteg;
                             Blue  = spriteb;
                             end
                        end
                        if (player_hp_bar_on) begin
                            case (player_hp_bar_color)
                                2'b00: begin Red = 4'h0; Green = 4'hF; Blue = 4'h0; end
                                2'b01: begin Red = 4'hF; Green = 4'h8; Blue = 4'h0; end
                                default: begin Red = 4'hF; Green = 4'h0; Blue = 4'h0; end
                            endcase
                        end
                        if (enemy_hp_bar_on) begin
                            case (enemy_hp_bar_color)
                                2'b00: begin Red = 4'h0; Green = 4'hF; Blue = 4'h0; end
                                2'b01: begin Red = 4'hF; Green = 4'h8; Blue = 4'h0; end
                                default: begin Red = 4'hF; Green = 4'h0; Blue = 4'h0; end
                            endcase
                        end
                        if (player_fainted) begin
                            if ((DrawY >= 10'd20) && (DrawY < 10'd28) && (DrawX >= 10'd20) && (DrawX < 10'd180)) begin
                                Red = 4'hF;
                                Green = 4'h0;
                                Blue = 4'h0;
                            end
                        end
                        else if(enemy_fainted) begin
                            if ((DrawY >= 10'd20) && (DrawY < 10'd28) && (DrawX >= 10'd20) && (DrawX < 10'd180)) begin
                                Red = 4'h0;
                                Green = 4'h0;
                                Blue = 4'hF;
                            end
                        end
                            
                            
//                        if ({spriter, spriteg, spriteb} != magenta) begin
//                             Red   = spriter;
//                             Green = spriteg;
//                             Blue  = spriteb;
//                       end
                    end    
                    battle_select:
                    begin
                        Red = battler;
                        Green = battleg;
                        Blue = battleb;
                          if(playeron || enemyon == 1'b1) begin
                            if ({spriter, spriteg, spriteb} != magenta) begin
                             Red   = spriter;
                             Green = spriteg;
                             Blue  = spriteb;
                             end
                        end
                        if (player_hp_bar_on) begin
                            case (player_hp_bar_color)
                                2'b00: begin Red = 4'h0; Green = 4'hF; Blue = 4'h0; end
                                2'b01: begin Red = 4'hF; Green = 4'h8; Blue = 4'h0; end
                                default: begin Red = 4'hF; Green = 4'h0; Blue = 4'h0; end
                            endcase
                        end
                        if (enemy_hp_bar_on) begin
                            case (enemy_hp_bar_color)
                                2'b00: begin Red = 4'h0; Green = 4'hF; Blue = 4'h0; end
                                2'b01: begin Red = 4'hF; Green = 4'h8; Blue = 4'h0; end
                                default: begin Red = 4'hF; Green = 4'h0; Blue = 4'h0; end
                            endcase
                        end
                        if (player_fainted) begin
                            if ((DrawY >= 10'd20) && (DrawY < 10'd28) && (DrawX >= 10'd20) && (DrawX < 10'd180)) begin
                                Red = 4'hF;
                                Green = 4'h0;
                                Blue = 4'h0;
                            end
                        end
                        else if(enemy_fainted) begin
                            if ((DrawY >= 10'd20) && (DrawY < 10'd28) && (DrawX >= 10'd20) && (DrawX < 10'd180)) begin
                                Red = 4'h0;
                                Green = 4'h0;
                                Blue = 4'hF;
                            end
                        end     
                    end
                    
                    win:
                    begin
                        Red = winr;
                        Green = wing;
                        Blue = winb;
                        end
                    
                    lose:
                    begin
                        Red = loser;
                        Green = loseg;
                        Blue = loseb;
                    
                    
                    
                    end
            endcase
        
        
    
    
    end
    
    always_comb begin
        state_nxt = state;
        
            unique case (state)
                 start:
                 begin
                     if(display_state == 5'b00001)
                        state_nxt = select;
                     else
                        state_nxt = start;
                 end
                 
                 
                 select:
                 begin
                    if(display_state == 5'b00010)
                        state_nxt = battle;
                    else
                        state_nxt = select;
                 
                 
                 end
                 
                 
                 battle:
                 begin
                    if(display_state == 5'b00100)
                        state_nxt = battle_select;
                    else
                    state_nxt = battle;
                 end
                 
                 
                 battle_select:
                 begin
                    if(display_state == 5'b00010)
                        state_nxt = battle;
                    else
                        state_nxt = battle_select;
                 end
                
                
                 win:
                 begin
                    if(display_state == 5'b00000)
                        state_nxt = start;
                    else
                        state_nxt = win;
                 
                 
                 end
                 
                 
                 lose:
                 begin
                    if(display_state == 5'b00000)
                        state_nxt = start;
                    else
                        state_nxt = lose;
                 
                 
                 end
                
                
                faint:
                begin
					if(player_fainted == 1'b1) // change this to displaystate stuff and refer to how fsm in battle system works.  Also idle always goes to faint but faint can go to idle, win, lose, and battle
                        state_nxt = lose;
                    else
                        state_nxt = win;
                end
            endcase
    end
    

    
    
endmodule
