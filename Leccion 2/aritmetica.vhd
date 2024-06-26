library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aritmetica is
  Port (
    sel: in std_logic_vector(3 downto 0);
    a: in std_logic_vector(2 downto 0);
    b: in std_logic_vector(2 downto 0);
    resultado: out integer;
    entero_a : out integer;
    entero_b: out integer
  );
end aritmetica;

architecture Behavioral of aritmetica is
signal digito_a: integer := 0;
signal digito_b: integer := 0;
begin
--Asignar los valores de bits a variables
process(sel, a, b)
begin
        case a(2 downto 0) is
        when "000" =>
        digito_a <= 0;
        when "001" =>
        digito_a <= 1;
        when "010" =>
        digito_a <= 2;
        when "011" =>
        digito_a <= 3;
        when "100" =>
        digito_a <= 4;
        when "101" =>
        digito_a <= 5;
        when "110" =>
        digito_a <= 6;
        when "111" =>
        digito_a <= 7;
        when others =>
        digito_a <= 0;
    end case;
    
    case b(2 downto 0) is
        when "000" =>
        digito_b <= 0;
        when "001" =>
        digito_b <= 1;
        when "010" =>
        digito_b <= 2;
        when "011" =>
        digito_b <= 3;
        when "100" =>
        digito_b <= 4;
        when "101" =>
        digito_b <= 5;
        when "110" =>
        digito_b <= 6;
        when "111" =>
        digito_b <= 7;
        when others =>
        digito_b <= 0;
    end case;
    
    case sel(3 downto 0) is
        when "0000" =>
        resultado <= digito_a;
        when "0001" =>
        resultado <= digito_a + 1;
        when "0010" =>
        resultado <= digito_a - 1;
        when "0011" =>
        resultado <= digito_b;
        when "0100" =>
        resultado <= digito_b + 1;
        when "0101" =>
        resultado <= digito_b - 1;
        when "0110" =>
        resultado <= digito_a + digito_b;
        when "0111" =>
        resultado <= digito_a + digito_b;
        when others =>
        resultado <= 0;
    end case;
end process;

entero_a <= digito_a;
entero_b <= digito_b;

end Behavioral;
