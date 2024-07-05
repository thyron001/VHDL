library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumador is
  Port (a       :   in std_logic;
        b       :   in std_logic;
        cin     :   in std_logic;
        cout    :   out std_logic;
        suma    :   out std_logic);
end sumador;

architecture Behavioral of sumador is 
begin

suma <= a XOR b XOR cin;
cout <= (a AND b) or (a AND cin) or (b AND cin);

end Behavioral;

