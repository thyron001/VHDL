library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leccion2 is
  Port ( 
  clk : in std_logic ;
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  act_display : out std_logic_vector(3 downto 0);
  display_7_segmentos: out std_logic_vector(6 downto 0);
  led_resultado : out std_logic_vector(2 downto 0);
  
  sel: in std_logic_vector(3 downto 0)
  );
end leccion2;

architecture Behavioral of leccion2 is

signal contador_led: integer := 0;
signal BCD: integer:= 0;
constant CONTADOR1MS: integer := 50_000; 
signal clk_1ms : std_logic ;

type state_type is (arit, log);
signal PS, NS : state_type;

signal entero_a: integer := 0;
signal entero_b: integer := 0;
signal resultado_aritmetico: integer := 0;

--Declaracion de componentes
component divisor_frecuencia
        generic (
            divisor : integer
        );
        Port ( 
            clk_in  : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

component aritmetica
  Port (
    sel: in std_logic_vector(3 downto 0);
    a: in std_logic_vector(2 downto 0);
    b: in std_logic_vector(2 downto 0);
    resultado: out integer;
    entero_a : out integer;
    entero_b: out integer
  );
end component;

component logica is
  Port ( 
  sel: in std_logic_vector(3 downto 0);
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  led_resultado: out std_logic_vector(2 downto 0)
  );
end component;

begin

ins_aritmetica : aritmetica port map (sel => sel, a => a, b => b, resultado => resultado_aritmetico, entero_a => entero_a, entero_b => entero_b);
ins_logica : logica port map (sel => sel, a => a, b => b, led_resultado => led_resultado);
                
   
--Generar la senal de 1ms (tasa de refresco de los LEDs)
div1ms : divisor_frecuencia
        generic map (divisor => CONTADOR1MS)
        port map (clk_in => clk, clk_out => clk_1ms);


process (clk_1ms)
begin
if (clk_1ms'event and clk_1ms = '1') then
    if contador_led < 2 then
            contador_led <= contador_led + 1;
        else
            contador_led <= 0;
        end if;
 end if;
end process;

process (contador_led)
begin
    if contador_led = 0 then
        BCD <= entero_a;
        act_display <= "0111";

    elsif contador_led = 1 then
        BCD <= entero_b;
        act_display <= "1011";
            
    else
        BCD <= resultado_aritmetico;
        act_display <= "1110";
    end if;
    
end process;

with BCD select
display_7_segmentos <=
    "0000001" when 0,
    "1001111" when 1,
    "0010010" when 2,
    "0000110" when 3,
    "1001100" when 4,
    "0100100" when 5,
    "0100000" when 6,
    "0001111" when 7,
    "0000000" when 8,
    "0000100" when 9,    
    "0001000" when 10,
    "1100000" when 11,
    "0110001" when 12,
    "1000010" when 13,
    "0110000" when 14,
    "0111000" when 15,
    "1111111" when others;

end Behavioral;
