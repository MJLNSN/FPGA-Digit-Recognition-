

LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;


ENTITY top IS
   PORT (
      clk               : IN STD_LOGIC;
      reset             : IN STD_LOGIC;
      
      camera_sio_c      : OUT STD_LOGIC;
      camera_sio_d      : INOUT STD_LOGIC;
      camera_ret        : OUT STD_LOGIC;
      camera_pwdn       : OUT STD_LOGIC;
      camera_xclk       : OUT STD_LOGIC;
      camera_pclk       : IN STD_LOGIC;
      camera_href       : IN STD_LOGIC;
      camera_vsync      : IN STD_LOGIC;
      camera_data       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      
      vga_rgb           : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      vga_hsync         : OUT STD_LOGIC;
      vga_vsync         : OUT STD_LOGIC;
      
      bluetooth_rxd     : IN STD_LOGIC;
      
      display7_enable   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      display7_segment  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      
      led               : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END top;

ARCHITECTURE trans OF top IS



-- changed
    COMPONENT clk_divider is
        PORT(
            clk_vga :out STD_LOGIC;
            clk_sccb :out STD_LOGIC;
            clk_in1 :in STD_LOGIC
        );
        END COMPONENT;
        
-- changed    
    COMPONENT figure_recognition is
        port (
            v_cnt  : in  std_logic_vector(3 downto 0);
            h_cnt1 : in  std_logic_vector(3 downto 0);
            h_cnt2 : in  std_logic_vector(3 downto 0);
            h1     : in  std_logic;
            h2     : in  std_logic;
            figure : out std_logic_vector(3 downto 0)
        );
    end COMPONENT;
    
    
--changed
      COMPONENT ram IS
          PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            clkb : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
      END COMPONENT;
      
--changed
      COMPONENT vga_sync is
        port (
            vga_clk : in std_logic; -- VGA clock
            reset : in std_logic; -- Reset signal
            hsync : out std_logic; -- Horizontal sync signal
            vsync : out std_logic; -- Vertical sync signal
            display_on : out std_logic; -- Display enable signal
            pixel_x : out std_logic_vector(10 downto 0); -- Current horizontal pixel
            pixel_y : out std_logic_vector(10 downto 0) -- Current vertical pixel
        );
    end COMPONENT;

--changed
    COMPONENT vga_control is
--        generic(
--            CLK_FREQ : positive := 50_000_000   --时钟频率
--        );
        port(
            org_rgb     : in  std_logic_vector(11 downto 0);   -- 原始rgb像素值
            display_on  : in  std_logic;                        -- 是否显示
            pixel_x     : in  std_logic_vector(10 downto 0);   -- 当前输出像素的横纵坐标
            pixel_y     : in  std_logic_vector(10 downto 0);
            ena         : in  std_logic;                        -- 是否显示框线
            line_left   : in  std_logic_vector(10 downto 0);   -- 各个数字的框线
            line_right  : in  std_logic_vector(10 downto 0);
            line_top    : in  std_logic_vector(10 downto 0);
            line_bottom : in  std_logic_vector(10 downto 0);
            line_left2  : in  std_logic_vector(10 downto 0);
            line_right2 : in  std_logic_vector(10 downto 0);
            line_top2   : in  std_logic_vector(10 downto 0);
            line_bottom2: in  std_logic_vector(10 downto 0);
            line_left3  : in  std_logic_vector(10 downto 0);
            line_right3 : in  std_logic_vector(10 downto 0);
            line_top3   : in  std_logic_vector(10 downto 0);
            line_bottom3: in  std_logic_vector(10 downto 0);
            line_left4  : in  std_logic_vector(10 downto 0);
            line_right4 : in  std_logic_vector(10 downto 0);
            line_top4   : in  std_logic_vector(10 downto 0);
            line_bottom4: in  std_logic_vector(10 downto 0);
            out_rgb     : out std_logic_vector(11 downto 0)
        );
    end COMPONENT;   
    
--changed   
    COMPONENT display7 is
    port (
        clk          : in  std_logic;
        num1         : in  std_logic_vector(3 downto 0); -- 右侧4位数字显示
        num2         : in  std_logic_vector(3 downto 0); -- 从左到右为num1 ~ num4
        num3         : in  std_logic_vector(3 downto 0); -- 非0~9则不亮灯
        num4         : in  std_logic_vector(3 downto 0);
        enable       : out std_logic_vector(7 downto 0); -- 八个数字的使能
        segment      : out std_logic_vector(6 downto 0)
    );
end COMPONENT; 


   COMPONENT camera_init_top IS
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         sio_c             : OUT STD_LOGIC;
         sio_d             : INOUT STD_LOGIC;
         pwdn              : OUT STD_LOGIC;
         ret               : OUT STD_LOGIC;
         xclk              : OUT STD_LOGIC
      );
   END COMPONENT;
   
   COMPONENT horizontal_projection IS
--      GENERIC (
--         DISPLAY_WIDTH     : INTEGER := 640;
--         DISPLAY_HEIGHT    : INTEGER := 480
--      );
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         vsync             : IN STD_LOGIC;
         href              : IN STD_LOGIC;
         clken             : IN STD_LOGIC;
         bin               : IN STD_LOGIC;
         line_left         : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right        : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_top          : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_bottom       : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
      );
   END COMPONENT;
   
   COMPONENT image_process IS
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         href              : IN STD_LOGIC;
         vsync             : IN STD_LOGIC;
         clken             : IN STD_LOGIC;
         rgb               : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
         bin               : OUT STD_LOGIC;
         post_href         : OUT STD_LOGIC;
         post_vsync        : OUT STD_LOGIC;
         post_clken        : OUT STD_LOGIC;
         data_out          : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
         data_out_addr     : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
      );
   END COMPONENT;
   
   COMPONENT camera_get_img IS
      PORT (
         pclk              : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         href              : IN STD_LOGIC;
         vsync             : IN STD_LOGIC;
         data_in           : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         data_out          : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
         pix_ena           : OUT STD_LOGIC;
         ram_out_addr      : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
      );
   END COMPONENT;
   
   COMPONENT bluetooth_uart_receive IS
     
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         rxd               : IN STD_LOGIC;
         data_out          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         data_flag         : OUT STD_LOGIC
      );
   END COMPONENT;
   
   COMPONENT intersection_count IS
--      GENERIC (
--         DISPLAY_WIDTH     : INTEGER := 640;
--         DISPLAY_HEIGHT    : INTEGER := 480
--      );
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         vsync             : IN STD_LOGIC;
         href              : IN STD_LOGIC;
         clken             : IN STD_LOGIC;
         bin               : IN STD_LOGIC;
         line_top          : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_bottom       : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_left         : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right        : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
         v_cnt             : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
         h_cnt1            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
         h_cnt2            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
         h1                : OUT STD_LOGIC;
         h2                : OUT STD_LOGIC
      );
   END COMPONENT;
   
   COMPONENT vertical_projection IS
--      GENERIC (
--         DISPLAY_WIDTH     : INTEGER := 640;
--         DISPLAY_HEIGHT    : INTEGER := 480
--      );
      PORT (
         clk               : IN STD_LOGIC;
         reset             : IN STD_LOGIC;
         vsync             : IN STD_LOGIC;
         href              : IN STD_LOGIC;
         clken             : IN STD_LOGIC;
         bin               : IN STD_LOGIC;
         line_left1        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right1       : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_left2        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right2       : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_left3        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right3       : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_left4        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
         line_right4       : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
      );
   END COMPONENT;
   
   
   SIGNAL clk_vga                : STD_LOGIC;
   SIGNAL clk_sccb               : STD_LOGIC;
   
   SIGNAL vga_display_on         : STD_LOGIC;
   SIGNAL vga_pix_x              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL vga_pix_y              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   
   SIGNAL mode_binarization      : STD_LOGIC;
   SIGNAL mode_frameline         : STD_LOGIC;
   
   SIGNAL camera_pix_ena         : STD_LOGIC;
   SIGNAL camera_data_out        : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL camera_data_addr       : STD_LOGIC_VECTOR(18 DOWNTO 0);
   
   SIGNAL post_href              : STD_LOGIC;
   SIGNAL post_vsync             : STD_LOGIC;
   SIGNAL post_clken             : STD_LOGIC;
   SIGNAL post_data_out          : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL post_data_addr         : STD_LOGIC_VECTOR(18 DOWNTO 0):= "0000000000000000000";
   SIGNAL bin                    : STD_LOGIC;
   
   SIGNAL ram_write_ena          : STD_LOGIC;
   SIGNAL ram_write_value        : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL ram_write_addr         : STD_LOGIC_VECTOR(18 DOWNTO 0);
   SIGNAL ram_read_ena           : STD_LOGIC;
   SIGNAL ram_read_value         : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL ram_read_addr          : STD_LOGIC_VECTOR(18 DOWNTO 0);
   
   SIGNAL bluetooth_data         : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL bluetooth_flag         : STD_LOGIC;
   
   SIGNAL line_left              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_left2             : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_left3             : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_left4             : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_right             : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_right2            : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_right3            : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_right4            : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_top               : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_top2              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_top3              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_top4              : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_bottom            : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_bottom2           : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_bottom3           : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL line_bottom4           : STD_LOGIC_VECTOR(10 DOWNTO 0);
   
   SIGNAL intersection_v         : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1        : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h2        : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_pst    : STD_LOGIC;
   SIGNAL intersection_h2_pst    : STD_LOGIC;
   SIGNAL intersection_v_2       : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_2      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h2_2      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_pst_2  : STD_LOGIC;
   SIGNAL intersection_h2_pst_2  : STD_LOGIC;
   SIGNAL intersection_v_3       : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_3      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h2_3      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_pst_3  : STD_LOGIC;
   SIGNAL intersection_h2_pst_3  : STD_LOGIC;
   SIGNAL intersection_v_4       : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_4      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h2_4      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL intersection_h1_pst_4  : STD_LOGIC;
   SIGNAL intersection_h2_pst_4  : STD_LOGIC;
   
   SIGNAL display7_num1          : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL display7_num2          : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL display7_num3          : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL display7_num4          : STD_LOGIC_VECTOR(3 DOWNTO 0);
   -- X-HDL generated signals

   SIGNAL tmp1 : STD_LOGIC;
   SIGNAL xhdl10 : STD_LOGIC;
   SIGNAL xhdl11 : STD_LOGIC;
   SIGNAL xhdl12 : STD_LOGIC;
   SIGNAL xhdl13 : STD_LOGIC;
   SIGNAL xhdl14 : STD_LOGIC;
   SIGNAL xhdl15 : STD_LOGIC;
   SIGNAL xhdl16 : STD_LOGIC;
   SIGNAL xhdl17 : STD_LOGIC;
   
   -- Declare intermediate signals for referenced outputs
   SIGNAL camera_sio_c_xhdl2     : STD_LOGIC;
   SIGNAL camera_ret_xhdl1       : STD_LOGIC;
   SIGNAL camera_pwdn_xhdl0      : STD_LOGIC;
   SIGNAL camera_xclk_xhdl3      : STD_LOGIC;
   SIGNAL vga_rgb_xhdl7          : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL vga_hsync_xhdl6        : STD_LOGIC;
   SIGNAL vga_vsync_xhdl8        : STD_LOGIC;
   SIGNAL display7_enable_xhdl4  : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL display7_segment_xhdl5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
   
   signal tmp4 : std_logic_vector(3 downto 0);
   signal tmp19 : std_logic_vector(18 downto 0);
   signal tmp21 : std_logic_vector(20 downto 0);

   

BEGIN
   -- Drive referenced outputs
   camera_sio_c <= camera_sio_c_xhdl2;
   camera_ret <= camera_ret_xhdl1;
   camera_pwdn <= camera_pwdn_xhdl0;
   camera_xclk <= camera_xclk_xhdl3;
   vga_rgb <= vga_rgb_xhdl7;
   vga_hsync <= vga_hsync_xhdl6;
   vga_vsync <= vga_vsync_xhdl8;
   display7_enable <= display7_enable_xhdl4;
   display7_segment <= display7_segment_xhdl5;
   
   led <= bluetooth_data;
   
    tmp4 <= bluetooth_data(7 downto 4); 
    mode_binarization <= '1' when tmp4 = "1111" else '0';  
    tmp4 <= bluetooth_data(3 downto 0); 
    mode_frameline <= '1' when tmp4 = "1111" else '0'; 
   
   
--   mode_binarization <= to_stdlogic((bluetooth_data(7 DOWNTO 4) = "1111"));
--   mode_frameline <= to_stdlogic((bluetooth_data(3 DOWNTO 0) = "1111"));
   
   ram_write_value <= post_data_out WHEN (mode_binarization = '1') ELSE
                      camera_data_out;
   ram_write_addr <= post_data_addr WHEN (mode_binarization = '1') ELSE
                     camera_data_addr;
   ram_write_ena <= post_clken WHEN (mode_binarization = '1') ELSE
                    camera_pix_ena;
                    
--    assign ram_read_addr = vga_display_on ? (vga_pix_y * 640 + vga_pix_x) : 12'b0

    tmp21 <= (vga_pix_y) * "1010000000" + vga_pix_x;
   ram_read_addr <= tmp21(18 downto 0) WHEN (vga_display_on = '1') ELSE
                    "0000000000000000000";
   
   
   
   clk_div : clk_divider
      PORT MAP (
         clk_in1   => clk,
         clk_vga   => clk_vga,
         clk_sccb  => clk_sccb
      );
   
   
   
   bluetooth : bluetooth_uart_receive
      PORT MAP (
         clk        => clk,
         reset      => reset,
         rxd        => bluetooth_rxd,
         data_out   => bluetooth_data,
         data_flag  => bluetooth_flag
      );
   
   
   
   camera_init : camera_init_top
      PORT MAP (
         clk    => clk_sccb,
         reset  => reset,
         sio_c  => camera_sio_c_xhdl2,
         sio_d  => camera_sio_d,
         pwdn   => camera_pwdn_xhdl0,
         ret    => camera_ret_xhdl1,
         xclk   => camera_xclk_xhdl3
      );
   
   
   
   get_img : camera_get_img
      PORT MAP (
         pclk          => camera_pclk,
         reset         => reset,
         href          => camera_href,
         vsync         => camera_vsync,
         data_in       => camera_data,
         data_out      => camera_data_out,
         pix_ena       => camera_pix_ena,
         ram_out_addr  => camera_data_addr
      );
   
   
   
   img_process : image_process
      PORT MAP (
         clk            => camera_pclk,
         reset          => reset,
         href           => camera_href,
         vsync          => camera_vsync,
         clken          => camera_pix_ena,
         rgb            => camera_data_out,
         bin            => bin,
         post_href      => post_href,
         post_vsync     => post_vsync,
         post_clken     => post_clken,
         data_out       => post_data_out,
         data_out_addr  => post_data_addr
      );
   
   
   
   tmp1 <= NOT(bin);
   ver_projection : vertical_projection
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_left1   => line_left,
         line_right1  => line_right,
         line_left2   => line_left2,
         line_right2  => line_right2,
         line_left3   => line_left3,
         line_right3  => line_right3,
         line_left4   => line_left4,
         line_right4  => line_right4
      );
   
   
   
   tmp1 <= NOT(bin);
   hor_projection : horizontal_projection
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_left    => line_left,
         line_right   => line_right,
         line_top     => line_top,
         line_bottom  => line_bottom
      );
   
   
   
   tmp1 <= NOT(bin);
   hor_projection2 : horizontal_projection
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_left    => line_left2,
         line_right   => line_right2,
         line_top     => line_top2,
         line_bottom  => line_bottom2
      );
   
   
   
   tmp1 <= NOT(bin);
   hor_projection3 : horizontal_projection
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_left    => line_left3,
         line_right   => line_right3,
         line_top     => line_top3,
         line_bottom  => line_bottom3
      );
   
   
   
   tmp1 <= NOT(bin);
   hor_projection4 : horizontal_projection
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_left    => line_left4,
         line_right   => line_right4,
         line_top     => line_top4,
         line_bottom  => line_bottom4
      );
   
   
   
   tmp1 <= NOT(bin);
   count1 : intersection_count
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_top     => line_top,
         line_bottom  => line_bottom,
         line_left    => line_left,
         line_right   => line_right,
         v_cnt        => intersection_v,
         h_cnt1       => intersection_h1,
         h_cnt2       => intersection_h2,
         h1           => intersection_h1_pst,
         h2           => intersection_h2_pst
      );
   
   
   
   tmp1 <= NOT(bin);
   count2 : intersection_count
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_top     => line_top2,
         line_bottom  => line_bottom2,
         line_left    => line_left2,
         line_right   => line_right2,
         v_cnt        => intersection_v_2,
         h_cnt1       => intersection_h1_2,
         h_cnt2       => intersection_h2_2,
         h1           => intersection_h1_pst_2,
         h2           => intersection_h2_pst_2
      );
   
   
   
   tmp1 <= NOT(bin);
   count3 : intersection_count
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_top     => line_top3,
         line_bottom  => line_bottom3,
         line_left    => line_left3,
         line_right   => line_right3,
         v_cnt        => intersection_v_3,
         h_cnt1       => intersection_h1_3,
         h_cnt2       => intersection_h2_3,
         h1           => intersection_h1_pst_3,
         h2           => intersection_h2_pst_3
      );
   
   
   
   tmp1 <= NOT(bin);
   count4 : intersection_count
      PORT MAP (
         clk          => camera_pclk,
         reset        => reset,
         vsync        => post_vsync,
         href         => post_href,
         clken        => post_clken,
         bin          => tmp1,
         line_top     => line_top4,
         line_bottom  => line_bottom4,
         line_left    => line_left4,
         line_right   => line_right4,
         v_cnt        => intersection_v_4,
         h_cnt1       => intersection_h1_4,
         h_cnt2       => intersection_h2_4,
         h1           => intersection_h1_pst_4,
         h2           => intersection_h2_pst_4
      );
   
   
   
   fig_recogn : figure_recognition
      PORT MAP (
         v_cnt   => intersection_v,
         h_cnt1  => intersection_h1,
         h_cnt2  => intersection_h2,
         h1      => intersection_h1_pst,
         h2      => intersection_h2_pst,
         figure  => display7_num1
      );
   
   
   
   fig_recogn2 : figure_recognition
      PORT MAP (
         v_cnt   => intersection_v_2,
         h_cnt1  => intersection_h1_2,
         h_cnt2  => intersection_h2_2,
         h1      => intersection_h1_pst_2,
         h2      => intersection_h2_pst_2,
         figure  => display7_num2
      );
   
   
   
   fig_recogn3 : figure_recognition
      PORT MAP (
         v_cnt   => intersection_v_3,
         h_cnt1  => intersection_h1_3,
         h_cnt2  => intersection_h2_3,
         h1      => intersection_h1_pst_3,
         h2      => intersection_h2_pst_3,
         figure  => display7_num3
      );
   
   
   
   fig_recogn4 : figure_recognition
      PORT MAP (
         v_cnt   => intersection_v_4,
         h_cnt1  => intersection_h1_4,
         h_cnt2  => intersection_h2_4,
         h1      => intersection_h1_pst_4,
         h2      => intersection_h2_pst_4,
         figure  => display7_num4
      );
   
   
   
   ram_inst : ram
      PORT MAP (
         clka   => clk,
         wea(0)    => ram_write_ena,
         addra  => ram_write_addr,
         dina   => ram_write_value,
         clkb   => clk,
         enb    => '1',
         addrb  => ram_read_addr,
         doutb  => ram_read_value
      );
   
   
   
   vga_display : vga_sync
      PORT MAP (
         vga_clk     => clk_vga,
         reset       => reset,
         hsync       => vga_hsync_xhdl6,
         vsync       => vga_vsync_xhdl8,
         display_on  => vga_display_on,
         pixel_x     => vga_pix_x,
         pixel_y     => vga_pix_y
      );
   
   
   
   vga_ctrl : vga_control
      PORT MAP (
         org_rgb       => ram_read_value,
         display_on    => vga_display_on,
         pixel_x       => vga_pix_x,
         pixel_y       => vga_pix_y,
         ena           => mode_frameline,
         line_left     => line_left,
         line_left2    => line_left2,
         line_left3    => line_left3,
         line_left4    => line_left4,
         line_right    => line_right,
         line_right2   => line_right2,
         line_right3   => line_right3,
         line_right4   => line_right4,
         line_top      => line_top,
         line_top2     => line_top2,
         line_top3     => line_top3,
         line_top4     => line_top4,
         line_bottom   => line_bottom,
         line_bottom2  => line_bottom2,
         line_bottom3  => line_bottom3,
         line_bottom4  => line_bottom4,
         out_rgb       => vga_rgb_xhdl7
      );
   
   
   
   display7_seg : display7
      PORT MAP (
         clk      => clk,
         num1     => display7_num1,
         num2     => display7_num2,
         num3     => display7_num3,
         num4     => display7_num4,
         enable   => display7_enable_xhdl4,
         segment  => display7_segment_xhdl5
      );
   
END trans;



