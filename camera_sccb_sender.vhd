


`timescale 1ns / 1ps

// ͨ��sccb���͸�����ͷ������Ϣ
module camera_sccb_sender(
    input               clk,        // ʱ�ӣ�25MHz
    input               reset,
    output reg          sio_c,
    inout               sio_d,
    input               cfg_ok,     // �����Ƿ�д�����
    output reg          sccb_ok,    // �Ƿ�׼���ö�ȡ�µ�8bit
    input [7:0]         reg_addr,   // Ҫд��ļĴ�����ַ
    input [7:0]         value       // Ҫд���ֵ
);
    
    // �ӻ���ַ
    parameter [7:0] slave_address = 8'h60;
    
    reg     [20:0]      cfg_cnt = 0;      // ������
    reg                 sio_d_ena;        // sio_d�Ƿ�����
    reg     [31:0]      data_temp;        // �ݴ����ݴ����
    
    initial sccb_ok <= 0;
    
    // ������ �൱�ڸ�clk�ٷ�Ƶ
    always @ (posedge clk)
    begin
        if(cfg_cnt == 0)
            cfg_cnt <= cfg_ok;
        else
            if(cfg_cnt[20:11] == 31)
                cfg_cnt <= 0;
            else
                cfg_cnt <= cfg_cnt + 1;
    end

    // sccb_ok�ź�Ϊ��ʱ����ʼ�µ�8bit�Ķ��� 
    always @ (posedge clk)
        sccb_ok = (cfg_cnt == 0) && (cfg_ok == 1);

    // sio_c��ֵ
    always @ (posedge clk) 
    begin
        // sio_cΪ�ߵ�ƽ�������ʼ�ź�
        if(cfg_cnt[20:11] == 0)
            sio_c <= 1;
        // ��ʼ�ź��������
        else if(cfg_cnt[20:11] == 1) 
        begin
            if(cfg_cnt[10:9] == 2'b11)
                sio_c <= 0;
            else
                sio_c <= 1;
        end 
        // ׼����������ź�
        else if(cfg_cnt[20:11] == 29)
        begin
            if(cfg_cnt[10:9] == 2'b00)
                sio_c <= 0;
            else
                sio_c <= 1;
        end 
        // sio_cΪ�ߵ�ƽ����������ź�
        else if(cfg_cnt[20:11] == 30 || cfg_cnt[20:11] == 31)
            sio_c <= 1;
        // ����ʱ��sio_cΪ���ȵ�ʱ������ һ��01�仯���sio_d�ϵ�һλ�ź�
        else 
        begin
            if(cfg_cnt[10:9] == 2'b00)
                sio_c <= 0;
            else if(cfg_cnt[10:9] == 2'b01)
                sio_c <= 1;
            else if(cfg_cnt[10:9] == 2'b10)
                sio_c <= 1;
            else if(cfg_cnt[10:9] == 2'b11)
                sio_c <= 0;
        end
    end

    // ��3λ��dont't careλ������̬
    always @ (posedge clk) begin
        if(cfg_cnt[20:11] == 10 || cfg_cnt[20:11] == 19 || cfg_cnt[20:11] == 28)
            sio_d_ena <= 0;
        else
            sio_d_ena <= 1;
    end
    
    // ��������ļ�����
    always @ (posedge clk) 
    begin
        if(reset)
            data_temp <= 32'hffffffff;
        else
        begin
            // ��ʼ��8bit���õ�װ��
            if(cfg_cnt == 0 && cfg_ok == 1)
                // ��ʼ�źţ��ӻ���ַ���Ĵ�����ַ�����ݣ������ź�
                // 1'bxΪdon't careλ
                data_temp <= {2'b10, slave_address, 1'bx, reg_addr, 1'bx, value, 1'bx, 3'b011};
            // ��Ƶ
            else if(cfg_cnt[10:0] == 0)
                // �����������
                data_temp <= {data_temp[30:0], 1'b1};
        end
    end
    
    // ������ʱΪ��̬�ŵĸ���̬
    assign sio_d = sio_d_ena ? data_temp[31] : 1'bz;
    
endmodule
