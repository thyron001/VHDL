library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( 
        clk            : in  STD_LOGIC;
        columnas       : in  STD_LOGIC_VECTOR (3 downto 0);
        filas          : out STD_LOGIC_VECTOR (3 downto 0);
        anodo           : out STD_LOGIC_VECTOR (3 downto 0);
        segmentos_7     : out STD_LOGIC_VECTOR (6 downto 0)
    );
end main;

architecture final of main is

    signal boton_pres : STD_LOGIC_VECTOR (3 downto 0);
    signal ind        : STD_LOGIC;
    signal numero     : STD_LOGIC_VECTOR (3 downto 0);
    component teclado
        Port ( 
            clk        : in  STD_LOGIC;
            columnas   : in  STD_LOGIC_VECTOR (3 downto 0);
            filas      : out STD_LOGIC_VECTOR (3 downto 0);
            boton_pres : out STD_LOGIC_VECTOR (3 downto 0);
            ind        : out STD_LOGIC
        );
    end component;

begin

    anodo <= "0111";

    -- Componente teclado
    teclado_inst : teclado
        port map (clk => clk, columnas => columnas, filas => filas, boton_pres => boton_pres, ind => ind);

    -- Mostrar el valor del boton presionado en el display de 7 segmentos
    process(clk)
    begin
        if rising_edge(clk) then
            numero <= boton_pres;
        end if;
    end process;
    
    -- Asignacion del valor de boton presionado al display de 7 segmentos
    with numero select 
        segmentos_7 <=
            "0000001" when x"0", 
            "1001111" when x"1", 
            "0010010" when x"2", 
            "0000110" when x"3", 
            "1001100" when x"4",
            "0100100" when x"5", 
            "1100000" when x"6", 
            "0001111" when x"7",
            "0000000" when x"8",
            "0000100" when x"9",
            "0001000" when x"A",
            "1100000" when x"B", 
            "0110001" when x"C",
            "1000010" when x"D",
            "0110000" when x"E",
            "0111000" when x"F",
            "0000001" when others;

end final;