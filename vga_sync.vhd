

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
port (
vga_clk : in std_logic; -- VGA clock
reset : in std_logic; -- Reset signal
hsync : out std_logic; -- Horizontal sync signal
vsync : out std_logic; -- Vertical sync signal
display_on : out std_logic; -- Display enable signal
pixel_x : out std_logic_vector(10 downto 0); -- Current horizontal pixel
pixel_y : out std_logic_vector(10 downto 0) -- Current vertical pixel
);
end entity vga_sync;

architecture rtl of vga_sync is
constant H_DISPLAY : integer := 640;    -- Visible horizontal pixels
constant H_L_BORDER : integer := 48;    -- Left border
constant H_R_BORDER : integer := 16;    -- Right border
constant H_SYNC : integer := 96;        -- Horizontal sync width
constant H_MAX : integer := H_DISPLAY + H_L_BORDER + H_R_BORDER + H_SYNC - 1;

constant V_DISPLAY : integer := 480;    -- Visible vertical pixels
constant V_T_BORDER : integer := 33;    -- Top border
constant V_B_BORDER : integer := 10;    -- Bottom border
constant V_SYNC : integer := 2;         -- Vertical sync width
constant V_MAX : integer := V_DISPLAY + V_T_BORDER + V_B_BORDER + V_SYNC - 1;

signal h_cnt : unsigned(10 downto 0);
signal v_cnt : unsigned(10 downto 0);
begin
-- Horizontal and vertical sync signals
hsync <= '0' when h_cnt < H_SYNC else '1';
vsync <= '0' when v_cnt < V_SYNC else '1';

-- Display enable signal
display_on <= '1' when
    h_cnt >= H_SYNC + H_L_BORDER and
    h_cnt < H_SYNC + H_L_BORDER + H_DISPLAY and
    v_cnt >= V_SYNC + V_T_BORDER and
    v_cnt < V_SYNC + V_T_BORDER + V_DISPLAY
else '0';

-- Current pixel coordinates
    pixel_x <= std_logic_vector(unsigned(h_cnt) - to_unsigned(H_SYNC + H_L_BORDER, h_cnt'length));
    pixel_y <= std_logic_vector(unsigned(v_cnt) - to_unsigned(V_SYNC + V_T_BORDER, v_cnt'length));
--pixel_y <= std_logic_vector(to_unsigned(unsigned(v_cnt) - V_SYNC - V_T_BORDER, 11));
--	assign pixel_x = h_cnt - H_SYNC - H_L_BORDER;
--	assign pixel_y = v_cnt - V_SYNC - V_T_BORDER;

-- VGA sync process
vga_sync_process : process(vga_clk)
begin
    if rising_edge(vga_clk) then
        if reset = '1' then
            h_cnt <= (others => '0');
            v_cnt <= (others => '0');
        else
            if h_cnt = H_MAX then
                h_cnt <= (others => '0');
                if v_cnt = V_MAX then
                    v_cnt <= (others => '0');
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end if;
end process vga_sync_process;
end architecture rtl;