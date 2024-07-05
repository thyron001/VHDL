library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity suma_palabras is
    Port(
        a: in std_logic_vector(3 downto 0);
        b: in std_logic_vector(3 downto 0);
        resultado: out std_logic_vector(3 downto 0)
    );
end suma_palabras;

architecture Behavioral of suma_palabras is
    signal carry : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(a, b)
        variable sum: std_logic_vector(4 downto 0);
    begin
        -- Suma de los bits menos significativos
        sum(0) := a(0) XOR b(0);
        carry(0) <= a(0) AND b(0);

        -- Suma de los bits del segundo bit
        sum(1) := a(1) XOR b(1) XOR carry(0);
        carry(1) <= (a(1) AND b(1)) OR (a(1) AND carry(0)) OR (b(1) AND carry(0));

        -- Suma de los bits del tercer bit
        sum(2) := a(2) XOR b(2) XOR carry(1);
        carry(2) <= (a(2) AND b(2)) OR (a(2) AND carry(1)) OR (b(2) AND carry(1));
        
        -- Suma de los bits más significativos
        sum(3) := a(3) XOR b(3) XOR carry(2);
        carry(3) <= (a(3) AND b(3)) OR (a(3) AND carry(2)) OR (b(3) AND carry(2));
        
        -- Asignar el bit de acarreo más significativo a la suma
        sum(4) := carry(3);

        -- Asignar la salida
        resultado <= sum(3 downto 0);
    end process;
end Behavioral;
