library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity teclado is
    Port ( 
        clk       : in  STD_LOGIC;
        columnas  : in  STD_LOGIC_VECTOR (3 downto 0);
        filas     : out STD_LOGIC_VECTOR (3 downto 0);
        boton_pres: out STD_LOGIC_VECTOR (3 downto 0);
        ind       : out STD_LOGIC
    );
end teclado;

architecture control of teclado is
    constant DELAY_1MS  : integer := 50_000;
    constant DELAY_10MS : integer := 500_000;

    signal clk_1ms, clk_10ms : STD_LOGIC;

    signal fila_reg : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    -- Inicializacion de registros de 8 bits con ceros
    signal reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7, reg_8, reg_9, reg_0, reg_A, reg_B, reg_C, reg_D, reg_E, reg_F: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tecla_detectada   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal tecla_presionada  : STD_LOGIC_VECTOR(3 downto 0);
    signal ind_signal        : STD_LOGIC := '0';
    signal ind_pulse         : STD_LOGIC := '0';

    component divisor_frecuencia
        generic (
            divisor : integer
        );
        Port ( 
            clk_in  : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

begin
    -- Instancia del divisor de frecuencia para clk_1ms y clk_10ms
    div1ms : divisor_frecuencia
        generic map (divisor => DELAY_1MS)
        port map (clk_in => clk, clk_out => clk_1ms);

    div10ms : divisor_frecuencia
        generic map (divisor => DELAY_10MS)
        port map (clk_in => clk, clk_out => clk_10ms);

    -- Enviar senales a filas
    process(clk_10ms)
    begin
        if rising_edge(clk_10ms) then
            fila_reg <= fila_reg(2 downto 0) & fila_reg(3);
        end if;
    end process;

    filas <= fila_reg;

    -- Proceso de anti-rebote
    process(clk_1ms)
    begin
        if rising_edge(clk_1ms) then
            case fila_reg is
                when "0001" =>
                    reg_F <= reg_F(6 downto 0) & columnas(3);
                    reg_0 <= reg_0(6 downto 0) & columnas(2);
                    reg_E <= reg_E(6 downto 0) & columnas(1);
                    reg_D <= reg_D(6 downto 0) & columnas(0);
                when "0010" =>
                    reg_7 <= reg_7(6 downto 0) & columnas(3);
                    reg_8 <= reg_8(6 downto 0) & columnas(2);
                    reg_9 <= reg_9(6 downto 0) & columnas(1);
                    reg_C <= reg_C(6 downto 0) & columnas(0);
                when "0100" =>
                    reg_4 <= reg_4(6 downto 0) & columnas(3);
                    reg_5 <= reg_5(6 downto 0) & columnas(2);
                    reg_6 <= reg_6(6 downto 0) & columnas(1);
                    reg_B <= reg_B(6 downto 0) & columnas(0);
                when "1000" =>
                    reg_1 <= reg_1(6 downto 0) & columnas(3);
                    reg_2 <= reg_2(6 downto 0) & columnas(2);
                    reg_3 <= reg_3(6 downto 0) & columnas(1);
                    reg_A <= reg_A(6 downto 0) & columnas(0);
                when others =>
                    null;
            end case;
        end if;
    end process;

    -- Deteccion de teclas
    process(clk)
    begin
        if rising_edge(clk) then
            ind_signal <= '0';
            
            if reg_0 = x"FF" then
                tecla_detectada <= "0000";
                ind_signal <= '1';
            elsif reg_1 = x"FF" then
                tecla_detectada <= "0001";
                ind_signal <= '1';
            elsif reg_2 = x"FF" then
                tecla_detectada <= "0010";
                ind_signal <= '1';
            elsif reg_3 = x"FF" then
                tecla_detectada <= "0011";
                ind_signal <= '1';
            elsif reg_4 = x"FF" then
                tecla_detectada <= "0100";
                ind_signal <= '1';
            elsif reg_5 = x"FF" then
                tecla_detectada <= "0101";
                ind_signal <= '1';
            elsif reg_6 = x"FF" then
                tecla_detectada <= "0110";
                ind_signal <= '1';
            elsif reg_7 = x"FF" then
                tecla_detectada <= "0111";
                ind_signal <= '1';
            elsif reg_8 = x"FF" then
                tecla_detectada <= "1000";
                ind_signal <= '1';
            elsif reg_9 = x"FF" then
                tecla_detectada <= "1001";
                ind_signal <= '1';
            elsif reg_A = x"FF" then
                tecla_detectada <= "1010";
                ind_signal <= '1';
            elsif reg_B = x"FF" then
                tecla_detectada <= "1011";
                ind_signal <= '1';
            elsif reg_C = x"FF" then
                tecla_detectada <= "1100";
                ind_signal <= '1';
            elsif reg_D = x"FF" then
                tecla_detectada <= "1101";
                ind_signal <= '1';
            elsif reg_E = x"FF" then
                tecla_detectada <= "1110";
                ind_signal <= '1';
            elsif reg_F = x"FF" then
                tecla_detectada <= "1111";
                ind_signal <= '1';
            end if;
           
            if ind_signal = '1' then
                tecla_presionada <= tecla_detectada;
            end if;
        end if;
    end process;

    -- Asignacion de la tecla presionada a la salida boton_pres
    boton_pres <= tecla_presionada;
    -- Asignacion del pulso salida del componente
    ind <= ind_pulse;

    -- Proceso para generar un pulso de ind
    process(clk)
    begin
        if rising_edge(clk) then
            ind_pulse <= ind_signal;
        end if;
    end process;

end control;