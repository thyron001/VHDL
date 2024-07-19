library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_SIGNED.ALL;
--use IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;


entity final is
  Port (clk_in : in std_logic;
        eoc: in std_logic;
        data_in: std_logic_vector(11 downto 0);
        len_lpf: in std_logic_vector(1 downto 0);
        data_out: out std_logic_vector(11 downto 0));
end final;

architecture Behavioral of final is
type data_reg_type is  array(0 to 7) of STD_LOGIC_VECTOR(11 downto 0);
signal sum : STD_LOGIC_VECTOR(15 downto 0); -- Para almacenar la suma de las muestras
signal suma_int: integer:= 0;
signal len : integer := 0;

signal data_reg: data_reg_type;
begin
process(clk_in)
    begin
     if rising_edge(clk_in) then
        if eoc = '1' then
            -- Shift register
            for i in 7 downto 1 loop
                data_reg(i) <= data_reg(i-1);
            end loop;
            data_reg(0) <= data_in;
        end if;
        -- Calculate the sum based on filter length
        case len_lpf is
            when "01" => -- Length 2
                sum <= ("0000" & data_reg(0)) + ("0000" & data_reg(1));
                len <= 2;
            when "10" => -- Length 4
                sum <= ("0000" & data_reg(0)) + ("0000" & data_reg(1)) + ("0000" & data_reg(2)) + ("0000" & data_reg(3));
                len <= 4;
            when "11" => -- Length 8
                sum <= ("0000" & data_reg(0)) + ("0000" & data_reg(1)) + ("0000" & data_reg(2)) + ("0000" & data_reg(3)) +
                       ("0000" & data_reg(4)) + ("0000" & data_reg(5)) + ("0000" & data_reg(6)) + ("0000" & data_reg(7));
                len <= 8;
            when others => -- Default to length 2
                sum <= "0000" & data_in;
                len <= 1;
        end case;

            -- Output the average
            suma_int <= TO_INTEGER(unsigned(sum)) / len; -- División por el número de muestras
            data_out <= std_logic_vector(to_unsigned(suma_int,12));
        end if;
    end process;
end Behavioral;