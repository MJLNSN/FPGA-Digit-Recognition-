LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;


ENTITY camera_get_img IS
   PORT (
      pclk          : IN STD_LOGIC;
      reset         : IN STD_LOGIC;
      href          : IN STD_LOGIC;
      vsync         : IN STD_LOGIC;
      data_in       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      data_out      : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      pix_ena       : OUT STD_LOGIC;
      ram_out_addr  : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
   );
END camera_get_img;

ARCHITECTURE trans OF camera_get_img IS
   
   SIGNAL rgb565        : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
   SIGNAL bit_status    : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
   SIGNAL ram_next_addr : STD_LOGIC_VECTOR(18 DOWNTO 0);
   signal tmp2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
   
   PROCESS 
   BEGIN
      ram_next_addr <= "0000000000000000000";
      WAIT;
   END PROCESS;
   
   
   PROCESS (pclk)
   BEGIN
      IF (pclk'EVENT AND pclk = '1') THEN
         
         IF (vsync = '0') THEN
            ram_out_addr <= "0000000000000000000";
            ram_next_addr <= "0000000000000000000";
            bit_status <= "00";
         ELSE
            
            data_out <= (rgb565(15 DOWNTO 12) & rgb565(10 DOWNTO 7) & rgb565(4 DOWNTO 1));
            ram_out_addr <= ram_next_addr;
            pix_ena <= bit_status(1);
            
--            bit_status <= {bit_status[0], (href && !bit_status[0])};
            bit_status(1) <= bit_status(0);
            if (bit_status(0)='0') then
                bit_status(0) <= href and '1';
            else
                bit_status(0) <= href and '0';
            end if;

            rgb565 <= rgb565(7 DOWNTO 0) & data_in;
            IF (bit_status(1) = '1') THEN
               ram_next_addr <= ram_next_addr + "0000000000000000001";
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
   
END trans;




