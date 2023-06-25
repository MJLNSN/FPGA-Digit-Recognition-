

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- 二值化
ENTITY binarization IS
   GENERIC (
      -- 黑白的临界阈值
      threshold  : INTEGER := 50
   );
   PORT (
      clk        : IN STD_LOGIC;
      reset      : IN STD_LOGIC;
      org_href   : IN STD_LOGIC;
      org_vsync  : IN STD_LOGIC;
      org_clken  : IN STD_LOGIC;
      grey       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      bin        : OUT STD_LOGIC;
      out_href   : OUT STD_LOGIC;
      out_vsync  : OUT STD_LOGIC;
      out_clken  : OUT STD_LOGIC
   );
END binarization;

ARCHITECTURE behavior OF binarization IS
   SIGNAL flag : STD_LOGIC;
   
   -- 二值化处理  
BEGIN
   PROCESS (grey)
   BEGIN
      if unsigned(grey) > threshold then
         flag <= '1';
      else
         flag <= '0';
      end if;
   END PROCESS;

   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         bin <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         bin <= flag;
      END IF;
   END PROCESS;
   
  -- 延迟一个周期
   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         out_href <= '0';
         out_vsync <= '0';
         out_clken <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         out_href <= org_href;
         out_vsync <= org_vsync;
         out_clken <= org_clken;
      END IF;
   END PROCESS;
   
END behavior;