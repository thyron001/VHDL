library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux is
  Port (
    a, b: in std_logic_vector (3 downto 0);
    sel: in std_logic;
    x  : out std_logic_vector (3 downto 0)
   );
end mux;

architecture mux of mux is

begin
    with sel select 
        x <= a when '0',
             b when others;

end mux;
