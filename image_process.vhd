LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY image_process IS
   PORT (
      clk            : IN STD_LOGIC;
      reset          : IN STD_LOGIC;
      href           : IN STD_LOGIC;
      vsync          : IN STD_LOGIC;
      clken          : IN STD_LOGIC;
      rgb            : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      bin            : OUT STD_LOGIC;
      post_href      : OUT STD_LOGIC;
      post_vsync     : OUT STD_LOGIC;
      post_clken     : OUT STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      data_out_addr  : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
   );
END image_process;

ARCHITECTURE behavior OF image_process IS
   COMPONENT binarization IS

      PORT (
         clk            : IN STD_LOGIC;
         reset          : IN STD_LOGIC;
         org_href       : IN STD_LOGIC;
         org_vsync      : IN STD_LOGIC;
         org_clken      : IN STD_LOGIC;
         grey           : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         bin            : OUT STD_LOGIC;
         out_href       : OUT STD_LOGIC;
         out_vsync      : OUT STD_LOGIC;
         out_clken      : OUT STD_LOGIC
      );
   END COMPONENT;
   
   COMPONENT rgb2grey IS
      PORT (
         clk            : IN STD_LOGIC;
         reset          : IN STD_LOGIC;
         org_href       : IN STD_LOGIC;
         org_vsync      : IN STD_LOGIC;
         org_clken      : IN STD_LOGIC;
         org_rgb        : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
         grey           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         out_href       : OUT STD_LOGIC;
         out_vsync      : OUT STD_LOGIC;
         out_clken      : OUT STD_LOGIC
      );
   END COMPONENT;
   
   
   SIGNAL grey                : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL post_href0          : STD_LOGIC;
   SIGNAL post_href1          : STD_LOGIC;
   SIGNAL post_vsync0         : STD_LOGIC;
   SIGNAL post_vsync1         : STD_LOGIC;
   SIGNAL post_clken0         : STD_LOGIC;
   SIGNAL post_clken1         : STD_LOGIC;
   
   SIGNAL bin_tmp           : STD_LOGIC;
   SIGNAL data_out_addr_tmp : STD_LOGIC_VECTOR(18 DOWNTO 0);
   SIGNAL data_out_addr_tmp_next : STD_LOGIC_VECTOR(18 DOWNTO 0);

   
BEGIN

--   data_out_addr_tmp <= "0000000000000000000";
   data_out <= "111111111111" WHEN (bin_tmp = '1') ELSE
               "000000000000";
   post_href <= post_href1;
   post_vsync <= post_vsync1;
   post_clken <= post_clken1;
   
   bin <= bin_tmp;
   data_out_addr <= data_out_addr_tmp;

--   PROCESS (clk)
--   BEGIN
--      IF (clk'EVENT AND clk = '1') THEN
--        data_out_addr_tmp <= data_out_addr_tmp_next;
--       END IF;
--    END PROCESS;
   
--   PROCESS (post_vsync1)
--   BEGIN
--         IF (post_vsync1 = '0') THEN
--            data_out_addr_tmp_next <= "0000000000000000000";
--         ELSIF (post_clken1 = '1') THEN
--            data_out_addr_tmp_next <= data_out_addr_tmp + "0000000000000000001";
--         END IF;
     
--    END PROCESS;
   
   
   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (post_vsync1 = '0') THEN
            data_out_addr_tmp <= "0000000000000000000";
         ELSIF (post_clken1 = '1') THEN
            data_out_addr_tmp <= data_out_addr_tmp + "0000000000000000001";
         END IF;
      END IF;  
      
       bin <= bin_tmp;
       data_out_addr <= data_out_addr_tmp;
   END PROCESS;
   
   rgb2grey_inst : rgb2grey
      PORT MAP (
         clk        => clk,
         reset      => reset,
         org_href   => href,
         org_vsync  => vsync,
         org_clken  => clken,
         org_rgb    => rgb,
         grey       => grey,
         out_href   => post_href0,
         out_vsync  => post_vsync0,
         out_clken  => post_clken0
      );
   
   bin_inst : binarization
      PORT MAP (
         clk        => clk,
         reset      => reset,
         org_href   => post_href0,
         org_vsync  => post_vsync0,
         org_clken  => post_clken0,
         grey       => grey,
         bin        => bin_tmp,
         out_href   => post_href1,
         out_vsync  => post_vsync1,
         out_clken  => post_clken1
      );
      

   
END behavior;


