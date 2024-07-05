library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity restador is
  Port (a       :   in std_logic;
        b       :   in std_logic;
        cin     :   in std_logic;
        cout    :   out std_logic;
        resta   :   out std_logic);
end restador;

architecture Behavioral of restador is 

begin

resta <= cin XOR (a XOR b);
cout <= ((NOT a) AND b) OR (cin AND (NOT (a XOR b)));

end Behavioral;

