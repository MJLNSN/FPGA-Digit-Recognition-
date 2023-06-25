

LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;


ENTITY rgb2grey IS
   PORT (
      clk        : IN STD_LOGIC;
      reset      : IN STD_LOGIC;
      org_href   : IN STD_LOGIC;
      org_vsync  : IN STD_LOGIC;
      org_clken  : IN STD_LOGIC;
      org_rgb    : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      grey       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      out_href   : OUT STD_LOGIC;
      out_vsync  : OUT STD_LOGIC;
      out_clken  : OUT STD_LOGIC
   );
END rgb2grey;

ARCHITECTURE trans OF rgb2grey IS
   
   SIGNAL data_r     : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL data_g     : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL data_b     : STD_LOGIC_VECTOR(7 DOWNTO 0);
   
   SIGNAL red_0      : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL green_0    : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL blue_0     : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL grey_0     : STD_LOGIC_VECTOR(15 DOWNTO 0);
   
   SIGNAL post_href  : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL post_vsync : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL post_clken : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
   data_r <= (org_rgb(11 DOWNTO 8) & "0000");
   data_g <= (org_rgb(7 DOWNTO 4) & "0000");
   data_b <= (org_rgb(3 DOWNTO 0) & "0000");
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         red_0 <= "0000000000000000";
         green_0 <= "0000000000000000";
         blue_0 <= "0000000000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
--         red_0 <= (("00000000" & data_r) * "01001101");
--         green_0 <= (("00000000" & data_g )* "10010110");
--         blue_0 <= (("00000000" & data_b )* "00011101");
         red_0 <= data_r * "01001101";
         green_0 <= data_g * "10010110";
         blue_0 <= data_b * "00011101";
--            red_0   <= std_logic_vector(unsigned(data_r) * 77);
--            green_0 <= std_logic_vector(unsigned(data_g) * 150);
--            blue_0  <= std_logic_vector(unsigned(data_b) * 29);

      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         grey_0 <= "0000000000000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         grey_0 <= red_0 + green_0 + blue_0;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         grey <= "00000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         grey <= grey_0(15 DOWNTO 8);
      END IF;
   END PROCESS;
   
   
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         post_href <= "000";
         post_vsync <= "000";
         post_clken <= "000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         post_href <= (post_href(1 DOWNTO 0) & org_href);
         post_vsync <= (post_vsync(1 DOWNTO 0) & org_vsync);
         post_clken <= (post_clken(1 DOWNTO 0) & org_clken);
      END IF;
   END PROCESS;
   
   
   out_href <= post_href(2);
   out_vsync <= post_vsync(2);
   out_clken <= post_clken(2);
   
END trans;


