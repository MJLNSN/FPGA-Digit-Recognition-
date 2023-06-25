LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;


ENTITY display7 IS
   PORT (
      clk      : IN STD_LOGIC;
      num1     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      num2     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      num3     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      num4     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      enable   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      segment  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
   );
END display7;

ARCHITECTURE trans OF display7 IS
   
   SIGNAL cnt         : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";
   SIGNAL reg_ena     : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL num_current : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
   
   enable <= ("1111" & reg_ena);
   
   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         cnt <= cnt + "00000000000000001";
         
         CASE cnt(16 DOWNTO 15) IS
            WHEN "00" =>
               reg_ena <= "0111";
               num_current <= num1;
            WHEN "01" =>
               reg_ena <= "1011";
               num_current <= num2;
            WHEN "10" =>
               reg_ena <= "1101";
               num_current <= num3;
            WHEN "11" =>
               reg_ena <= "1110";
               num_current <= num4;
         END CASE;
      END IF;
   END PROCESS;
   
   
   PROCESS (num_current)
   BEGIN
      CASE num_current IS
         WHEN "0000" =>
            segment <= "1000000";
         WHEN "0001" =>
            segment <= "1111001";
         WHEN "0010" =>
            segment <= "0100100";
         WHEN "0011" =>
            segment <= "0110000";
         WHEN "0100" =>
            segment <= "0011001";
         WHEN "0101" =>
            segment <= "0010010";
         WHEN "0110" =>
            segment <= "0000010";
         WHEN "0111" =>
            segment <= "1111000";
         WHEN "1000" =>
            segment <= "0000000";
         WHEN "1001" =>
            segment <= "0010000";
         WHEN OTHERS =>
            segment <= "1111111";
      END CASE;
   END PROCESS;
   
   
END trans;


