/*
  
   Multicore 2 / Multicore 2+
  
   Copyright (c) 2017-2020 - Victor Trucco

  
   All rights reserved
  
   Redistribution and use in source and synthezised forms, with or without
   modification, are permitted provided that the following conditions are met:
  
   Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
  
   Redistributions in synthesized form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
  
   Neither the name of the author nor the names of other contributors may
   be used to endorse or promote products derived from this software without
   specific prior written permission.
  
   THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
  
   You are responsible for any legal issues arising from your use of this code.
  
*///   __   __     __  __     __         __
//  /\ "-.\ \   /\ \/\ \   /\ \       /\ \
//  \ \ \-.  \  \ \ \_\ \  \ \ \____  \ \ \____
//   \ \_\\"\_\  \ \_____\  \ \_____\  \ \_____\
//    \/_/ \/_/   \/_____/   \/_____/   \/_____/
//   ______     ______       __     ______     ______     ______
//  /\  __ \   /\  == \     /\ \   /\  ___\   /\  ___\   /\__  _\
//  \ \ \/\ \  \ \  __<    _\_\ \  \ \  __\   \ \ \____  \/_/\ \/
//   \ \_____\  \ \_____\ /\_____\  \ \_____\  \ \_____\    \ \_\
//    \/_____/   \/_____/ \/_____/   \/_____/   \/_____/     \/_/
//
// https://joshbassett.info
// https://twitter.com/nullobject
// https://github.com/nullobject
//
// Copyright (c) 2020 Josh Bassett
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

`default_nettype none

module rygar_mc2p
(
    // Clocks
    input wire  clock_50_i,

    // Buttons
    //input wire [4:1]    btn_n_i,

    // SRAM (IS61WV20488FBLL-10)
    output wire [19:0]sram_addr_o  = 20'b00000000000000000000,
    inout wire  [15:0]sram_data_io   = 8'bzzzzzzzzbzzzzzzzz,
    output wire sram_we_n_o     = 1'b1,
    output wire sram_oe_n_o     = 1'b1,
        
    // SDRAM (W9825G6KH-6)
    output [12:0] SDRAM_A,
    output  [1:0] SDRAM_BA,
    inout  [15:0] SDRAM_DQ,
    output        SDRAM_DQMH,
    output        SDRAM_DQML,
    output        SDRAM_CKE,
    output        SDRAM_nCS,
    output        SDRAM_nWE,
    output        SDRAM_nRAS,
    output        SDRAM_nCAS,
    output        SDRAM_CLK,

    // PS2
    inout wire  ps2_clk_io        = 1'bz,
    inout wire  ps2_data_io       = 1'bz,
    inout wire  ps2_mouse_clk_io  = 1'bz,
    inout wire  ps2_mouse_data_io = 1'bz,

    // SD Card
    output wire sd_cs_n_o         = 1'bZ,
    output wire sd_sclk_o         = 1'bZ,
    output wire sd_mosi_o         = 1'bZ,
    input wire  sd_miso_i,

    // Joysticks
    output wire joy_clock_o       = 1'b1,
    output wire joy_load_o        = 1'b1,
    input  wire joy_data_i,
    output wire joy_p7_o          = 1'b1,

    // Audio
    output      AUDIO_L,
    output      AUDIO_R,
    input wire  ear_i,
    //output wire mic_o             = 1'b0,
    //  I2S
    output		SCLK,
    output		LRCLK,
    output		SDIN,	
	 
    // VGA
    output  [5:0] VGA_R,
    output  [5:0] VGA_G,
    output  [5:0] VGA_B,
    output        VGA_HS,
    output        VGA_VS,

    //STM32
    input wire  stm_tx_i,
    output wire stm_rx_o,
    output wire stm_rst_o           = 1'bz, // '0' to hold the microcontroller reset line, to free the SD card
   
    input         SPI_SCK,
    output        SPI_DO,
    input         SPI_DI,
    input         SPI_SS2,
    //output wire   SPI_nWAIT        = 1'b1, // '0' to hold the microcontroller data streaming

    //inout [31:0] GPIO,

    output LED                    = 1'b1 // '0' is LED on
);

//defaults
//assign GPIO = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign stm_rst_o    = 1'bZ;
assign LED = reset;
assign stm_rx_o = 1'bZ;

//no SRAM for this core
assign sram_we_n_o  = 1'b1;
assign sram_oe_n_o  = 1'b1;

//all the SD reading goes thru the microcontroller for this core
assign sd_cs_n_o = 1'bZ;
assign sd_sclk_o = 1'bZ;
assign sd_mosi_o = 1'bZ;

assign AUDIO_R = AUDIO_L;


assign SDRAM_CLK = clk_sdram;

wire joy1_up_i, joy1_down_i, joy1_left_i, joy1_right_i, joy1_p6_i, joy1_p9_i;
wire joy2_up_i, joy2_down_i, joy2_left_i, joy2_right_i, joy2_p6_i, joy2_p9_i;

//joystick_serial  joystick_serial 
//(
//    .clk_i           ( cen_12 ),
//    .joy_data_i      ( joy_data_i ),
//    .joy_clk_o       ( joy_clock_o ),
//    .joy_load_o      ( joy_load_o ),
//
//    .joy1_up_o       ( joy1_up_i ),
//    .joy1_down_o     ( joy1_down_i ),
//    .joy1_left_o     ( joy1_left_i ),
//    .joy1_right_o    ( joy1_right_i ),
//    .joy1_fire1_o    ( joy1_p6_i ),
//    .joy1_fire2_o    ( joy1_p9_i ),
//
//    .joy2_up_o       ( joy2_up_i ),
//    .joy2_down_o     ( joy2_down_i ),
//    .joy2_left_o     ( joy2_left_i ),
//    .joy2_right_o    ( joy2_right_i ),
//    .joy2_fire1_o    ( joy2_p6_i ),
//    .joy2_fire2_o    ( joy2_p9_i )
//);

joydecoder joystick_serial  (
    .clk          ( cen_12 ), 	//12000000/8 --> 8 = 2^(2+1) joydecoder div=2
    .joy_data     ( joy_data_i ),
    .joy_clk      ( joy_clock_o ),
    .joy_load     ( joy_load_o ),
	 .clock_locked ( locked ),

    .joy1up       ( joy1_up_i ),
    .joy1down     ( joy1_down_i ),
    .joy1left     ( joy1_left_i ),
    .joy1right    ( joy1_right_i ),
    .joy1fire1    ( joy1_p6_i ),
    .joy1fire2    ( joy1_p9_i ),

    .joy2up       ( joy2_up_i ),
    .joy2down     ( joy2_down_i ),
    .joy2left     ( joy2_left_i ),
    .joy2right    ( joy2_right_i ),
    .joy2fire1    ( joy2_p6_i ),
    .joy2fire2    ( joy2_p9_i )
); 


localparam CONF_STR = {
  "P,Rygar.dat;",
  "S,DAT,Alternative ROM...;",
  "O34,Scanlines,Off,25%,50%,75%;",
  "O5,Blend,Off,On;",
  "O7,Scandoubler,On,Off;",
  "O89,Lives,3,4,5,2;",
  "OA,Cabinet,Upright,Cocktail;",
  "OBC,Bonus Life,50K 200K 500K,100K 300K 600K,200K 500K,100K;",
  "ODE,Difficulty,Easy,Normal,Hard,Hardest;",
  "OF,Allow Continue,Yes,No;",
  "T0,Reset;"
};

////////////////////////////////////////////////////////////////////////////////
// CLOCKS
////////////////////////////////////////////////////////////////////////////////

wire clk_sys, clk_sdram;
wire cen_12;
wire locked;

pll pll
(
  .inclk0(clock_50_i),
  .c0(clk_sys),
  .c1(clk_sdram),
  .locked(locked)
);

////////////////////////////////////////////////////////////////////////////////
// HPS IO
////////////////////////////////////////////////////////////////////////////////

wire  [1:0] buttons;
wire [31:0] status;
wire        forced_scandoubler;

wire [24:0] ioctl_addr;
wire  [7:0] ioctl_data;
wire        ioctl_wr;
wire        ioctl_download;

wire [10:0] ps2_key;

wire  [8:0] joystick_0, joystick_1;
wire [15:0] joy = joystick_0 | joystick_1;

data_io #
(
    .STRLEN(($size(CONF_STR)>>3))
)
data_io
(
    .clk_sys        ( clk_sys      ),
    .SPI_SCK        ( SPI_SCK      ),
    .SPI_SS2        ( SPI_SS2      ),
    .SPI_DI         ( SPI_DI       ),
    .SPI_DO         ( SPI_DO       ),
    
    .data_in        ( osd_s & keys_s ),
    .conf_str       ( CONF_STR      ),
    .status         ( status        ),
    
    .ioctl_download ( ioctl_download  ),
    .ioctl_index    (   ),
    .ioctl_wr       ( ioctl_wr     ),
    .ioctl_addr     ( ioctl_addr   ),
    .ioctl_dout     ( ioctl_data   )
);


/*
hps_io #(.STRLEN($size(CONF_STR)>>3)) hps_io
(
  .clk_sys(clk_sys),
  .HPS_BUS(HPS_BUS),

  .conf_str(CONF_STR),

  .buttons(buttons),
  .status(status),
  .status_menumask(direct_video),
  .forced_scandoubler(forced_scandoubler),
  .gamma_bus(gamma_bus),
  .direct_video(direct_video),

  .ioctl_addr(ioctl_addr),
  .ioctl_dout(ioctl_data),
  .ioctl_wr(ioctl_wr),
  .ioctl_download(ioctl_download),

  .joystick_0(joystick_0),
  .joystick_1(joystick_1),

  .ps2_key(ps2_key)
);
*/

////////////////////////////////////////////////////////////////////////////////
// VIDEO
////////////////////////////////////////////////////////////////////////////////

wire [3:0] r, g, b;
wire       hsync, vsync;
wire       hblank, vblank;
wire direct_video_s = ~status[7] ^ direct_video;


mist_video #( .COLOR_DEPTH(4), .SD_HCNT_WIDTH(10) ) mist_video
(
    .clk_sys ( cen_12 ),
    .SPI_SCK ( SPI_SCK ),
    .SPI_SS3 ( SPI_SS2 ),
    .SPI_DI  ( SPI_DI  ),

    .R      ( ~(hblank | vblank) ? r : 4'b0000 ),
    .G      ( ~(hblank | vblank) ? g : 4'b0000 ),
    .B      ( ~(hblank | vblank) ? b : 4'b0000 ),
    .HSync  ( ~hsync ),
    .VSync  ( ~vsync ),

    .VGA_R  ( VGA_R  ),
    .VGA_G  ( VGA_G  ),
    .VGA_B  ( VGA_B  ),
    .VGA_HS ( VGA_HS ),
    .VGA_VS ( VGA_VS ),

    .rotate     ( {2'b00} ),
    .ce_divider ( 1'b1 ),
    .blend      ( status[5] ),
    .scandoubler_disable ( direct_video_s ),
    .scanlines  ( status[4:3] ),
    .osd_enable ( osd_enable )
);


/*
//test without the video module
// nao faz diverença, a 15khz continua oscilando
assign VGA_R = ~(hblank | vblank) ? { r, 1'b0 } : 4'b0000 ;
assign VGA_G = ~(hblank | vblank) ? { g, 1'b0 } : 4'b0000 ;
assign VGA_B = ~(hblank | vblank) ? { b, 1'b0 } : 4'b0000 ;
assign VGA_HS = ~hsync;
assign VGA_VS = ~vsync;
*/

////////////////////////////////////////////////////////////////////////////////
// SDRAM
////////////////////////////////////////////////////////////////////////////////

wire [22:0] sdram_addr;
wire [31:0] sdram_data;
wire        sdram_we;
wire        sdram_req;
wire        sdram_ack;
wire        sdram_valid;
wire [31:0] sdram_q;

sdram #(.CLK_FREQ(48.0)) sdram
(
  .reset(~locked),
  .clk(clk_sys),

  // controller interface
  .addr(sdram_addr),
  .data(sdram_data),
  .we(sdram_we),
  .req(sdram_req),
  .ack(sdram_ack),
  .valid(sdram_valid),
  .q(sdram_q),

  // SDRAM interface
  .sdram_a(SDRAM_A),
  .sdram_ba(SDRAM_BA),
  .sdram_dq(SDRAM_DQ),
  .sdram_cke(SDRAM_CKE),
  .sdram_cs_n(SDRAM_nCS),
  .sdram_ras_n(SDRAM_nRAS),
  .sdram_cas_n(SDRAM_nCAS),
  .sdram_we_n(SDRAM_nWE),
  .sdram_dqml(SDRAM_DQML),
  .sdram_dqmh(SDRAM_DQMH)
);



////////////////////////////////////////////////////////////////////////////////
// GAME
////////////////////////////////////////////////////////////////////////////////

//wire reset = status[0] | ioctl_download | ~btn_n_i[4];
wire reset = status[0] | ioctl_download;

wire [15:0] audio;

rygar rygar
(
  .reset(reset),
  .clk(clk_sys),
  .cen_12(cen_12),

  .joystick_1({2'b0, m_fireB, m_fireA, m_up, m_down, m_right, m_left}),
  .joystick_2({2'b0, m_fire2B, m_fire2A, m_up2, m_down2, m_right2, m_left2}),
  .start_1(btn_one_player),
  .start_2(btn_two_players),
  .coin_1(btn_coin),
  .coin_2(1'b0),

  .dip_allow_continue(~status[15]),
  .dip_bonus_life(status[12:11]),
  .dip_cabinet(~status[10]),
  .dip_difficulty(status[14:13]),
  .dip_lives(status[9:8]),

  .sdram_addr(sdram_addr),
  .sdram_data(sdram_data),
  .sdram_we(sdram_we),
  .sdram_req(sdram_req),
  .sdram_ack(sdram_ack),
  .sdram_valid(sdram_valid),
  .sdram_q(sdram_q),

  .ioctl_addr(ioctl_addr),
  .ioctl_data(ioctl_data),
  .ioctl_wr(ioctl_wr),
  .ioctl_download(ioctl_download),

  .hsync(hsync),
  .vsync(vsync),
  .hblank(hblank),
  .vblank(vblank),

  .r(r),
  .g(g),
  .b(b),

  .audio(audio)
);

dac #(
    .C_bits(16))
dac(
    .clk_i(clk_sys),
    .res_n_i(1),
    .dac_i({~audio[15],audio[14:0]}),
    .dac_o(AUDIO_L)
    );


//i2s audio
wire MCLK;

audio_top i2s
(
	.clk_50MHz(clock_50_i),
	.dac_MCLK (MCLK),
	.dac_LRCK (LRCLK),
	.dac_SCLK (SCLK),
	.dac_SDIN (SDIN),
//	.L_data   ({~audio[15],audio[14:0]}),
//	.R_data   ({~audio[15],audio[14:0]})
	.L_data   (audio[15:0]),
	.R_data   (audio[15:0])
);	 
	 
	 
	 
/*
assign sram_addr_o  = {7'b0000000, ioctl_addr[13:0]};
assign sram_data_io = (ioctl_wr) ? ioctl_data : 8'bzzzzzzzz;
assign sram_we_n_o  = (ioctl_addr>19'h7dfff & ioctl_wr) ? 1'b1 : 1'b0;
assign sram_oe_n_o  = 1'b1;
*/

//--------- ROM DATA PUMP ----------------------------------------------------
    
        reg [15:0] power_on_s   = 16'b1111111111111111;
        reg [7:0] osd_s = 8'b11111111;
        
        wire hard_reset = ~locked;
        
        //--start the microcontroller OSD menu after the power on
        always @(posedge clk_sys) 
        begin
        
                if (hard_reset == 1)
                    power_on_s = 16'b1111111111111111;
                else if (power_on_s != 0)
                begin
                    power_on_s = power_on_s - 1;
                    osd_s = 8'b00111111;
                end 
                    
                
                if (ioctl_download == 1 && osd_s == 8'b00111111)
                    osd_s = 8'b11111111;
            
        end 

//-----------------------



wire m_up, m_down, m_left, m_right, m_fireA, m_fireB, m_fireC, m_fireD, m_fireE, m_fireF, m_fireG;
wire m_up2, m_down2, m_left2, m_right2, m_fire2A, m_fire2B, m_fire2C, m_fire2D, m_fire2E, m_fire2F, m_fire2G;
wire m_tilt, m_coin1, m_coin2, m_coin3, m_coin4, m_one_player, m_two_players, m_three_players, m_four_players;

wire m_right4, m_left4, m_down4, m_up4, m_right3, m_left3, m_down3, m_up3;

// wire btn_one_player  = ~btn_n_i[1] | m_one_player;
// wire btn_two_players = ~btn_n_i[2] | m_two_players;
// wire btn_coin        = ~btn_n_i[3] | m_coin1;
wire btn_one_player  = m_one_player;
wire btn_two_players = m_two_players;
wire btn_coin        = m_coin1;

wire kbd_intr;
wire [7:0] kbd_scancode;
wire [7:0] keys_s;

//get scancode from keyboard
io_ps2_keyboard keyboard 
 (
  .clk       ( cen_12 ),
  .kbd_clk   ( ps2_clk_io ),
  .kbd_dat   ( ps2_data_io ),
  .interrupt ( kbd_intr ),
  .scancode  ( kbd_scancode )
);

wire [15:0]joy1_s;
wire [15:0]joy2_s;
wire [8:0]controls_s;
wire osd_enable;
wire direct_video;
wire [1:0]osd_rotate;

//translate scancode to joystick
//kbd_joystick #( .OSD_CMD    ( 3'b011 ), .USE_VKP( 1'b1), .CLK_SPEED(12000)) k_joystick
//(
//    .clk          ( cen_12 ),
//    .kbdint       ( kbd_intr ),
//    .kbdscancode  ( kbd_scancode ), 
//
//    .joystick_0   ({ joy1_p9_i, joy1_p6_i, joy1_up_i, joy1_down_i, joy1_left_i, joy1_right_i }),
//    .joystick_1   ({ joy2_p9_i, joy2_p6_i, joy2_up_i, joy2_down_i, joy2_left_i, joy2_right_i }),
//      
//    //-- joystick_0 and joystick_1 should be swapped
//    .joyswap      ( 0 ),
//
//    //-- player1 and player2 should get both joystick_0 and joystick_1
//    .oneplayer    ( 1 ),
//
//    //-- tilt, coin4-1, start4-1
//    .controls     ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),
//
//    //-- fire12-1, up, down, left, right
//
//    .player1      ( {m_fireG,  m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
//    .player2      ( {m_fire2G, m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} ),
//
//    .direct_video ( direct_video ),
//    .osd_rotate   ( osd_rotate ),
//
//    //-- keys to the OSD
//    .osd_o        ( keys_s ),
//    .osd_enable   ( osd_enable ),
//
//    //-- sega joystick
//    .sega_strobe  ( joy_p7_o )
//
//        
//);

kbd_joystick_ua #( .OSD_CMD ( 3'b011 ), .USE_VKP( 1'b1)) k_joystick
(
    .clk          ( cen_12 ), 
    .kbdint       ( kbd_intr ),
    .kbdscancode  ( kbd_scancode ), 

    .joystick_0   ({ joy1_p9_i, joy1_p6_i, joy1_up_i, joy1_down_i, joy1_left_i, joy1_right_i }),
    .joystick_1   ({ joy2_p9_i, joy2_p6_i, joy2_up_i, joy2_down_i, joy2_left_i, joy2_right_i }),
      
    //-- joystick_0 and joystick_1 should be swapped
    .joyswap      ( 0 ),

    //-- player1 and player2 should get both joystick_0 and joystick_1
    .oneplayer    ( 1 ),

    //-- tilt, coin4-1, start4-1
    .controls     ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),

    //-- fire12-1, up, down, left, right

    .player1      ( {m_fireG,  m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
    .player2      ( {m_fire2G, m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} ),

    .direct_video ( direct_video ),
    .osd_rotate   ( osd_rotate ),

    //-- keys to the OSD
    .osd_o        ( keys_s ),
    .osd_enable   ( osd_enable ),

    //-- sega joystick
    .sega_clk     ( hsync ),		
    .sega_strobe  ( joy_p7_o )
);

endmodule
