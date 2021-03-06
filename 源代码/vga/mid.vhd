library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 

entity mid is 
port (
clk : in std_logic;--!
fangda_temp : in std_logic;--!
mode : in std_logic_vector(1 downto 0);--key按键输入旋转90度信号，下降沿有效
qin : in std_logic_vector(2 downto 0); 
xx: in std_logic_vector(9 downto 0);--!
yy: in std_logic_vector(9 downto 0);--!
hcntin : in std_logic_vector(9 downto 0);--!
vcntin : in std_logic_vector(9 downto 0);--!
qout : out std_logic_vector(2 downto 0);--!
romaddr_control : out std_logic_vector(13 downto 0)--!
); 
end mid;

architecture one of mid is 
signal xuanzhuanjiaodu: std_logic_vector(1 downto 0);
signal hcnt : std_logic_vector(9 downto 0);-- 
signal vcnt : std_logic_vector(9 downto 0);-- 
signal qout_temp : std_logic_vector(2 downto 0);--
signal count_temph : std_logic_vector(9 downto 0);
signal count_tempv : std_logic_vector(9 downto 0);
signal wide        : integer range 0 to 1024;
signal long        : integer range 0 to 1024;
begin
--Assign pin
hcnt <= hcntin;
vcnt <= vcntin;
qout <= qout_temp;
xuanzhuanjiaodu <=mode;
--fangda
process( fangda_temp )
begin
	if(fangda_temp='0') then
		 wide <= 256;
		 long <= 64;
	else
		 wide <= 512;
		 long <= 128;
	end if;
end process;

--xuanzhuanjiaodu
process( xuanzhuanjiaodu )
BEGIN
	case xuanzhuanjiaodu IS
		WHEN "00" => 
		if(fangda_temp = '0') then
		romaddr_control <= (vcnt(5 downto 0)-count_tempv(5 downto 0))--0 du
						  &(hcnt(7 downto 0)-count_temph(7 downto 0)); 
		else
		romaddr_control <= (vcnt(6 downto 1)-count_tempv(6 downto 1))--0 du
						  &(hcnt(8 downto 1)-count_temph(8 downto 1)); 
		end if;
		WHEN "01" =>  
		if(fangda_temp = '0') then
		romaddr_control <= (64-(hcnt(5 downto 0)-count_temph(5 downto 0)))--90 du
						  &(vcnt(7 downto 0)-count_tempv(7 downto 0));
		else
		romaddr_control <= (64-(hcnt(6 downto 1)-count_temph(6 downto 1)))--90 du
						  &(vcnt(8 downto 1)-count_tempv(8 downto 1));
		end if;
		WHEN "10" => 
		if(fangda_temp = '0') then
		romaddr_control <= (64-(vcnt(5 downto 0)-count_tempv(5 downto 0)))--180 du
						  &(256-(hcnt(7 downto 0)-count_temph(7 downto 0)));
		else
		romaddr_control <= (64-(vcnt(6 downto 1)-count_tempv(6 downto 1)))--180 du
						  &(256-(hcnt(8 downto 1)-count_temph(8 downto 1)));
		end if;
		WHEN OTHERS =>  
		if(fangda_temp = '0') then
		romaddr_control <= ((hcnt(5 downto 0)-count_temph(5 downto 0))) --270 du
						  &(256-(vcnt(7 downto 0)-count_tempv(7 downto 0)));
		else
		romaddr_control <= ((hcnt(6 downto 1)-count_temph(6 downto 1))) --270 du
						  &(256-(vcnt(8 downto 1)-count_tempv(8 downto 1)));
		end if;
	end case;
end process;

process(xx,yy) 
begin 
	if((vcnt = yy) and( hcnt=xx) )then 
		count_temph<=xx;
		count_tempv<=yy;
	end if;
	
	if((xuanzhuanjiaodu =1 ) or (xuanzhuanjiaodu =3 )) then
		if((vcnt < yy) or (vcnt > yy+wide)) then qout_temp<="000";--cnt(31 downto 24);
			elsif((hcnt>xx)and(hcnt<xx + long)) then
			qout_temp<=qin;---------input logo.hex
			else
			qout_temp<="000";--cnt(31 downto 24);
		end if;
	else
		if((vcnt < yy) or (vcnt > yy+long)) then qout_temp<="000";--cnt(31 downto 24);
			elsif((hcnt>=xx)and(hcnt<=xx + wide)) then
			qout_temp<=qin;---------input logo.hex
			else
			qout_temp<="000";--cnt(31 downto 24);
		end if;	
	end if;	
end process;

end one;
