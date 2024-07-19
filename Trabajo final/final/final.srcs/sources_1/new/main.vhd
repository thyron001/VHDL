
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( clk    : in STD_LOGIC;
           btn    : in STD_LOGIC;
           JA     : in STD_LOGIC_VECTOR (7 downto 0);
           sw     : in STD_LOGIC_VECTOR (1 downto 0);
           SD     : out std_logic;
           CLK_SD : out std_logic;
           CLEAR  : out std_logic;
           LATCH  : out std_logic
           );
end main;

architecture Behavioral of main is
    COMPONENT xadc_wiz_0
      PORT (
        di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        den_in : IN STD_LOGIC;
        dwe_in : IN STD_LOGIC;
        drdy_out : OUT STD_LOGIC;
        do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        dclk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        convst_in : IN STD_LOGIC;
        vp_in : IN STD_LOGIC;
        vn_in : IN STD_LOGIC;
        vauxp5 : IN STD_LOGIC;
        vauxn5 : IN STD_LOGIC;
        channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        eoc_out : OUT STD_LOGIC;
        alarm_out : OUT STD_LOGIC;
        eos_out : OUT STD_LOGIC;
        busy_out : OUT STD_LOGIC 
      );
    END COMPONENT;

    component final is
    Port(
        clk_in : in std_logic;
        eoc: in std_logic;
        data_in: std_logic_vector(11 downto 0);
        len_lpf: in std_logic_vector(1 downto 0);
        data_out: out std_logic_vector(11 downto 0));
    end component;
        
    signal channel_out  : std_logic_vector(4 downto 0);
    signal daddr_in : std_logic_vector(6 downto 0);
    signal eoc_out : std_logic;
    signal do_out : std_logic_vector(15 downto 0);
    signal anal_p, anal_n, convst, drdy: std_logic;
    signal count : integer range 0 to 999;    
    signal x, y : std_logic_vector(11 downto 0);
    
    
    --Senales para el envio de datos seriales

    signal clk_serial: STD_LOGIC;
    signal contador_2M : integer range 0 to 63;  
    signal contador_12: integer range 0 to 12;
    
begin

daddr_in <= "00" & channel_out;
anal_p <= JA(4);
anal_n <= JA(0);

filtro_variable : final
  PORT MAP(clk_in   => clk,
        eoc      => eoc_out,
        data_in  => x,
        len_lpf  => sw,
        data_out => y);

your_adc : xadc_wiz_0
  PORT MAP (
    di_in => "0000000000000000",
    daddr_in => daddr_in,
    den_in => eoc_out,
    dwe_in => '0',
    drdy_out => open,
    do_out => do_out,
    dclk_in => clk,
    reset_in => btn,
    convst_in => convst,
    vp_in => '0',
    vn_in => '0',
    vauxp5 => anal_p,
    vauxn5 => anal_n,
    channel_out => channel_out,
    eoc_out => eoc_out,
    alarm_out => open,
    eos_out => open,
    busy_out => open
  );
  
  x  <= do_out(15 downto 4);



  --Senal de reloj de 100KHz (Frecuencia de muestreo)
  process(clk)
      begin
          if rising_edge(clk) then
              count <= count + 1;
              convst <= '0';
              if count = 999 then
                  count <= 0;
                  convst <= '1';
              end if;
          end if;
      end process;
   
  --Generar senal de reloj para enviar datos 
  process(clk)
    begin
        if rising_edge(clk) then
            if eoc_out = '1' then
                contador_2M <= 0;
                contador_12 <= 0;
            end if;

            if contador_12 < 12 then
                contador_2M <= contador_2M + 1;
                if contador_2M = 24 then
                    contador_2M <= 0;
                    clk_serial <= not clk_serial;
                    if clk_serial = '1' then
                        contador_12 <= contador_12 + 1;
                    end if;
                end if;
            else
                clk_serial <= '0';
            end if;
        end if;
    end process;
    
    --Enviar datos serialmente
    process (clk_serial) is
        variable count_serial : integer := 0;
        begin
        if rising_edge(clk_serial) then
            if count_serial = 11 then
                count_serial := 0;
                SD <= '0';
            else 
                SD <= y(count_serial);
                count_serial := count_serial + 1;
            end if;
        end if;
    end process;
   
    
    CLK_SD  <= clk_serial;
    LATCH   <= eoc_out;
    CLEAR   <= '1';
  
end Behavioral;
