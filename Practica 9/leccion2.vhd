library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leccion2 is
  Port ( 
  clk : in std_logic ;
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  act_display : out std_logic_vector(3 downto 0);
  display_7_segmentos: out std_logic_vector(6 downto 0);
  led_resultado : out std_logic_vector(3 downto 0);
  sel: in std_logic_vector(3 downto 0);
  cin: in std_logic
  );
end leccion2;

architecture Behavioral of leccion2 is

signal contador_led: integer := 0;
signal BCD: std_logic_vector(3 downto 0);
constant CONTADOR1MS: integer := 50_000; 
signal clk_1ms : std_logic ;

type state_type is (arit, log);
signal PS, NS : state_type;

signal resultado_aritmetico: std_logic_vector(3 downto 0);
signal resultado: std_logic_vector(3 downto 0);
signal resultado_led: std_logic_vector(3 downto 0);
signal resultado_bcd: std_logic_vector(7 downto 0);

signal mascara_anodo: std_logic_vector(3 downto 0);

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
    cin: in std_logic;
    resultado: out std_logic_vector(3 downto 0)
  );
end component;

component logica is
  Port ( 
  sel: in std_logic_vector(3 downto 0);
  a: in std_logic_vector(2 downto 0);
  b: in std_logic_vector(2 downto 0);
  led_resultado: out std_logic_vector(3 downto 0)
  );
end component;

component mux is
  Port (
    a, b: in std_logic_vector (3 downto 0);
    sel: in std_logic;
    x  : out std_logic_vector (3 downto 0)
   );
end component;

begin

ins_aritmetica : aritmetica port map (sel => sel, a => a, b => b, resultado => resultado_aritmetico, cin => cin);
ins_logica : logica port map (sel => sel, a => a, b => b, led_resultado => resultado_led);
multiplexor: mux port map (resultado_aritmetico, resultado_led, sel(3), resultado);          
   
--Generar la senal de 1ms (tasa de refresco de los LEDs)
div1ms : divisor_frecuencia
        generic map (divisor => CONTADOR1MS)
        port map (clk_in => clk, clk_out => clk_1ms);


process (clk_1ms)
begin
if (clk_1ms'event and clk_1ms = '1') then
    if contador_led < 3 then
            contador_led <= contador_led + 1;
        else
            contador_led <= 0;
        end if;
 end if;
end process;


process (clk)
    begin
        if rising_edge(clk) then
            if ( sel = "0---" ) then
                led_resultado <= "0000";
                mascara_anodo <= "0000";       
            else
                led_resultado <= resultado_led;
                mascara_anodo <= "1111"; 
            end if;
        end if;
    end process;



process (contador_led)
begin
    if contador_led = 0 then
        BCD <= "0" & a;
        act_display <= "0111" or mascara_anodo;

    elsif contador_led = 1 then
        BCD <= "0" & b;
        act_display <= "1011" or mascara_anodo;
    
    elsif contador_led = 2 then
        if (sel = "0101" and b = "000") or (sel = "0010" and a = "000") then
            BCD <= "1111"; 
        else
            BCD <= resultado_bcd(7 downto 4);    
        end if;
        
        act_display <= "1101" or mascara_anodo;
            
    else
        if (sel = "0101" and b = "000") or (sel = "0010" and a = "000") then
            BCD <= "0001"; 
        else
            BCD <= resultado_bcd(3 downto 0);  
        end if;
        act_display <= "1110" or mascara_anodo;
    end if;
    
end process;

process(clk)
begin
case resultado is
    when "0000" => resultado_bcd <= "00000000";
    when "0001" => resultado_bcd <= "00000001";
    when "0010" => resultado_bcd <= "00000010";
    when "0011" => resultado_bcd <= "00000011";
    when "0100" => resultado_bcd <= "00000100";
    when "0101" => resultado_bcd <= "00000101";
    when "0110" => resultado_bcd <= "00000110";
    when "0111" => resultado_bcd <= "00000111";
    when "1000" => resultado_bcd <= "00001000";
    when "1001" => resultado_bcd <= "00001001";
    when "1010" => resultado_bcd <= "00010000";
    when "1011" => resultado_bcd <= "00010001";
    when "1100" => resultado_bcd <= "00010010";
    when "1101" => resultado_bcd <= "00010011";
    when "1110" => resultado_bcd <= "00010100";
    when "1111" => resultado_bcd <= "00010101";
    when others => resultado_bcd <= "00000000";
end case;
end process;


with BCD select
display_7_segmentos <=
    "0000001" when "0000",
    "1001111" when "0001",
    "0010010" when "0010",
    "0000110" when "0011",
    "1001100" when "0100",
    "0100100" when "0101",
    "0100000" when "0110",
    "0001111" when "0111",
    "0000000" when "1000",
    "0000100" when "1001",
    "1111110" when "1111",
    "1111111" when others;

end Behavioral;
