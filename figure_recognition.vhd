library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity figure_recognition is
    port (
        v_cnt  : in  std_logic_vector(3 downto 0);
        h_cnt1 : in  std_logic_vector(3 downto 0);
        h_cnt2 : in  std_logic_vector(3 downto 0);
        h1     : in  std_logic;
        h2     : in  std_logic;
        figure : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of figure_recognition is

begin

    process(v_cnt, h_cnt1, h_cnt2, h1, h2)
    begin
        case (v_cnt & h_cnt1 & h_cnt2) is
            when "001000100010" => figure <= "0000";
            when "000100010001" => figure <= "0001";
            when "001000100001" => figure <= "0100";
            when "001100010010" =>
                case h1 is
                    when '0' => figure <= "0011";
                    when '1' => figure <= "0110";
                end case;
            when "001000010001" => figure <= "0111";
            when "001100100010" => figure <= "1000";
            when "001100100001" => figure <= "1001";
            when "001100010001" =>
                case std_logic_vector'(h1 & h2) is
                    when "01" => figure <= "0010";
                    when "00" => figure <= "0011";
                    when "10" => figure <= "0101";
                    when others => figure <= "1111";
                end case;
            when others => figure <= "1111";
        end case;
    end process;

end architecture;