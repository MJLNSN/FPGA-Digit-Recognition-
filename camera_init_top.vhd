`timescale 1ns / 1ps

// ÉãÏñÍ·³õÊŒ»¯
module camera_init_top(
    input clk,      // 25MHzÊ±ÖÓ
    input reset,    // žŽÎ»ÐÅºÅ
    // ÒÔÏÂÊÇÓëÉãÏñÍ·ÏàÁ¬µÄ¹ÜœÅ
    output sio_c,
    inout  sio_d,
    output pwdn,
    output ret,
    output xclk
    );
    
    // pwdnžßµçÆœÓÐÐ§ retµÍµçÆœÓÐÐ§
    assign pwdn = 0;
    assign ret = 1;
    // sio_džß×èÌ¬
    pullup up (sio_d);
    // ž³žøxclkÊ±ÖÓÐÅºÅ    
    assign xclk = clk;
    
    wire cfg_ok, sccb_ok;
    wire [15: 0] data_sent;
    
    // ÊµÀý»¯ÅäÖÃÐŽÈëÄ£¿é
    camera_reg_cfg reg_cfg(
        .clk(clk),
        .reset(reset),
        .data_out(data_sent),
        .cfg_ok(cfg_ok),
        .sccb_ok(sccb_ok)
    );
    
    // ÊµÀý»¯sccb·¢ËÍÄ£¿é
    camera_sccb_sender sccb_sender(
        .clk(clk),
        .reset(reset),
        .sio_c(sio_c),
        .sio_d(sio_d),
        .cfg_ok(cfg_ok),
        .sccb_ok(sccb_ok),    
        .reg_addr(data_sent[15:8]),   
        .value(data_sent[7:0])      
    );
   
    
endmodule