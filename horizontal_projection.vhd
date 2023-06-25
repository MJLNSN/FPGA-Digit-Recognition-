LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY horizontal_projection IS
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
      line_left       : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_top        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom     : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
   );
END horizontal_projection;

ARCHITECTURE trans OF horizontal_projection IS
   
--   SIGNAL x_cnt       : STD_LOGIC_VECTOR(10 DOWNTO 0);
--   SIGNAL y_cnt       : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL x_cnt       : INTEGER;
   SIGNAL y_cnt       : INTEGER;
   SIGNAL tot         : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL tot1        : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL tot2        : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL tot3        : STD_LOGIC_VECTOR(9 DOWNTO 0);
   
   SIGNAL topline1    : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL bottomline1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
--   SIGNAL width : STD_LOGIC_VECTOR(10 DOWNTO 0) := "01010000000";
--   SIGNAL height : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00111100000";
BEGIN
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
           x_cnt <= 0;
           y_cnt <= 0;
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (vsync = '0') THEN
              x_cnt <= 0;
              y_cnt <= 0;
         ELSIF (clken = '1') THEN
            IF (x_cnt < DISPLAY_WIDTH - 1)   THEN
               x_cnt <= x_cnt + 1;
               y_cnt <= y_cnt;
            ELSE

                 x_cnt <= 0;
                 y_cnt <= y_cnt + 1;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         tot <= "0000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clken = '1') THEN
            IF (x_cnt = "00000000000") THEN
               tot <= "0000000000";
            
            ELSIF (x_cnt > line_left AND x_cnt < line_right) THEN
               tot <= tot + ("000000000" & bin);
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         tot1 <= "0000000000";
         tot2 <= "0000000000";
         tot3 <= "0000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clken = '1' AND x_cnt = DISPLAY_WIDTH - 1) THEN
            tot1 <= tot;
            tot2 <= tot1;
            tot3 <= tot2;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         topline1 <= "00000000000";
         bottomline1 <= "00000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clken = '1') THEN
            
--            IF (x_cnt = DISPLAY_WIDTH - 0b1) THEN
              IF (x_cnt = DISPLAY_WIDTH - 1) THEN
               IF ((tot3 = "0000000000") AND (tot > "0000001010")) THEN
                  topline1 <= y_cnt - "00000000011";
               END IF;
               
               IF ((tot3 > "0000001010") AND (tot = "0000000000")) THEN
                  bottomline1 <= y_cnt + "00000000011";
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         line_top <= "00000000000";
         line_bottom <= "00000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (vsync = '0') THEN
            line_top <= topline1;
            line_bottom <= bottomline1;
         END IF;
      END IF;
   END PROCESS;
   
   
END trans;


