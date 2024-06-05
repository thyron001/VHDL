----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2024 09:13:02 AM
-- Design Name: 
-- Module Name: rotar_leds - Behavioral
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

entity rotar_leds is
port (
    clk_in : in std_logic;
    activ_displays : out std_logic_vector(3 downto 0);
    Display_7segments : out std_logic_vector(6 downto 0);
    switch : in std_logic;
    CLR : in std_logic
    );
end rotar_leds;

architecture Behavioral of rotar_leds is
    type state_type is (ST0, ST1, ST2, ST3, ST4, ST5);
    signal PS, NS : state_type;
    signal CLK : std_logic;
    signal contador_reloj : integer := 0;
begin
    activ_displays <= "1110";

    reloj_05s: process(clk_in)
    begin
        if rising_edge(clk_in) then
            if contador_reloj < 25_000_000 then
                contador_reloj <= contador_reloj + 1;
            else
                CLK <= not CLK;
                contador_reloj <= 0;
            end if;
        end if;

    end process reloj_05s;

    sync_proc: process(CLK, NS, CLR)
    begin
        if (CLR = '1') then
            PS <= ST0;
        elsif (rising_edge(CLK)) then
            PS <= NS;
        end if;
    end process sync_proc;
    
    comb_proc: process(PS, switch)
    begin
        case PS is
            when ST0 => 
                display_7segments <= "0111111";
                if (switch = '1') then NS <= ST1;
                else NS <= ST5;
                end if;
            when ST1 => 
                display_7segments <= "1011111";
                if (switch = '1') then NS <= ST2;
                else NS <= ST0;
                end if;
            when ST2 => 
                display_7segments <= "1101111";
                if (switch = '1') then NS <= ST3;
                else NS <= ST1;
                end if;
            when ST3 => 
                display_7segments <= "1110111";
                if (switch = '1') then NS <= ST4;
                else NS <= ST2;
                end if;
            when ST4 => 
                display_7segments <= "1111011";
                if (switch = '1') then NS <= ST5;
                else NS <= ST3;
                end if;
            when ST5 => 
                display_7segments <= "1111101";
                if (switch = '1') then NS <= ST0;
                else NS <= ST4;
                end if;
            when others =>
                display_7segments <= "0111111";
                NS <= ST0;
        end case;
    end process comb_proc;

end Behavioral;
