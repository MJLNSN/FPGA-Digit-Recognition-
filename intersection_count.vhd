LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY intersection_count IS
   GENERIC (
      DISPLAY_WIDTH   : INTEGER := 640;
      DISPLAY_HEIGHT  : INTEGER := 480
   );
   
   PORT (
      clk             : IN STD_LOGIC;
      reset           : IN STD_LOGIC;
      vsync           : IN STD_LOGIC;
      href            : IN STD_LOGIC;
      clken           : IN STD_LOGIC;
      bin             : IN STD_LOGIC;
      line_top        : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom     : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_left       : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      v_cnt           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      h_cnt1          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      h_cnt2          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      h1              : OUT STD_LOGIC;
      h2              : OUT STD_LOGIC
   );
END intersection_count;

ARCHITECTURE trans OF intersection_count IS
   
   SIGNAL x_cnt      : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL y_cnt      : STD_LOGIC_VECTOR(10 DOWNTO 0);
   
   SIGNAL v_reg0     : STD_LOGIC;
   SIGNAL v_reg1     : STD_LOGIC;
   SIGNAL v_reg2     : STD_LOGIC;
   SIGNAL v_reg3     : STD_LOGIC;
   SIGNAL h1_reg0    : STD_LOGIC;
   SIGNAL h1_reg1    : STD_LOGIC;
   SIGNAL h1_reg2    : STD_LOGIC;
   SIGNAL h1_reg3    : STD_LOGIC;
   SIGNAL h2_reg0    : STD_LOGIC;
   SIGNAL h2_reg1    : STD_LOGIC;
   SIGNAL h2_reg2    : STD_LOGIC;
   SIGNAL h2_reg3    : STD_LOGIC;
   
   SIGNAL vcnt       : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL hcnt1      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL hcnt2      : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL h1_pst     : STD_LOGIC;
   SIGNAL h2_pst     : STD_LOGIC;
   
   SIGNAL fig_width  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_height : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv   : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv1  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv2  : STD_LOGIC_VECTOR(10 DOWNTO 0);

   SIGNAL width : STD_LOGIC_VECTOR(10 DOWNTO 0) := "01010000000";
   SIGNAL height : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00111100000";
   SIGNAL fig_vdiv_tmp   : STD_LOGIC_VECTOR(21 DOWNTO 0);

   SIGNAL fig_hdiv1_tmp1  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv2_tmp2  : STD_LOGIC_VECTOR(21 DOWNTO 0);

BEGIN
   fig_width <= line_right - line_left;
   fig_height <= line_bottom - line_top; -- all 10 downto 0
--    fig_vdiv   <= line_left + fig_width * 8 / 15; --0.100010001
--    fig_hdiv1  <= line_top + fig_height * 3 / 10; --0.010101010
--    fig_hdiv2  <= line_top + fig_height * 7 / 10; --0.101100110
   fig_vdiv_tmp <= fig_width * "10001000100";
   fig_vdiv <= line_left + fig_vdiv_tmp(21 downto 11); -- Shift right by 11 bits
   fig_hdiv1_tmp1 <= fig_height * "01001100110";
   fig_hdiv1 <= line_top + fig_hdiv1_tmp1(21 downto 11); -- Shift right by 11 bits
   fig_hdiv2_tmp2 <= fig_height * "10110011001";
   fig_hdiv2 <= line_top + fig_hdiv2_tmp2(21 downto 11); -- Shift right by 11 bits

   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         x_cnt <= "00000000000";
         y_cnt <= "00000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (vsync = '0') THEN
            x_cnt <= "00000000000";
            y_cnt <= "00000000000";
         ELSIF (clken = '1') THEN
            IF (x_cnt < width - 1) THEN
               x_cnt <= x_cnt + "00000000001";
               y_cnt <= y_cnt;
            ELSE
               x_cnt <= "00000000000";
               y_cnt <= y_cnt + "00000000001";
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         v_reg0 <= '0';
         v_reg1 <= '0';
         v_reg2 <= '0';
         v_reg3 <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (x_cnt = "00000000001" AND y_cnt = "00000000001") THEN
            v_reg0 <= '0';
            v_reg1 <= '0';
            v_reg2 <= '0';
            v_reg3 <= '0';
         ELSIF (clken = '1') THEN
            IF ((x_cnt = fig_vdiv) AND (y_cnt > line_top) AND (y_cnt < line_bottom)) THEN
               v_reg0 <= v_reg1;
               v_reg1 <= v_reg2;
               v_reg2 <= v_reg3;
               v_reg3 <= bin;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         h1_reg0 <= '0';
         h1_reg1 <= '0';
         h1_reg2 <= '0';
         h1_reg3 <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (x_cnt = "00000000001" AND y_cnt = "00000000001") THEN
            h1_reg0 <= '0';
            h1_reg1 <= '0';
            h1_reg2 <= '0';
            h1_reg3 <= '0';
         ELSIF (clken = '1') THEN
            IF ((y_cnt = fig_hdiv1) AND (x_cnt > line_left) AND (x_cnt < line_right)) THEN
               h1_reg0 <= h1_reg1;
               h1_reg1 <= h1_reg2;
               h1_reg2 <= h1_reg3;
               h1_reg3 <= bin;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         h2_reg0 <= '0';
         h2_reg1 <= '0';
         h2_reg2 <= '0';
         h2_reg3 <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (x_cnt = "00000000001" AND y_cnt = "00000000001") THEN
            h2_reg0 <= '0';
            h2_reg1 <= '0';
            h2_reg2 <= '0';
            h2_reg3 <= '0';
         ELSIF (clken = '1') THEN
            IF ((y_cnt = fig_hdiv2) AND (x_cnt > line_left) AND (x_cnt < line_right)) THEN
               h2_reg0 <= h2_reg1;
               h2_reg1 <= h2_reg2;
               h2_reg2 <= h2_reg3;
               h2_reg3 <= bin;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         vcnt <= "0000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((x_cnt = "00000000001") AND (y_cnt = "00000000001")) THEN
            vcnt <= "0000";
         ELSIF (clken = '1') THEN
            IF (v_reg0 = '0' AND v_reg1 = '0' AND v_reg2 = '0' AND v_reg3 = '1' AND (x_cnt = fig_vdiv) AND (y_cnt > line_top) AND (y_cnt < line_bottom)) THEN
               vcnt <= vcnt + "0001";
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         hcnt1 <= "0000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((x_cnt = "00000000001") AND (y_cnt = "00000000001")) THEN
            hcnt1 <= "0000";
         ELSIF (clken = '1') THEN
            IF (h1_reg0 = '0' AND h1_reg1 = '0' AND h1_reg2 = '0' AND h1_reg3 = '1' AND (y_cnt = fig_hdiv1) AND (x_cnt > line_left) AND (x_cnt < line_right)) THEN
               hcnt1 <= hcnt1 + "0001";
               IF (x_cnt < fig_vdiv) THEN
               h1_pst <= '1';
--               h1_pst <= to_stdlogic((x_cnt < fig_vdiv));
               ELSE
               h1_pst <= '0';
              END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         hcnt2 <= "0000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((x_cnt = "00000000001") AND (y_cnt = "00000000001")) THEN
            hcnt2 <= "0000";
         ELSIF (clken = '1') THEN
            IF (h2_reg0 = '0' AND h2_reg1 = '0' AND h2_reg2 = '0' AND h2_reg3 = '1' AND (y_cnt = fig_hdiv2) AND (x_cnt > line_left) AND (x_cnt < line_right)) THEN
               hcnt2 <= hcnt2 + "0001";
               IF (x_cnt < fig_vdiv) THEN
               h2_pst <= '1';
--               h2_pst <= to_stdlogic((x_cnt < fig_vdiv));
               ELSE
               h2_pst <= '0';
              END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         v_cnt <= "0000";
         h_cnt1 <= "0000";
         h_cnt2 <= "0000";
         h1 <= '0';
         h2 <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (vsync = '0') THEN
            v_cnt <= vcnt;
            h_cnt1 <= hcnt1;
            h_cnt2 <= hcnt2;
            h1 <= h1_pst;
            h2 <= h2_pst;
         END IF;
      END IF;
   END PROCESS;
   
   
END trans;