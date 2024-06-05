----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2024 10:56:06 AM
-- Design Name: 
-- Module Name: leccion1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity leccion1 is
Port (
inp_switches_1: in std_logic_vector(3 downto 0);
inp_switches_2: in std_logic_vector(3 downto 0);
inp_switches_3: in std_logic_vector(3 downto 0);
inp_switches_4: in std_logic_vector(3 downto 0);
clk_in : in std_logic;
Display_7segments : out std_logic_vector(6 downto 0);
activ_displays: out std_logic_vector(3 downto 0);
BTC: in std_logic;
BTR: in std_logic;
BTL: in std_logic;
BTU: in std_logic;
BTD: in std_logic
);
end leccion1;

architecture Behavioral of leccion1 is
signal primer_digito: integer := 0;
signal segundo_digito: integer := 0;
signal tercer_digito : integer := 0;
signal cuarto_digito : integer := 0;
signal contador_led: integer := 0;

signal contador_ms : integer := 0;
signal divisor_ms : integer := 50_000;
signal clk_temp_ms : std_logic;
signal contador: integer := 0;
signal Display_BCD : integer range 0 to 9 := 0;

begin


-- Proceso para obtener clock de 1m segundo
process (clk_in)
begin
if rising_edge(clk_in) then
if contador_ms < divisor_ms then
contador_ms <= contador_ms + 1;
else
clk_temp_ms <= not clk_temp_ms;
contador_ms <= 0;
end if;
end if;
end process;


process(BTC)
begin

if (BTC'event and BTC = '1') then
    case inp_switches_1 is
        when "0000" =>
        primer_digito <= 0;
        when "0001" =>
        primer_digito <= 1;
        when "0010" =>
        primer_digito <= 2;
        when "0011" =>
        primer_digito <= 3;
        when "0100" =>
        primer_digito <= 4;
        when "0101" =>
        primer_digito <= 5;
        when "0110" =>
        primer_digito <= 6;
        when "0111" =>
        primer_digito <= 7;
        when "1000" =>
        primer_digito <= 8;
        when "1001" =>
        primer_digito <= 9;
        when "1010" =>
        primer_digito <= 10;
        when "1011" =>
        primer_digito <= 11;
        when "1100" =>
        primer_digito <= 12;
        when "1101" =>
        primer_digito <= 13;
        when "1110" =>
        primer_digito <= 14;
        when "1111" =>
        primer_digito <= 15;
        when others =>
        primer_digito <= 0;
    end case;
    
    case inp_switches_2 is
        when "0000" =>
        segundo_digito <= 0;
        when "0001" =>
        segundo_digito <= 1;
        when "0010" =>
        segundo_digito <= 2;
        when "0011" =>
        segundo_digito <= 3;
        when "0100" =>
        segundo_digito <= 4;
        when "0101" =>
        segundo_digito <= 5;
        when "0110" =>
        segundo_digito <= 6;
        when "0111" =>
        segundo_digito <= 7;
        when "1000" =>
        segundo_digito <= 8;
        when "1001" =>
        segundo_digito <= 9;
        when "1010" =>
        segundo_digito <= 10;
        when "1011" =>
        segundo_digito <= 11;
        when "1100" =>
        segundo_digito <= 12;
        when "1101" =>
        segundo_digito <= 13;
        when "1110" =>
        segundo_digito <= 14;
        when "1111" =>
        segundo_digito <= 15;
        when others =>
        segundo_digito <= 0;
    end case;
    
    case inp_switches_3 is
        when "0000" =>
        tercer_digito <= 0;
        when "0001" =>
        tercer_digito <= 1;
        when "0010" =>
        tercer_digito <= 2;
        when "0011" =>
        tercer_digito <= 3;
        when "0100" =>
        tercer_digito <= 4;
        when "0101" =>
        tercer_digito <= 5;
        when "0110" =>
        tercer_digito <= 6;
        when "0111" =>
        tercer_digito <= 7;
        when "1000" =>
        tercer_digito <= 8;
        when "1001" =>
        tercer_digito <= 9;
        when "1010" =>
        tercer_digito <= 10;
        when "1011" =>
        tercer_digito <= 11;
        when "1100" =>
        tercer_digito <= 12;
        when "1101" =>
        tercer_digito <= 13;
        when "1110" =>
        tercer_digito <= 14;
        when "1111" =>
        tercer_digito <= 15;
        when others =>
        tercer_digito <= 0;
    end case;
    
    case inp_switches_4 is
        when "0000" =>
        cuarto_digito <= 0;
        when "0001" =>
        cuarto_digito <= 1;
        when "0010" =>
        cuarto_digito <= 2;
        when "0011" =>
        cuarto_digito <= 3;
        when "0100" =>
        cuarto_digito <= 4;
        when "0101" =>
        cuarto_digito <= 5;
        when "0110" =>
        cuarto_digito <= 6;
        when "0111" =>
        cuarto_digito <= 7;
        when "1000" =>
        cuarto_digito <= 8;
        when "1001" =>
        cuarto_digito <= 9;
        when "1010" =>
        cuarto_digito <= 10;
        when "1011" =>
        cuarto_digito <= 11;
        when "1100" =>
        cuarto_digito <= 12;
        when "1101" =>
        cuarto_digito <= 13;
        when "1110" =>
        cuarto_digito <= 14;
        when "1111" =>
        cuarto_digito <= 15;
        when others =>
        cuarto_digito <= 0;
    end case;
    
end if;

end process;


process(BTL)
begin
if (BTL'event and BTL = '1') then
    if contador_led = 3 then
        contador_led <= 0;
    else
        contador_led <= contador_led + 1;
    end if;
end if;
end process;

process(BTR)
begin
if (BTR'event and BTR = '1') then

    if contador_led = 0 then
        contador_led <= 3;
     else
        contador_led <= contador_led - 1;
    end if;
end if;
end process;

process(BTU)
begin
if (BTU'event and BTU = '1') then
    case contador_led is
        when 0 =>
            if primer_digito < 15 then
                primer_digito <= primer_digito + 1;
            end if;
        when 1 =>
            if segundo_digito < 15 then
                segundo_digito <= segundo_digito + 1;
            end if;
        when 2 =>
            if tercer_digito < 15 then
                tercer_digito <= tercer_digito + 1;
            end if;
        when 3 =>
            if cuarto_digito < 15 then
                cuarto_digito <= cuarto_digito + 1;
            end if;
        when others =>
            if cuarto_digito < 15 then
                cuarto_digito <= cuarto_digito + 1;
            end if;
    end case;
 end if;  
end process;


process(BTD)
begin
if (BTD'event and BTD = '1') then
    case contador_led is
        when 0 =>
            if primer_digito > 0 then
                primer_digito <= primer_digito - 1;
            end if;
        when 1 =>
            if segundo_digito < 15 then
                segundo_digito <= segundo_digito - 1;
            end if;
        when 2 =>
            if tercer_digito < 15 then
                tercer_digito <= tercer_digito - 1;
            end if;
        when 3 =>
            if cuarto_digito < 15 then
                cuarto_digito <= cuarto_digito - 1;
            end if;
        when others =>
            if cuarto_digito < 15 then
                cuarto_digito <= cuarto_digito - 1;
            end if;
    end case;
end if;
end process;




process (clk_temp_ms) is
begin
    if (clk_temp_ms'event and clk_temp_ms = '1') then
        if contador < 3 then
            contador <= contador + 1;
        else
            contador <= 0;
        end if;
    end if;
end process;


process (contador)
begin
    if contador = 0 then
        Display_BCD <= primer_digito;
        activ_displays <= "1110";
    elsif contador = 1 then
        Display_BCD <= segundo_digito;
        activ_displays <= "1101";
    elsif contador = 2 then
        Display_BCD <= tercer_digito ;
        activ_displays <= "1011";
    else
        Display_BCD <= cuarto_digito ;
        activ_displays <= "0111";
    end if;
end process;

with Display_BCD select
Display_7segments <=
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
