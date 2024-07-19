library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_SIGNED.ALL;
--use IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity final is
  Port (clk_in : in std_logic;                   -- Señal de reloj
        eoc: in std_logic;                       -- Señal de fin de conversión
        data_in: std_logic_vector(11 downto 0);  -- Entrada de datos (12 bits)
        len_lpf: in std_logic_vector(1 downto 0);-- Selector de longitud del filtro
        data_out: out std_logic_vector(11 downto 0));-- Salida de datos filtrados (12 bits)
end final;

architecture Behavioral of final is
    -- Tipo de dato para el registro de desplazamiento que almacena las muestras de entrada
    type tipo_arreglo_muestras is array(0 to 7) of STD_LOGIC_VECTOR(11 downto 0);
    signal suma: STD_LOGIC_VECTOR(15 downto 0);   -- Señal para almacenar la suma de las muestras
    signal promedio_int: integer := 0;            -- Señal para almacenar el promedio calculado
    signal longitud_filtro : integer := 0;        -- Señal para almacenar la longitud del filtro
    signal registro_muestras: tipo_arreglo_muestras; -- Registro de desplazamiento para almacenar muestras

begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if eoc = '1' then
                -- Operación del registro de desplazamiento
                for i in 7 downto 1 loop
                    registro_muestras(i) <= registro_muestras(i-1);
                end loop;
                registro_muestras(0) <= data_in; -- Cargar nueva muestra en el registro de desplazamiento
            end if;

            -- Calcular la suma de las muestras basado en la longitud del filtro seleccionada
            case len_lpf is
                when "01" => -- Longitud 2
                    suma <= ("0000" & registro_muestras(0)) + ("0000" & registro_muestras(1));
                    longitud_filtro <= 2;
                when "10" => -- Longitud 4
                    suma <= ("0000" & registro_muestras(0)) + ("0000" & registro_muestras(1)) + ("0000" & registro_muestras(2)) + ("0000" & registro_muestras(3));
                    longitud_filtro <= 4;
                when "11" => -- Longitud 8
                    suma <= ("0000" & registro_muestras(0)) + ("0000" & registro_muestras(1)) + ("0000" & registro_muestras(2)) + ("0000" & registro_muestras(3)) +
                           ("0000" & registro_muestras(4)) + ("0000" & registro_muestras(5)) + ("0000" & registro_muestras(6)) + ("0000" & registro_muestras(7));
                    longitud_filtro <= 8;
                when others => -- Por defecto a longitud 1 (sin promedio)
                    suma <= "0000" & data_in;
                    longitud_filtro <= 1;
            end case;

            -- Calcular el promedio de las muestras
            promedio_int <= TO_INTEGER(unsigned(suma)) / longitud_filtro; -- División por el número de muestras
            data_out <= std_logic_vector(to_unsigned(promedio_int, 12)); -- Salida de la muestra promediada
        end if;
    end process;
end Behavioral;
