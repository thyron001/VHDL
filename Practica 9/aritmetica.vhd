library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aritmetica is
  Port (
    sel: in std_logic_vector(3 downto 0);
    a: in std_logic_vector(2 downto 0);
    b: in std_logic_vector(2 downto 0);
    resultado: out std_logic_vector(3 downto 0);
    cin: in std_logic
  );
end aritmetica;

architecture Behavioral of aritmetica is

component suma_palabras
  Port(
    a: in std_logic_vector(3 downto 0);
    b: in std_logic_vector(3 downto 0);
    resultado: out std_logic_vector(3 downto 0)
  );
end component;

signal resultado_suma_1_a     : std_logic_vector(3 downto 0);
signal resultado_resta_1_a    : std_logic_vector(3 downto 0);
signal resultado_suma_1_b     : std_logic_vector(3 downto 0);
signal resultado_resta_1_b    : std_logic_vector(3 downto 0);
signal resultado_suma         : std_logic_vector(3 downto 0);
signal resultado_suma_acarreo : std_logic_vector(3 downto 0);

signal acarreo_operacion      : std_logic_vector(3 downto 0);
signal a_4bits                : std_logic_vector(3 downto 0);
signal b_4bits                : std_logic_vector(3 downto 0);

begin

acarreo_operacion <= "000" & cin ;
a_4bits           <= "0" & a ;
b_4bits           <= "0" & b ;

suma_1_a     : suma_palabras port map (a => a_4bits , b => "0001", resultado => resultado_suma_1_a );
resta_1_a    : suma_palabras port map (a => a_4bits , b => "1111", resultado => resultado_resta_1_a);
suma_1_b     : suma_palabras port map (a => b_4bits , b => "0001", resultado => resultado_suma_1_b);
resta_1_b    : suma_palabras port map (a => b_4bits , b => "1111", resultado => resultado_resta_1_b);
suma         : suma_palabras port map (a => a_4bits , b => b_4bits , resultado => resultado_suma);
suma_acarreo : suma_palabras port map (a => resultado_suma, b => acarreo_operacion, resultado => resultado_suma_acarreo);

--Asignar los valores de bits a variables
process(sel, a, b)
begin
    case sel is
        when "0000" =>
            resultado <= a_4bits ;
        when "0001" => 
            resultado <= resultado_suma_1_a ;
        when "0010" =>
            resultado <= resultado_resta_1_a ;
        when "0011" =>
            resultado <= b_4bits ;
        when "0100" =>
            resultado <= resultado_suma_1_b ;
        when "0101" =>
            resultado <= resultado_resta_1_b ;
        when "0110" =>
            resultado <= resultado_suma ;
        when "0111" =>
            resultado <= resultado_suma_acarreo;
        when others => 
        resultado <= "0000";
    end case;
end process;

end Behavioral;
