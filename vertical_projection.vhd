`timescale 1ns / 1ps

module vertical_projection(
	input				clk,                // ����ʱ��
	input				reset,              // ��λ�ź�
	input				vsync,              // ֡ͬ��
	input				href,               // �вο�
	input				clken,              // ������Ч�ź�
	input				bin,                // ����Ķ�ֵ��bit�źţ���ɫΪ1����ɫΪ0��

    output reg [10:0] 	line_left1,		    // ���ֵ����ҿ���
    output reg [10:0] 	line_right1,
    output reg [10:0]   line_left2,
    output reg [10:0]   line_right2,
    output reg [10:0]   line_left3,
    output reg [10:0]   line_right3,
    output reg [10:0]   line_left4,
    output reg [10:0]   line_right4
);

	parameter	DISPLAY_WIDTH  = 10'd640;
	parameter	DISPLAY_HEIGHT = 10'd480;

    /*********************
        ������Ĵ�������
    *********************/
    
    reg [10:0]  	x_cnt;           // �г�����
    reg [10:0]      y_cnt;
    reg [10:0]  	reg_x_cnt;       // �г������Ĵ�
    reg [10:0]      reg_y_cnt;

    reg  		    ram_wr_ena;
    wire [9:0] 	    ram_wr_data;
    wire [9:0] 	    ram_rd_data;

    reg             reg_bin;        // �Ĵ�bit�ź�

    reg [9:0]       rd_data1;       // �������źżĴ���������
    reg [9:0]       rd_data2;
    reg [9:0]       rd_data3;
    reg [9:0]       rd_data4;
    reg [9:0]       rd_data5;
    reg [9:0]       rd_data6;
    reg [9:0]       rd_data7;

    reg [10:0]      leftline1;      // �Ĵ����ҿ���
    reg [10:0]      rightline1;
    reg [10:0]      leftline2;
    reg [10:0]      rightline2;
    reg [10:0]      leftline3;
    reg [10:0]      rightline3;
    reg [10:0]      leftline4;
    reg [10:0]      rightline4;
    reg [10:0]      lastposline;
    reg [10:0]      lastnegline;
    
    reg [3:0]       posedge_cnt;    // �����ؼ���
    reg [3:0]       negedge_cnt;    // �½��ؼ���

    // ����Ķ�ֵ���źŴ�һ�� ����д��ram
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            reg_bin <= 0;
        else
            reg_bin <= bin;
    end

    // ���г�����ֱ��������ͶӰ    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            begin
                x_cnt <= 10'd0;
                y_cnt <= 10'd0;
            end
        else
            if(vsync == 0)
            begin
                x_cnt <= 10'd0;
                y_cnt <= 10'd0;
            end
            else if(clken) 
            begin
                if(x_cnt < DISPLAY_WIDTH - 1) 
                begin
                    x_cnt <= x_cnt + 1'b1;
                    y_cnt <= y_cnt;
                end
                else 
                begin
                    x_cnt <= 10'd0;
                    y_cnt <= y_cnt + 1'b1;
                end
            end
    end

    // �г������Ĵ�һ��ʱ������ ����д
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            reg_x_cnt <= 10'd0;
            reg_y_cnt <= 10'd0;
        end
        else 
        begin
            reg_x_cnt <= x_cnt;
            reg_y_cnt <= y_cnt;
        end
    end
    
    // ����ʹ���źŴ�һ�� �ӳ�����д��    
    always @ (posedge clk or posedge reset) 
    begin
        if(reset)
            ram_wr_ena <= 1'b0;
        else 
            ram_wr_ena <= clken;
    end

    // �µ�һ֡��ʼʱ ������е�ram��Ϣ
    assign ram_wr_data = (y_cnt == 10'd0) ? 10'd0 : (ram_rd_data + reg_bin);
        
    ram_vertical_projection ram_ver (
      .clka(clk),
       .ena(1),
      .wea(ram_wr_ena),
      .addra(reg_x_cnt),
      .dina(ram_wr_data),
      .clkb(clk),
      .addrb(x_cnt),
      .doutb(ram_rd_data)
    );
    
    // �Ĵ�3�� ���ں����ж������½���
    always @ (posedge clk or posedge reset) 
    begin
        if(reset || vsync == 0) 
        begin
            rd_data1 <= 10'd0;
            rd_data2 <= 10'd0;
            rd_data3 <= 10'd0;
            rd_data4 <= 10'd0;
            rd_data5 <= 10'd0;
            rd_data6 <= 10'd0;
            rd_data7 <= 10'd0;
        end
        else if(clken) 
        begin
            rd_data1 <= ram_rd_data;
            rd_data2 <= rd_data1;
            rd_data3 <= rd_data2;
            rd_data4 <= rd_data3;
            rd_data5 <= rd_data4;
            rd_data6 <= rd_data5;
            rd_data7 <= rd_data6;
        end
    end
    
    always @ (posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            leftline1  <= 10'b0;
            leftline2  <= 10'b0;
            leftline3  <= 10'b0;
            leftline4  <= 10'b0;
            rightline1 <= 10'b0;
            rightline2 <= 10'b0;
            rightline3 <= 10'b0;
            rightline4 <= 10'b0;
            posedge_cnt <= 4'd0;
            negedge_cnt <= 4'd0;
        end
        else if(x_cnt == 1 && y_cnt == 1)
        begin
            leftline1  <= 10'b0;
            leftline2  <= 10'b0;
            leftline3  <= 10'b0;
            leftline4  <= 10'b0;
            rightline1 <= 10'b0;
            rightline2 <= 10'b0;
            rightline3 <= 10'b0;
            rightline4 <= 10'b0;
            posedge_cnt <= 4'd0;
            negedge_cnt <= 4'd0;
        end
        else if(clken) 
        begin
            // ���һ�п�ʼͳ�������½���
            if(y_cnt == DISPLAY_HEIGHT - 1'b1) 
            begin    
                if((rd_data7 == 10'd0) && (ram_rd_data > 10'd10)
                && (posedge_cnt == 0 || reg_x_cnt - lastposline > 10'd50))
                begin
                    posedge_cnt = posedge_cnt + 1;
                    lastposline <= reg_x_cnt - 2;
                    case(posedge_cnt)
                        4'd1 : leftline1  <= reg_x_cnt - 2;
                        4'd2 : leftline2  <= reg_x_cnt - 2;
                        4'd3 : leftline3  <= reg_x_cnt - 2;
                        4'd4 : leftline4  <= reg_x_cnt - 2;
                    endcase 
                end
                
                if((rd_data7 > 10'd10) && (ram_rd_data == 10'd0)
                && (negedge_cnt == 0 || reg_x_cnt - lastnegline > 10'd50))
                begin
                    negedge_cnt = negedge_cnt + 1;
                    lastnegline <= reg_x_cnt - 2;
                    case(negedge_cnt)
                        4'd1 : rightline1  <= reg_x_cnt + 2;
                        4'd2 : rightline2  <= reg_x_cnt + 2;
                        4'd3 : rightline3  <= reg_x_cnt + 2;
                        4'd4 : rightline4  <= reg_x_cnt + 2;
                    endcase            
                end
            end
        end
    end
    
    // һ֡д����Ϻ� �ٸ�������λ��
    always @ (posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            line_left1  <= 10'd0;
            line_right1 <= 10'd0;
            line_left2  <= 10'd0;
            line_right2 <= 10'd0;
            line_left3  <= 10'd0;
            line_right3 <= 10'd0;
            line_left4  <= 10'd0;
            line_right4 <= 10'd0;
        end
        else if(vsync == 0) 
        begin
            line_left1  <= leftline1;
            line_right1 <= rightline1;
            line_left2  <= leftline2;
            line_right2 <= rightline2;
            line_left3  <= leftline3;
            line_right3 <= rightline3;
            line_left4  <= leftline4;
            line_right4 <= rightline4;
        end  
    end

endmodule













