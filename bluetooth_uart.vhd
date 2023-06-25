
library ieee;
use ieee.std_logic_1164.all;

entity bluetooth_uart_receive is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        rxd         : in std_logic;
        data_out    : out std_logic_vector(7 downto 0);
        data_flag   : out std_logic
    );
end entity;

architecture rtl of bluetooth_uart_receive is
    -- System clock frequency
    constant CLK_FREQ      : integer := 100000000;
    -- UART baud rate
    constant UART_BPS      : integer := 9600;
    -- Counter value for one bit duration at the given baud rate
    constant BPS_CNT       : integer := CLK_FREQ / UART_BPS;
    
    -- Register for received data
    signal rxd_reg1        : std_logic;
    signal rxd_reg2        : std_logic;
    signal rxd_reg3        : std_logic;
    -- Start flag signal
    signal start_flag      : std_logic;
    signal clk_cnt         : std_logic_vector(14 downto 0);
    signal bit_cnt         : std_logic_vector(3 downto 0);
    -- 8-bit data transfer flag
    signal work_flag       : std_logic;
    signal rx_data         : std_logic_vector(7 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Assign 0xFF to data_out at every positive clock edge
--            data_out <= "11111111";
            data_out <= "11111111";

            data_flag <= '1';
        end if;
    end process;
    
    start_flag <= (not rxd_reg2) and rxd_reg3;
    
end architecture;