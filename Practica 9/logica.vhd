library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logica is
  Port ( 
  sel: in std_logic_vector(3 downto 0);
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  led_resultado: out std_logic_vector(3 downto 0)
  );
end logica;

architecture Behavioral of logica is

signal resultado: std_logic_vector(2 downto 0);
signal resultado_final: std_logic_vector(3 downto 0);
begin

process(sel, a, b)
begin
        case sel(3 downto 0) is
        when "1000" =>
        resultado <= not a;
        when "1001" =>
        resultado <= not b;
        when "1010" =>
        resultado <= a and b;
        when "1011" =>
        resultado <= a or b;
        when "1100" =>
        resultado <= a nand b;
        when "1101" =>
        resultado <= a nor b;
        when "1110" =>
        resultado <= a xor b;
        when "1111" =>
        resultado <= a xnor b;
        when others =>
        resultado <= "000";
    end case;
    resultado_final <= "0" & resultado ;
    
end process;

led_resultado <= resultado_final;

end Behavioral;
