library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor_frecuencia is
    generic (
        divisor : integer
    );
    Port (
        clk_in  : in  STD_LOGIC;
        clk_out : out STD_LOGIC
    );
end divisor_frecuencia;

architecture divisor of divisor_frecuencia is
    signal contador : integer range 0 to divisor := 0;
    signal clk_temp : STD_LOGIC := '0';
begin
    process (clk_in)
    begin
        if rising_edge(clk_in) then
            if contador < divisor - 1 then
                contador <= contador + 1;
            else
                clk_temp <= not clk_temp;
                contador <= 0;
            end if;
        end if;
    end process;

    clk_out <= clk_temp;

end divisor;
