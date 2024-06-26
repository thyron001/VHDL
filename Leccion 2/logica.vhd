library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logica is
  Port ( 
  sel: in std_logic_vector(3 downto 0);
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  led_resultado: out std_logic_vector(2 downto 0)
  );
end logica;

architecture Behavioral of logica is

begin

process(sel, a, b)
begin
        case sel(3 downto 0) is
        when "1000" =>
        led_resultado <= not a;
        when "1001" =>
        led_resultado <= not b;
        when "1010" =>
        led_resultado <= a and b;
        when "1011" =>
        led_resultado <= a or b;
        when "1100" =>
        led_resultado <= a nand b;
        when "1101" =>
        led_resultado <= a nor b;
        when "1110" =>
        led_resultado <= a xor b;
        when "1111" =>
        led_resultado <= a xnor b;
        when others =>
        led_resultado <= "000";
    end case;
end process;

end Behavioral;
