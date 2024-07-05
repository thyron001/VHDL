library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
  Port (
       selector : in std_logic_vector(3 downto 0);
       a, b     : in std_logic_vector(2 downto 0);
       logic   : out std_logic_vector(3 downto 0)
       );
end logic_unit;

architecture Behavioral of logic_unit is
begin

process(selector, a, b)
begin
    case selector is
        when "1000" =>
            logic <= "0" & NOT a;
        when "1001" =>
            logic <= "0" & NOT b;
        when "1010" =>
            logic <= "0" & (a AND b);
        when "1011" =>        
            logic <= "0" & (a OR b);
        when "1100" =>
            logic <= "0" & (a NAND b);
        when "1101" =>
            logic <= "0" & (a NOR b);
        when "1110" =>
            logic <= "0" & (a XOR b);
        when "1111" =>
            logic <= "0" & (a XNOR b);
        when others =>
            logic <= (others => '0');
    end case; 
end process;

end Behavioral;

