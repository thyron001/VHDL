----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2024 11:03:06 AM
-- Design Name: 
-- Module Name: exameninterciclo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exameninterciclo is
Port ( 
    clk_in: in std_logic;
    led1s: out std_logic;
    led1_2s: out std_logic;
    botonC: in std_logic;
    botonL: in std_logic;
    inp_switches: in std_logic_vector(15 downto 0);
    act_display : out std_logic_vector(3 downto 0);
    display_7_segmentos: out std_logic_vector(6 downto 0)
);
end exameninterciclo;

architecture Behavioral of exameninterciclo is

signal contador_1s: integer := 0;
signal contador_05s: integer := 0;
signal contador_1ms: integer := 0;
signal senal_segundo: std_logic;
signal senal_mediosegundo: std_logic;
signal senal_1ms: std_logic;
signal contador_025s: integer := 0;
signal senal_025s: std_logic;
signal parpadeo: integer := 0;
signal indicador: integer := 0;
signal senal_10s: std_logic;
signal contador_10s: integer := 0;

signal contador_led: integer := 0;
signal BCD: integer := 0;

signal posicion_led : integer := 0;

signal digito_1: integer := 0;
signal digito_2: integer := 0;
signal digito_3: integer := 0;
signal digito_4: integer := 0;
------------------------------------------
--Primera parte
begin
--Generar la senal de 1s
process (clk_in)
begin
if rising_edge(clk_in) then
    if contador_1s < 50_000_000 then
        contador_1s <= contador_1s + 1;
    else
        senal_segundo <= not senal_segundo;
        contador_1s <= 0;
    end if;
end if;
end process;

led1s <= senal_segundo;

--Generar la senal de medio segundo
process (clk_in)
begin
if rising_edge(clk_in) then
    if contador_05s < 25_000_000 then
        contador_05s <= contador_05s + 1;
    else
        senal_mediosegundo <= not senal_mediosegundo;
        contador_05s <= 0;
    end if;
end if;
end process;
led1_2s <= senal_mediosegundo;
------------------------------------------
--Segunda parte

process(senal_mediosegundo)
begin
    if rising_edge(senal_mediosegundo) then
        if botonC = '1' then
        case inp_switches(3 downto 0) is
        when "0000" =>
        digito_1 <= 0;
        when "0001" =>
        digito_1 <= 1;
        when "0010" =>
        digito_1 <= 2;
        when "0011" =>
        digito_1 <= 3;
        when "0100" =>
        digito_1 <= 4;
        when "0101" =>
        digito_1 <= 5;
        when "0110" =>
        digito_1 <= 6;
        when "0111" =>
        digito_1 <= 7;
        when "1000" =>
        digito_1 <= 8;
        when "1001" =>
        digito_1 <= 9;
        when "1010" =>
        digito_1 <= 10;
        when "1011" =>
        digito_1 <= 11;
        when "1100" =>
        digito_1 <= 12;
        when "1101" =>
        digito_1 <= 13;
        when "1110" =>
        digito_1 <= 14;
        when "1111" =>
        digito_1 <= 15;
        when others =>
        digito_1 <= 0;
    end case;
    
    case inp_switches(7 downto 4) is
        when "0000" =>
        digito_2 <= 0;
        when "0001" =>
        digito_2 <= 1;
        when "0010" =>
        digito_2 <= 2;
        when "0011" =>
        digito_2 <= 3;
        when "0100" =>
        digito_2 <= 4;
        when "0101" =>
        digito_2 <= 5;
        when "0110" =>
        digito_2 <= 6;
        when "0111" =>
        digito_2 <= 7;
        when "1000" =>
        digito_2 <= 8;
        when "1001" =>
        digito_2 <= 9;
        when "1010" =>
        digito_2 <= 10;
        when "1011" =>
        digito_2 <= 11;
        when "1100" =>
        digito_2 <= 12;
        when "1101" =>
        digito_2 <= 13;
        when "1110" =>
        digito_2 <= 14;
        when "1111" =>
        digito_2 <= 15;
        when others =>
        digito_2 <= 0;
    end case;
    
    case inp_switches(11 downto 8) is
        when "0000" =>
        digito_3 <= 0;
        when "0001" =>
        digito_3 <= 1;
        when "0010" =>
        digito_3 <= 2;
        when "0011" =>
        digito_3 <= 3;
        when "0100" =>
        digito_3 <= 4;
        when "0101" =>
        digito_3 <= 5;
        when "0110" =>
        digito_3 <= 6;
        when "0111" =>
        digito_3 <= 7;
        when "1000" =>
        digito_3 <= 8;
        when "1001" =>
        digito_3 <= 9;
        when "1010" =>
        digito_3 <= 10;
        when "1011" =>
        digito_3 <= 11;
        when "1100" =>
        digito_3 <= 12;
        when "1101" =>
        digito_3 <= 13;
        when "1110" =>
        digito_3 <= 14;
        when "1111" =>
        digito_3 <= 15;
        when others =>
        digito_3 <= 0;
    end case;
         
    case inp_switches(15 downto 12) is
        when "0000" =>
        digito_4 <= 0;
        when "0001" =>
        digito_4 <= 1;
        when "0010" =>
        digito_4 <= 2;
        when "0011" =>
        digito_4 <= 3;
        when "0100" =>
        digito_4 <= 4;
        when "0101" =>
        digito_4 <= 5;
        when "0110" =>
        digito_4 <= 6;
        when "0111" =>
        digito_4 <= 7;
        when "1000" =>
        digito_4 <= 8;
        when "1001" =>
        digito_4 <= 9;
        when "1010" =>
        digito_4 <= 10;
        when "1011" =>
        digito_4 <= 11;
        when "1100" =>
        digito_4 <= 12;
        when "1101" =>
        digito_4 <= 13;
        when "1110" =>
        digito_4 <= 14;
        when "1111" =>
        digito_4 <= 15;
        when others =>
        digito_4 <= 0;
    end case;
        
        elsif botonL = '1' then
            if posicion_led = 3 then
                posicion_led <= 0;
            elsif posicion_led = 0  and indicador = 0 then
                posicion_led <= 0 ;
                indicador <= 1;
            else
                posicion_led <= posicion_led + 1;
            end if;
        end if;
    end if;
end process;

--Generar la senal de 1ms (tasa de refresco de los LEDs)
process (clk_in)
begin
if rising_edge(clk_in) then
    if contador_1ms < 50_000 then
        contador_1ms <= contador_1ms + 1;
    else
        senal_1ms <= not senal_1ms;
        contador_1ms <= 0;
    end if;
end if;
end process;

process (senal_1ms)
begin
if (senal_1ms'event and senal_1ms = '1') then
    if contador_led < 3 then
            contador_led <= contador_led + 1;
        else
            contador_led <= 0;
        end if;
 end if;
end process;


process (contador_led)
begin
    if contador_led = 0 then
        BCD <= digito_1;
        act_display <= "1110";
        if posicion_led = 0 and indicador = 1 then
            BCD <= digito_1;
            act_display <= "111" & (senal_025s and senal_10s);
        end if;
    elsif contador_led = 1 then
        BCD <= digito_2;
        act_display <= "1101";
        if posicion_led = 1 and indicador = 1 then
            BCD <= digito_2;
            act_display <= "11" & (senal_025s and senal_10s) & "1";
        end if;
    elsif contador_led = 2 then
        BCD <= digito_3 ;
        act_display <= "1011";
        if posicion_led = 2 and indicador = 1 then
            BCD <= digito_3 ;
            act_display <= "1" & (senal_025s and senal_10s) & "11";
        end if;
    else
        BCD <= digito_4 ;
        act_display <= "0111";
        if posicion_led = 3 and indicador = 1 then
            BCD <= digito_4 ;
            act_display <= (senal_025s and senal_10s) & "111";
        end if;
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
 ---------------------------------------------------------------
 --Parte 3
 
--Reloj de 0.25s
process (clk_in)
    begin
        if (rising_edge (clk_in)) then
          if contador_025s < 12_500_000 then
            contador_025s <= contador_025s + 1;
          else
            contador_025s <= 1;
            senal_025s <= not senal_025s;
          end if;
        end if;
end process; 
 
process (clk_in)
    begin
        if (rising_edge (clk_in)) then
          if contador_10s < 500_000_000 then
            contador_10s <= contador_10s + 1;
          else
            senal_10s <= not senal_10s;
          end if;
        end if;
end process; 
 
end Behavioral;


