package pokemon_battle_pkg;
    // Shared constants used by all battle modules.
    localparam int NUM_POKEMON = 9;
    // Pokemon selector IDs
    localparam logic [3:0] POKEMON_VENUSAUR  = 4'd0;
    localparam logic [3:0] POKEMON_CHARIZARD = 4'd1;
    localparam logic [3:0] POKEMON_BLASTOISE = 4'd2;
    localparam logic [3:0] POKEMON_PIKACHU   = 4'd3;
    localparam logic [3:0] POKEMON_GENGAR    = 4'd4;
    localparam logic [3:0] POKEMON_FLAREON   = 4'd5;
    localparam logic [3:0] POKEMON_CROBAT    = 4'd6;
    localparam logic [3:0] POKEMON_SHARPEDO  = 4'd7;
    localparam logic [3:0] POKEMON_LUCARIO   = 4'd8;

    // Type IDs used by moves and Pokemon typing for effectiveness checks.
    localparam logic [4:0] TYPE_NORMAL   = 5'd0;
    localparam logic [4:0] TYPE_FIRE     = 5'd1;
    localparam logic [4:0] TYPE_WATER    = 5'd2;
    localparam logic [4:0] TYPE_ELECTRIC = 5'd3;
    localparam logic [4:0] TYPE_GRASS    = 5'd4;
    localparam logic [4:0] TYPE_ICE      = 5'd5;
    localparam logic [4:0] TYPE_FIGHTING = 5'd6;
    localparam logic [4:0] TYPE_POISON   = 5'd7;
    localparam logic [4:0] TYPE_GROUND   = 5'd8;
    localparam logic [4:0] TYPE_FLYING   = 5'd9;
    localparam logic [4:0] TYPE_PSYCHIC  = 5'd10;
    localparam logic [4:0] TYPE_GHOST    = 5'd11;
    localparam logic [4:0] TYPE_DRAGON   = 5'd12;
    localparam logic [4:0] TYPE_DARK     = 5'd13;
    localparam logic [4:0] TYPE_STEEL    = 5'd14;
    localparam logic [4:0] TYPE_FAIRY    = 5'd15;
    localparam logic [4:0] TYPE_ROCK     = 5'd16;
    localparam logic [4:0] TYPE_NONE     = 5'd31;

    // Move category selects whether damage uses Attack/Defense or SpAtk/SpDef.
    localparam logic CATEGORY_PHYSICAL = 1'b0;
    localparam logic CATEGORY_SPECIAL  = 1'b1;

    // Encoded health-bar colors used by the display mapper.
    localparam logic [1:0] HP_GREEN  = 2'b00;
    localparam logic [1:0] HP_ORANGE = 2'b01;
    localparam logic [1:0] HP_RED    = 2'b10;
endpackage

// One stats module
// base stats and Pokemon typing are always driven for that species.
module pokemon_stats(
    input logic [3:0] pokemon_id, // selects the pokemon module we want
    input logic [1:0] move_select,
    output logic [9:0] hp, attack, defense, sp_attack, sp_defense, speed,
    output logic [4:0] type1, type2, move_type,
    output logic [7:0] move_power,
    output logic move_category
);
  import pokemon_battle_pkg::*;

always_comb begin
    if(pokemon_id == 4'd0) begin
   
        // venusaur stats
             hp = 10'd80; attack = 10'd82; defense = 10'd83; sp_attack = 10'd100; sp_defense = 10'd100; speed = 10'd80;
             type1 = TYPE_GRASS; type2 = TYPE_POISON;
                 unique case (move_select)
                  2'd0: begin move_power = 8'd120; move_type = TYPE_GRASS;  move_category = CATEGORY_SPECIAL;  end // Solar Beam
                  2'd1: begin move_power = 8'd55;  move_type = TYPE_GRASS;  move_category = CATEGORY_PHYSICAL; end // Razor Leaf
                  2'd2: begin move_power = 8'd90;  move_type = TYPE_POISON; move_category = CATEGORY_SPECIAL;  end // Sludge Bomb
                  2'd3: begin move_power = 8'd30; move_type = TYPE_GRASS;  move_category = CATEGORY_PHYSICAL;  end // Vine Whip
                 endcase
                 end
    else if(pokemon_id == 4'd1) begin
    //charizard stats
             hp = 10'd78; attack = 10'd84; defense = 10'd78; sp_attack = 10'd109; sp_defense = 10'd85; speed = 10'd100;
             type1 = TYPE_FIRE; type2 = TYPE_FLYING;
        // Move slots 0-3. Each slot outputs power, type, and physical/special category.
             unique case (move_select)
                2'd0: begin move_power = 8'd90;  move_type = TYPE_FIRE;   move_category = CATEGORY_SPECIAL;  end // Flamethrower
                2'd1: begin move_power = 8'd110; move_type = TYPE_FIRE;   move_category = CATEGORY_SPECIAL;  end // Fire Blast
                2'd2: begin move_power = 8'd75;  move_type = TYPE_FLYING; move_category = CATEGORY_SPECIAL;  end // Air Slash
                2'd3: begin move_power = 8'd80; move_type = TYPE_DRAGON; move_category = CATEGORY_PHYSICAL; end // Dragon Claw
             endcase
    end
    else if(pokemon_id == 4'd2) begin
    //blastoise stats
     hp = 10'd79; attack = 10'd83; defense = 10'd100; sp_attack = 10'd85; sp_defense = 10'd105; speed = 10'd78;
        type1 = TYPE_WATER; type2 = TYPE_NONE;
        unique case (move_select)
            2'd0: begin move_power = 8'd90;  move_type = TYPE_WATER;  move_category = CATEGORY_SPECIAL;  end // Surf
            2'd1: begin move_power = 8'd110; move_type = TYPE_WATER;  move_category = CATEGORY_SPECIAL;  end // Hydro Pump
            2'd2: begin move_power = 8'd90;  move_type = TYPE_ICE;    move_category = CATEGORY_SPECIAL;  end // Ice Beam
            2'd3: begin move_power = 8'd130; move_type = TYPE_NORMAL; move_category = CATEGORY_PHYSICAL; end // Skull Bash
        endcase       
    end
     else if(pokemon_id == 4'd3) begin
     //pikachu stats
         hp = 10'd35; attack = 10'd55; defense = 10'd40; sp_attack = 10'd50; sp_defense = 10'd50; speed = 10'd90;
        type1 = TYPE_ELECTRIC; type2 = TYPE_NONE;
        unique case (move_select)
            2'd0: begin move_power = 8'd90;  move_type = TYPE_ELECTRIC; move_category = CATEGORY_SPECIAL;  end // Thunderbolt
            2'd1: begin move_power = 8'd110; move_type = TYPE_ELECTRIC; move_category = CATEGORY_SPECIAL;  end // Thunder
            2'd2: begin move_power = 8'd40;  move_type = TYPE_NORMAL;   move_category = CATEGORY_PHYSICAL; end // Quick Attack
            2'd3: begin move_power = 8'd100; move_type = TYPE_STEEL;  move_category = CATEGORY_PHYSICAL; end // Iron Tail
        endcase
    end
    else if(pokemon_id == 4'd4) begin
    //gengar stats
    hp = 10'd60; attack = 10'd65; defense = 10'd60; sp_attack = 10'd130; sp_defense = 10'd75; speed = 10'd110;
        type1 = TYPE_GHOST; type2 = TYPE_POISON;
        unique case (move_select)
            2'd0: begin move_power = 8'd80; move_type = TYPE_GHOST;  move_category = CATEGORY_SPECIAL; end // Shadow Ball
            2'd1: begin move_power = 8'd95; move_type = TYPE_POISON; move_category = CATEGORY_SPECIAL; end // Sludge Wave
            2'd2: begin move_power = 8'd100; move_type = TYPE_PSYCHIC; move_category = CATEGORY_SPECIAL; end // Dream Eater
            2'd3: begin move_power = 8'd80; move_type = TYPE_FAIRY; move_category = CATEGORY_SPECIAL; end // Dazzling Gleam
        endcase
    end
    else if(pokemon_id == 4'd5) begin
    //flareon stats
        hp = 10'd65; attack = 10'd130; defense = 10'd60; sp_attack = 10'd95; sp_defense = 10'd110; speed = 10'd65;
        type1 = TYPE_FIRE; type2 = TYPE_NONE;
        unique case (move_select)
            2'd0: begin move_power = 8'd120; move_type = TYPE_FIRE;     move_category = CATEGORY_PHYSICAL; end // Flare Blitz
            2'd1: begin move_power = 8'd65;  move_type = TYPE_FIRE;     move_category = CATEGORY_PHYSICAL; end // Fire Fang
            2'd2: begin move_power = 8'd60;  move_type = TYPE_DARK;     move_category = CATEGORY_PHYSICAL; end // Bite
            2'd3: begin move_power = 8'd120; move_type = TYPE_FIGHTING; move_category = CATEGORY_PHYSICAL; end // Superpower
        endcase
    end
    else if(pokemon_id == 4'd6) begin
    //crobat stats
        hp = 10'd85; attack = 10'd90; defense = 10'd80; sp_attack = 10'd70; sp_defense = 10'd80; speed = 10'd130;
        type1 = TYPE_POISON; type2 = TYPE_FLYING;
        unique case (move_select)
            2'd0: begin move_power = 8'd70; move_type = TYPE_POISON; move_category = CATEGORY_PHYSICAL; end // Cross Poison
            2'd1: begin move_power = 8'd75; move_type = TYPE_FLYING; move_category = CATEGORY_SPECIAL;  end // Air Slash
            2'd2: begin move_power = 8'd60; move_type = TYPE_DARK;   move_category = CATEGORY_PHYSICAL; end // Bite
            2'd3: begin move_power = 8'd100; move_type = TYPE_GHOST; move_category = CATEGORY_SPECIAL;  end // Ominous Wind
        endcase
    end
    else if(pokemon_id == 4'd7) begin
    //sharpedo stats
        hp = 10'd70; attack = 10'd120; defense = 10'd40; sp_attack = 10'd95; sp_defense = 10'd40; speed = 10'd95;
        type1 = TYPE_WATER; type2 = TYPE_DARK;
        unique case (move_select)
            2'd0: begin move_power = 8'd80; move_type = TYPE_DARK;  move_category = CATEGORY_PHYSICAL; end // Crunch
            2'd1: begin move_power = 8'd80; move_type = TYPE_WATER; move_category = CATEGORY_PHYSICAL; end // Waterfall
            2'd2: begin move_power = 8'd65; move_type = TYPE_ICE;   move_category = CATEGORY_PHYSICAL; end // Ice Fang
            2'd3: begin move_power = 8'd70; move_type = TYPE_DARK; move_category = CATEGORY_PHYSICAL; end // Night Slash
        endcase
    end
    else if(pokemon_id == 4'd8) begin
    //lucario stats
        hp = 10'd70; attack = 10'd110; defense = 10'd70; sp_attack = 10'd115; sp_defense = 10'd70; speed = 10'd90;
        type1 = TYPE_FIGHTING; type2 = TYPE_STEEL;
        unique case (move_select)
            2'd0: begin move_power = 8'd80;  move_type = TYPE_FIGHTING; move_category = CATEGORY_SPECIAL;  end // Aura Sphere
            2'd1: begin move_power = 8'd120; move_type = TYPE_FIGHTING; move_category = CATEGORY_PHYSICAL; end // Close Combat
            2'd2: begin move_power = 8'd25;  move_type = TYPE_GROUND;   move_category = CATEGORY_PHYSICAL; end // Bone Rush
            2'd3: begin move_power = 8'd80; move_type = TYPE_NORMAL;  move_category = CATEGORY_PHYSICAL; end // Extreme Speed
        endcase
    end
    else begin
    
    end
    
end

endmodule


module damage_calculator (
    
    input logic [7:0] move_power,
    input logic [4:0] move_type,
    input logic move_category,
    input logic [9:0] attacker_attack,
    input logic [9:0] attacker_sp_attack,
    input logic [9:0] defender_defense,
    input logic [9:0] defender_sp_defense,
    input logic [4:0] defender_type1,
    input logic [4:0] defender_type2,
    output logic [9:0] damage
);
    import pokemon_battle_pkg::*;
    logic [9:0] atk_stat, def_stat;
    logic [31:0] base_damage, scaled_damage;
    logic [1:0] effectiveness_num;
    logic [1:0] effectiveness_num2;
    logic [1:0] effectiveness_den;
    logic [1:0] effectiveness_den2;
    logic [6:0] level;
    
    assign level = 8'd50;

    module apply_one_type(
        input logic [4:0] atk_type,
        input logic [4:0] def_type,
        output logic [1:0] num,
        output logic [1:0] den
        
    );
    always_comb begin
        if (atk_type == TYPE_FIRE && def_type == TYPE_GRASS) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_FIRE && (def_type == TYPE_WATER || def_type == TYPE_ROCK || def_type == TYPE_FIRE)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_WATER && def_type == TYPE_FIRE) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_WATER && (def_type == TYPE_GRASS || def_type == TYPE_WATER)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_ELECTRIC && def_type == TYPE_WATER) begin
            num = 2;
            den = 1;
          
        end 
        else if (atk_type == TYPE_ELECTRIC && def_type == TYPE_FLYING) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_ELECTRIC && def_type == TYPE_GROUND) begin
            num = 0;
            den = 1;
        end 
        else if (atk_type == TYPE_ELECTRIC && (def_type == TYPE_ELECTRIC || def_type == TYPE_GRASS || def_type == TYPE_DRAGON)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_GHOST && def_type == TYPE_PSYCHIC) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_GHOST && def_type == TYPE_GHOST) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_GHOST && def_type == TYPE_NORMAL) begin
            num = 0;
            den = 1;
        end 
        else if (atk_type == TYPE_FIGHTING && def_type == TYPE_NORMAL) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_FIGHTING && (def_type == TYPE_DARK || def_type == TYPE_ICE || def_type == TYPE_ROCK || def_type == TYPE_STEEL)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_FIGHTING && def_type == TYPE_GHOST) begin
            num = 0;
            den = 1;
        end 
        else if (atk_type == TYPE_FIGHTING && (def_type == TYPE_POISON || def_type == TYPE_FLYING || def_type == TYPE_PSYCHIC || def_type == TYPE_FAIRY)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_DRAGON && def_type == TYPE_DRAGON) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_DRAGON && def_type == TYPE_FAIRY) begin
            num = 0;
            den = 1;
        end 
        else if (atk_type == TYPE_POISON && (def_type == TYPE_FAIRY || def_type == TYPE_GRASS)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_POISON && (def_type == TYPE_POISON || def_type == TYPE_GROUND || def_type == TYPE_ROCK || def_type == TYPE_GHOST)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_FLYING && (def_type == TYPE_FIGHTING || def_type == TYPE_GROUND || def_type == TYPE_GRASS)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_FLYING && (def_type == TYPE_ELECTRIC || def_type == TYPE_ROCK || def_type == TYPE_STEEL)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_GRASS && def_type == TYPE_WATER) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_GRASS && (def_type == TYPE_GROUND || def_type == TYPE_ROCK)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_GRASS && (def_type == TYPE_FIRE || def_type == TYPE_GRASS || def_type == TYPE_POISON || def_type == TYPE_FLYING || def_type == TYPE_DRAGON || def_type == TYPE_STEEL)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_ICE && (def_type == TYPE_DRAGON || def_type == TYPE_FLYING || def_type == TYPE_GRASS || def_type == TYPE_GROUND)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_ICE && (def_type == TYPE_FIRE || def_type == TYPE_WATER || def_type == TYPE_ICE || def_type == TYPE_STEEL)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_DARK && (def_type == TYPE_GHOST || def_type == TYPE_PSYCHIC)) begin
            num = 2;
           den = 1;
        end 
        else if (atk_type == TYPE_DARK && (def_type == TYPE_FIGHTING || def_type == TYPE_DARK || def_type == TYPE_FAIRY)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_GROUND && (def_type == TYPE_FIRE || def_type == TYPE_POISON || def_type == TYPE_STEEL || def_type == TYPE_ROCK || def_type == TYPE_ELECTRIC)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_GROUND && def_type == TYPE_FLYING) begin
            num = 0;
            den = 1;
        end 
        else if (atk_type == TYPE_STEEL && (def_type == TYPE_ICE || def_type == TYPE_ROCK || def_type == TYPE_FAIRY)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_STEEL && (def_type == TYPE_FIRE || def_type == TYPE_WATER || def_type == TYPE_ELECTRIC || def_type == TYPE_STEEL)) begin
            den = 2;
            num = 1;
        end 
        else if (atk_type == TYPE_FAIRY && (def_type == TYPE_FIGHTING || def_type == TYPE_DRAGON || def_type == TYPE_DARK)) begin
            num = 2;
            den = 1;
        end 
        else if (atk_type == TYPE_FAIRY && (def_type == TYPE_FIRE || def_type == TYPE_POISON || def_type == TYPE_STEEL)) begin
            den = 2;
            num = 1;
        end
        else begin
            num = 1;
            den = 1;
         //do nothing
        end
        end
      
    endmodule

    always_comb begin
        // Physical moves use Attack vs Defense; special moves use SpAtk vs SpDef.
//        atk_stat = (move_category == CATEGORY_SPECIAL) ? attacker_sp_attack : attacker_attack;
//        def_stat = (move_category == CATEGORY_SPECIAL) ? defender_sp_defense : defender_defense;
        if(move_category == CATEGORY_PHYSICAL)begin
            atk_stat = attacker_attack;
            def_stat = defender_defense;
        end
        else begin
            atk_stat = attacker_sp_attack;
            def_stat = defender_sp_defense;
        end
        
        end
        

        // Combine effectiveness from type1 and type2.
        apply_one_type type1(
            .atk_type(move_type),
            .def_type(defender_type1),
            .num(effectiveness_num),
            .den(effectiveness_den)
            );
            
        apply_one_type type2(
            .atk_type(move_type),
            .def_type(defender_type2),
            .num(effectiveness_num2),
            .den(effectiveness_den2)
            );
       
        always_comb begin

        // Status moves or no-effect moves do zero damage.
        if(effectiveness_num == 0)begin
            damage = 10'd0;
        end 
        else begin
            // Simplified Pokemon damage formula:
            // (((2*Level/5+2) * Power * Atk/Def) / 50) + 2, then type scaling.
            base_damage = (((((2 * level) / 5) + 2) * move_power * atk_stat) / def_stat) / 50 + 2;
            scaled_damage = (base_damage*effectiveness_num*effectiveness_num2) / (effectiveness_den*effectiveness_den2);
            if (scaled_damage == 0)begin
                 damage = 10'd1;
                 end
            else if (scaled_damage > 1023) begin
                damage = 10'd1023;
                end
            else begin
                 damage = scaled_damage[9:0];
                 end
        end
    end
endmodule

module turn_tracker(
    input logic clk,
    input logic reset,
    input logic battle_begin,
    input logic turnupdater,
    
    output logic [5:0] turn
    
    );
        

    always_ff @(posedge clk) begin
        if(reset|| battle_begin)
            turn = 5'b00000;
        else if(turnupdater == 1'b1)
            turn = turn + 1;
        else
            turn = turn;
            
    
    
    end
    
endmodule


module hp_tracker (
    input logic clk,
    input logic reset,
    input logic battle_start,
    input logic apply_damage,
    input logic [9:0] max_hp,
    
    input logic [9:0] damage,
    output logic [9:0] current_hp_after
    );
    logic [9:0] hp;
    
    
    always_ff @(posedge clk) begin
        if (reset||battle_start) begin
         hp <= max_hp;
         end
        else if (apply_damage) begin
            if (damage >= current_hp_after)
             hp <= 10'd0;
            else begin
             hp <= hp - damage;
             end
//        else begin
//            hp <= hp;
//        end
        
    end
//    always_comb begin
//         if (apply_damage) begin
//            if (damage >= current_hp_after)
//             current_hp_after = 10'd0;
//            else begin
//             hp = current_hp_after;
//             current_hp_after = hp - damage;
//             end
    end
   assign current_hp_after = hp;
//             end
             
endmodule

module attacked(
    input logic clk,
    input logic reset,
    input logic attacksignal,
    input logic turnoversignal,
    
    output logic attacked
    

);

    always_ff @(posedge clk)begin
        if(attacksignal)
            attacked <= 1'b1;
        else if(turnoversignal)
            attacked <= 1'b0;
        else if(reset)
            attacked <= 1'b0;
    
    
    
    end


endmodule

module speedchecker(
    input logic clk,
    input logic [9:0] player_speed,
    input logic [9:0] enemy_speed,
    input logic speedcheckthingy,
    output logic player_winner,
    output logic enemy_winner
    );
    always_ff @(posedge clk) begin
    if(speedcheckthingy == 1'b1) begin
      if(player_speed > enemy_speed)begin
        player_winner = 1'b1;
        enemy_winner = 1'b0;
      end
    
      else begin
        player_winner = 1'b0;
        enemy_winner = 1'b1;
    
        end
    end
    else begin
        player_winner = 1'b0;
        enemy_winner = 1'b0;
         end
    end
     
    
endmodule

module health_bar (
    input logic [9:0] current_hp,
    input logic [9:0] max_hp,
    output logic [1:0] color,
    output logic [7:0] length
    );
    import pokemon_battle_pkg::*;
    always_comb begin
       
        length = (max_hp == 0) ? 8'd0 : (current_hp * 8'd100) / max_hp;
        if ((current_hp * 10'd100) > (max_hp * 10'd50)) color = HP_GREEN;
        else if ((current_hp * 10'd100) >= (max_hp * 10'd20)) color = HP_ORANGE;
        else color = HP_RED;
    end
endmodule

// Simple faint detector
module faint_detector (
    input logic [9:0] current_hp,
    output logic fainted
);
    always_comb begin
    if(current_hp <= 10'd0)
        fainted = 1'b1;
    else
        fainted = 1'b0;
    
    
    
    
    end
endmodule

module pokemon_battle_top (
    input logic clk,
    input logic reset,

    input logic [3:0] player_select, //player is attacker
    input logic [3:0] enemy_select, //enemy ai is defender
    input logic [7:0] keycode,
    
    output logic [9:0] player_pokemon_hp_current,
    output logic [9:0] enemy_pokemon_hp_current,
    output logic [1:0] player_bar_color,
    output logic [1:0] enemy_bar_color,
    output logic [7:0] player_bar_length,
    output logic [7:0] enemy_bar_length,
    output logic player_pokemon_fainted,
    output logic enemy_pokemon_fainted,
//    output logic attack_null,
//    output logic [9:0] last_damage,
    output logic [5:0] display_state
);
    import pokemon_battle_pkg::*;
    

    enum logic [3:0] {
//        START,
//        SELECT,
        TURNZERO,
        WAIT_USER_INPUT1,
        WAIT_USER_INPUT2,
        SPEED_CHECK, 
        USER_ATTACK,         
        ENEMY_ATTACK,    
        CHECK_FAINT,     
        TURN_UPDATE,
        BATTLE_END_PLAYER_WINS,       
        BATTLE_END_PLAYER_LOSES     
    } battle_state, battle_state_nxt;
    
    always_ff @ (posedge clk)
	begin
//			battle_state <= battle_state_nxt;
			if(reset)
			battle_state <= TURNZERO;
			else
			battle_state <= battle_state_nxt;
			
	end
    
    logic [1:0] move_select;

//    logic [9:0] calculated_damage;
    logic [1:0] player_barcolor, enemy_barcolor;
    logic [7:0] player_barL, enemy_barL;
//    logic fainted [2];

    logic valid_attacker, valid_defender;
    logic attacker_is_fainted;
    logic defender_is_fainted;
    logic player_fainted;
    logic enemy_fainted;
    logic apply_damage_player;
    
    logic [9:0] player_damage;
    logic [9:0] enemy_damage;
    
    logic [1:0] enemy_ai_move_select;
    
    logic [9:0] player_hp, player_attack, player_defense, player_sp_attack, player_sp_defense, player_speed;
    logic [4:0] player_type1, player_type2, player_move_type;
    logic [7:0] player_move_power;
    logic player_move_category;
    
    logic [9:0] player_hp_max;
    
    logic [9:0] enemy_hp, enemy_attack, enemy_defense, enemy_sp_attack, enemy_sp_defense, enemy_speed;
    logic [4:0] enemy_type1, enemy_type2, enemy_move_type;
    logic [7:0] enemy_move_power;
    logic enemy_move_category;
    
    logic [9:0] enemy_hp_max;


    
    logic [4:0] turn; 
    logic battlebegin;
    logic turnupdate;
    logic speedcheck;
    logic ai_move_signal;
    logic apply_damage_to_enemy;
    logic apply_damage_to_player;
    logic did_user_attack;
    logic did_enemy_attack;  
    logic enemy_wins_sc;
    logic player_wins_sc;
    logic user_attacked, enemy_attacked;
    logic isturnzero;
    logic turnover;
    
   always_comb begin
    if(keycode == 8'h1E) begin
        move_select = 2'b00;
    end
    else if(keycode == 8'h1F) begin
        move_select = 2'b01;
    end
    else if(keycode == 8'h20) begin
        move_select = 2'b10;
    end
    else if(keycode == 8'h21) begin
        move_select = 2'b11;
    end
    
    end
    

    logic [9:0] last_damage_reg;
    
    always_comb begin
        turnupdate = 1'b0;
        speedcheck = 1'b0;
        ai_move_signal = 1'b0;
        display_state = 5'b00000;
        isturnzero = 1'b0;
        turnover = 1'b0;
        user_attacked = 1'b0;
        enemy_attacked = 1'b0;
        apply_damage_to_enemy = 1'b0;
        apply_damage_to_player = 1'b0;

            
            case (battle_state)
            TURNZERO: begin
                isturnzero = 1'b1;
                display_state = 5'b00000;
            
            end
            
            WAIT_USER_INPUT1: begin
                display_state = 5'b00001;
            
                 end
            WAIT_USER_INPUT2: begin
                display_state = 5'b00010;
            
            end
            SPEED_CHECK:  begin
            display_state = 5'b00011;
            speedcheck = 1'b1;
            
            end
            USER_ATTACK: begin
            display_state = 5'b00100;
            apply_damage_to_enemy = 1'b1;
            user_attacked = 1'b1;
            
            
            end
            ENEMY_ATTACK: begin
            display_state = 5'b00101;
            ai_move_signal = 1'b1;
            apply_damage_to_player = 1'b1;
            enemy_attacked = 1'b1;
            
            end
            CHECK_FAINT: begin
            display_state = 5'b00110;
            
            end            
            TURN_UPDATE: begin
            display_state = 5'b00111;

            turnupdate = 1'b1;
            turnover = 1'b1;
            end
            BATTLE_END_PLAYER_WINS: begin
            display_state = 5'b01000;
            
            
            
            end
            
            BATTLE_END_PLAYER_LOSES: begin
            display_state = 5'b01001;
            
            
            end
            endcase
    
    end
    
    turn_tracker turnupdater(
        .clk(clk),
        .reset(reset),
        .battle_begin(battlebegin),
        .turnupdater(turnupdate),
        
        .turn(turn)
    
    
    );
    //makes the hp update to max at turn 0
    always_comb begin
    
    if(isturnzero == 1'b1) begin    
        if(turn == 1'b0)
            battlebegin = 1'b1;
        else
            battlebegin = 1'b0;
            
       end  
     else
        battlebegin = 1'b0;   
    end

    
    
    ENEMYAI enemy_move(
        .clk(clk),
        .move_signal(ai_move_signal),
        
        .move_select_ai(enemy_ai_move_select)
   
    );
    
    
    
    pokemon_stats player_stats(
     .pokemon_id(player_select),
     .move_select(move_select),
     .hp(player_hp),
     .attack(player_attack),
     .sp_attack(player_sp_attack),
     .defense(player_defense),
     .sp_defense(player_sp_defense),
     .speed(player_speed),
     .type1(player_type1),
     .type2(player_type2),
     .move_type(player_move_type),
     .move_power(player_move_power),
     .move_category(player_move_category)
     );
     
     assign player_hp_max = player_hp;
     
     pokemon_stats enemy_stats(
     .pokemon_id(enemy_select),
     .move_select(enemy_ai_move_select),
     .hp(enemy_hp),
     .attack(enemy_attack),
     .sp_attack(enemy_sp_attack),
     .defense(enemy_defense),
     .sp_defense(enemy_sp_defense),
     .speed(enemy_speed),
     .type1(enemy_type1),
     .type2(enemy_type2),
     .move_type(enemy_move_type),
     .move_power(enemy_move_power),
     .move_category(enemy_move_category)
     );
        
     assign enemy_hp_max = enemy_hp;
     
hp_tracker hp_reg_player (
                .clk(clk),
                .reset(reset),
                .battle_start(battlebegin),
                .apply_damage(apply_damage_to_player),
                .max_hp(player_hp_max),
                .damage(enemy_damage),
                .current_hp_after(player_pokemon_hp_current)
            );
            
hp_tracker hp_reg_enemy (
                .clk(clk),
                .reset(reset),
                .battle_start(battlebegin),
                .apply_damage(apply_damage_to_enemy),
                .max_hp(enemy_hp_max),
                .damage(player_damage),
                .current_hp_after(enemy_pokemon_hp_current)
            );
     speedchecker waiterwaitercheckplease(
     .clk(clk),
     .player_speed(player_speed),
     .enemy_speed(enemy_speed),
     .speedcheckthingy(speedcheck),
     .player_winner(player_wins_sc),
     .enemy_winner(enemy_wins_sc)
     );
     
     
     
     faint_detector player_fainted_check(
        .current_hp(player_pokemon_hp_current),
        .fainted(player_pokemon_fainted)
     );
     
     faint_detector enemy_fainted_check(
        .current_hp(enemy_pokemon_hp_current),
        .fainted(enemy_pokemon_fainted)
     );
     
     health_bar bar_attacker (
                .current_hp(player_pokemon_hp_current),
                .max_hp(player_hp_max),
                .color(player_barcolor),
                .length(player_barL)
     );
     
     
     health_bar bar_defender (
                .current_hp(enemy_pokemon_hp_current),
                .max_hp(enemy_hp_max),
                .color(enemy_barcolor),
                .length(enemy_barL)
     );
     
     attacked playerattackcheck(
     
        .clk(clk),
        .reset(reset),
        .attacksignal(user_attacked),
        .turnoversignal(turnover),
        .attacked(did_user_attack)
     );
     
     attacked enemyattackcheck(
     
        .clk(clk),
        .reset(reset),
        .attacksignal(enemy_attacked),
        .turnoversignal(turnover),
        .attacked(did_enemy_attack)
     );
     
     
     
     
     
   damage_calculator calc_player(
        
        .move_power(player_move_power),
        .move_type(player_move_type),
        .move_category(player_move_category),
        .attacker_attack(player_attack),
        .attacker_sp_attack(player_sp_attack),
        .defender_defense(enemy_defense),
        .defender_sp_defense(enemy_sp_defense),
        .defender_type1(enemy_type1),
        .defender_type2(enemy_type2),
        .damage(player_damage)
    );


     damage_calculator calc_enemy(
        
        .move_power(enemy_move_power),
        .move_type(enemy_move_type),
        .move_category(enemy_move_category),
        .attacker_attack(enemy_attack),
        .attacker_sp_attack(enemy_sp_attack),
        .defender_defense(player_defense),
        .defender_sp_defense(player_sp_defense),
        .defender_type1(player_type1),
        .defender_type2(player_type2),
        .damage(enemy_damage)
    );
    assign valid_attacker = (player_select < NUM_POKEMON);
    assign valid_defender = (enemy_select < NUM_POKEMON);
    
    always_comb begin
    
    battle_state_nxt = battle_state;
     
        unique case(battle_state)

        
            TURNZERO:
                if(keycode == 8'h2C) begin
                    battle_state_nxt = WAIT_USER_INPUT2;
                 end
                 else
                    battle_state_nxt = TURNZERO;
        
            WAIT_USER_INPUT1:
                if(keycode == 8'h2C) begin
                    battle_state_nxt = WAIT_USER_INPUT2;
                 end
                 else
                    battle_state_nxt = WAIT_USER_INPUT1;
            WAIT_USER_INPUT2: begin
                if((keycode == 8'h1E)||(keycode == 8'h1F)||(keycode == 8'h20)||(keycode == 8'h21)) begin
                    battle_state_nxt = SPEED_CHECK;
                    end
                else begin
                    battle_state_nxt = WAIT_USER_INPUT2;
                end
                end
            SPEED_CHECK: begin
                if(player_wins_sc == 1'b1)
                    battle_state_nxt = USER_ATTACK;
                else
                    battle_state_nxt = ENEMY_ATTACK;
            end
            USER_ATTACK: begin
//                    user_attacked = 1'b1;
                    battle_state_nxt = CHECK_FAINT;            
            end
            ENEMY_ATTACK: begin
//                    enemy_attacked = 1'b1;
                    battle_state_nxt = CHECK_FAINT;            
            end
            CHECK_FAINT: begin
            if((player_pokemon_fainted || enemy_pokemon_fainted) == 1'b0) begin
                if(did_enemy_attack && did_user_attack == 1'b0)begin
                    if(did_enemy_attack == 1'b0)begin
                        battle_state_nxt = ENEMY_ATTACK;
                        end
                    else
                        battle_state_nxt = USER_ATTACK;
                    end
                else
                    battle_state_nxt = TURN_UPDATE;
                    
            end
            else if(player_pokemon_fainted == 1'b1)
                    battle_state_nxt = BATTLE_END_PLAYER_LOSES;
            else
                    battle_state_nxt = BATTLE_END_PLAYER_WINS;
               
            end
            
            TURN_UPDATE: begin
//                user_attacked = 1'b0;
//                enemy_attacked = 1'b0;
                battle_state_nxt = WAIT_USER_INPUT1;
            
            end
            
                      
            
            endcase
                
                
                    
                
                
    
    
    
    
    
    
    end
    
    



//    assign attack_blocked = !valid_attacker || !valid_defender || attacker_is_fainted || defender_is_fainted || (battle_state != WAIT_USER_INPUT);

//    always_ff @(posedge clk) begin
//        if (reset) begin
//            attack_trigger_d <= 1'b0;
//        end else begin
//            attack_trigger_d <= attack_trigger;
//        end
//    end

//    assign user_attack_pulse = attack_trigger && !attack_trigger_d;

//    always_ff @(posedge clk) begin
//        if (reset) begin
//            lfsr <= 8'hA5;
//            cycle_count <= 32'd0;
//        end else begin
//            cycle_count <= cycle_count + 32'd1;
            
//            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
//        end
//    end

    
//    always_ff @(posedge clk) begin
//        if (reset) begin
//            battle_state <= WAIT_USER_INPUT;
//            enemy_ai_move_select <= 2'd0;
//            last_damage_reg <= 10'd0;
//            last_attack_was_user <= 1'b1;
//        end else begin
//            battle_state <= battle_state_nxt;
//            if (battle_state == ENEMY_SELECT) begin
                
//                enemy_ai_move_select <= lfsr[1:0] ^ cycle_count[1:0];
//            end
//            if (battle_state == USER_ATTACK) begin
               
//                last_damage_reg <= calculated_damage;
//                last_attack_was_user <= 1'b1;
//            end else if (battle_state == ENEMY_ATTACK) begin
               
//                last_damage_reg <= calculated_damage;
//                last_attack_was_user <= 1'b0;
//            end
//        end
//    end

//    always_comb begin
//        battle_state_nxt = battle_state;
//        unique case (battle_state)
//            WAIT_USER_INPUT: begin
             
//                if (user_attack_pulse && !attack_blocked) begin
//                    battle_state_nxt = USER_ATTACK;
//                end
//            end
           
//            USER_ATTACK: battle_state_nxt = CHECK_FAINT;
        
//            ENEMY_SELECT: battle_state_nxt = ENEMY_ATTACK;
           
//            ENEMY_ATTACK: battle_state_nxt = CHECK_FAINT;
//            CHECK_FAINT: begin
                
//                if (attacker_is_fainted || defender_is_fainted) begin
//                    battle_state_nxt = BATTLE_END;
//                end else if (last_attack_was_user) begin
                   
//                    battle_state_nxt = ENEMY_SELECT;
//                end else begin
                    
//                    battle_state_nxt = WAIT_USER_INPUT;
//                end
//            end
//            BATTLE_END: battle_state_nxt = BATTLE_END;
//            default: battle_state_nxt = WAIT_USER_INPUT;
//        endcase
//    end

//always_comb begin
        
//        if (player_select < NUM_POKEMON) begin
//            calc_attacker_attack = player_attack;
//            calc_attacker_sp_attack = player_sp_attack;
//        end 
//        else begin
//            calc_attacker_attack = 10'd1;
//            calc_attacker_sp_attack = 10'd1;
//        end

       
//        if (enemy_select < NUM_POKEMON) begin
//            calc_defender_defense = enemy_defense;
//            calc_defender_sp_defense = enemy_sp_defense;
//            calc_defender_type1 = enemy_type1;
//            calc_defender_type2 = enemy_type2;
//        end
//        else begin
//            calc_defender_defense = 10'd1;
//            calc_defender_sp_defense = 10'd1;
//            calc_defender_type1 = TYPE_NORMAL;
//            calc_defender_type2 = TYPE_NONE;
//        end
//    end

//    assign last_damage = last_damage_reg;

//    always_comb begin
//        apply_damage = '0;

//        if (battle_state == USER_ATTACK && valid_attacker && valid_defender && !attacker_is_fainted && !defender_is_fainted)
//         apply_damage[defender_select] = 1'b1;
//        if (battle_state == ENEMY_ATTACK && valid_attacker && valid_defender && !defender_is_fainted)
//        apply_damage[attacker_select] = 1'b1;
//    end
    
    

//    always_comb begin

//        if (valid_attacker) begin
//            attacker_current_hp = player_hp_current;
//            attacker_bar_color = player_barcolor;
//            attacker_bar_length = player_barL;
//            attacker_fainted = fainted[0];
//        end 
//        else begin
//            attacker_current_hp = 10'd0;
//            attacker_bar_color = HP_RED;
//            attacker_bar_length = 8'd0;
//            attacker_fainted = 1'b1;
//        end


//        if (valid_defender) begin
//            enemy_pokemon_hp_current = enemy_hp_current;
//            defender_bar_color = enemy_barcolor;
//            defender_bar_length = enemy_barL;
//            defender_fainted = fainted[1];
//        end 
//        else begin
//            defender_current_hp = 10'd0;
//            defender_bar_color = HP_RED;
//            defender_bar_length = 8'd0;
//            defender_fainted = 1'b1;
//        end
//    end
endmodule
