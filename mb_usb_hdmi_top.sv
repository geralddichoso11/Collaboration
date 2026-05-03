//-------------------------------------------------------------------------
//    mb_usb_hdmi_top.sv                                                 --
//    Zuofu Cheng                                                        --
//    2-29-24                                                            --
//    10-14-25                                                           --
//                                                                       --
//    Fall 2025 Distribution                                           --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
);
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY;
//     ballxsig, ballysig, ballsizesig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic [3:0] menured, menugreen, menublue, battlered, battlegreen, battleblue, spritered, spritegreen, spriteblue;
    assign reset_ah = reset_rtl_0;
    

    logic [3:0] battle_attacker_select, battle_defender_select;
    logic [1:0] battle_move_select;
    logic [9:0] battle_attacker_hp, battle_defender_hp;
    logic [1:0] battle_attacker_bar_color, battle_defender_bar_color;
    logic [7:0] battle_attacker_bar_length, battle_defender_bar_length;
    logic battle_attacker_fainted, battle_defender_fainted, battle_attack_blocked;
    logic [9:0] battle_last_damage;
    
    assign battle_attacker_select = 4'd1; // Charizard
    assign battle_defender_select = 4'd0; // Venusaur
    assign battle_move_select = 2'd0;     // Charizard Flamethrower
    
    
    //Keycode HEX drivers
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[31:28], keycode0_gpio[27:24], keycode0_gpio[23:20], keycode0_gpio[19:16]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_usb mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );

    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );


    //Ball Module
//    ball ball_instance(
//        .Reset(reset_ah),
//        .frame_clk(),                    //Figure out what this should be so that the ball will move
//        .keycode(keycode0_gpio[7:0]),    //Notice: only one keycode connected to ball by default
//        .BallX(ballxsig),
//        .BallY(ballysig),
//        .BallS(ballsizesig)
//    );
//    Background background_output();

//logic [3:0] menured, menugreen, menublue;

//    menuscreen_example(
//        .vga_clk(clk_25MHz),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .blank(vde),
        
//        .red(menured),
//        .green(menugreen),
//        .blue(menublue)
    
//    );
     pokemenu_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        
        .red(menured),
        .green(menugreen),
        .blue(menublue)
    
    );
    
//    sprite1_example(
//        .vga_clk(clk_25MHz),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .blank(vde),
        
//        .red(spritered),
//        .green(spritegreen),
//        .blue(spriteblue)
        
    
    
//    );
    battlescreenfinal_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        
        .red(battlered),
        .green(battlegreen),
        .blue(battleblue)
        
    
    
    );
    
    newsprites_example(
        .vga_clk(clk_25MHz),
        .spritefront(),
        .spriteback(),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        
        .red(spritered),
        .green(spritegreen),
        .blue(spriteblue)
    );
    
    
    
    
//    Color Mapper Module   
    color_mapper color_instance(
//        .BallX(ballxsig),
//        .BallY(ballysig),
        .DrawX(drawX),
        .DrawY(drawY),
        .clk(Clk),
        .keycode(keycode0_gpio[7:0]),
        .startr(menured),
        .startg(menugreen),
        .startb(menublue),
        .battler(battlered),
        .battleg(battlegreen),
        .battleb(battleblue),
        .spriter(spritered),
        .spriteg(spritegreen),
        .spriteb(spriteblue),
        .player_hp_bar_length(battle_attacker_bar_length),
        .enemy_hp_bar_length(battle_defender_bar_length),
        .player_hp_bar_color(battle_attacker_bar_color),
        .enemy_hp_bar_color(battle_defender_bar_color),
        .player_fainted(battle_attacker_fainted),
        .enemy_fainted(battle_defender_fainted),
//        .Ball_size(ballsizesig),
        .Red(red),
        .Green(green),
        .Blue(blue)
    );
    
// always_ff @(posedge Clk) begin
//        if (reset_ah) begin
//            battle_attack_key_d <= 1'b0;
//        end else begin
//            battle_attack_key_d <= (keycode0_gpio[7:0] == 8'h2C);
//        end
//    end

//    assign battle_attack_trigger = (keycode0_gpio[7:0] == 8'h2C) && !battle_attack_key_d;
    
 pokemon_battle_top pokemon_battle_logic (
        .clk(Clk),
        .reset(reset_ah),
        
        .player_select(battle_attacker_select),
        .enemy_select(battle_defender_select),
        
        .keycode(keycode0_gpio[7:0]),
        
        .player_pokemon_hp_current(battle_attacker_hp),
        .enemy_pokemon_hp_current(battle_defender_hp),
        .player_bar_color(battle_attacker_bar_color),
        .enemy_bar_color(battle_defender_bar_color),
        .player_bar_length(battle_attacker_bar_length),
        .enemy_bar_length(battle_defender_bar_length),
        .player_pokemon_fainted(battle_attacker_fainted),
        .enemy_pokemon_fainted(battle_defender_fainted)
        
        
        );
    
endmodule
