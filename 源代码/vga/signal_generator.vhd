library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity signal_generator is
port(main_clk:in std_logic;
frequence : in std_logic;
sel_ect:in std_logic_vector(1 downto 0);
y_out:out std_logic_vector(7 downto 0)
);

end signal_generator;

architecture test of signal_generator is

component fangbo   --diao yong fangbo mu kuai
port(clock:in std_logic;
frequence : in std_logic;
dout1:out integer range 0 to 255);
end component;

component jieti   --diao yong jieti mu kuai
port(clock:in std_logic;
frequence : in std_logic;
dout2:out integer range 0 to 255);
end component;

component sanjiao   --diao yong sanjiao mu kuai
port(clock:in std_logic;
frequence : in std_logic;
dout3:out integer range 0 to 255);
end component;

component sin2   --diao yong zhengxian mu kuai
port(clock:in std_logic;
frequence : in std_logic;
dout4:out integer range 0 to 255);
end component;

component xzq   --diao yong xuanze mu kuai
port(a,b,c,d :in std_logic_vector(7 downto 0);
	sel:in std_logic_vector(1 downto 0);
	yout:out std_logic_vector(7 downto 0));
end component;


signal u1_u2:integer range 0 to 999;  --chuan di fen pin shu
signal clk_line:std_logic;

signal s1:integer range 0 to 255;
signal s2:integer range 0 to 255;
signal s3:integer range 0 to 255;
signal s4:integer range 0 to 255;

signal ss1:std_logic_vector(7 downto 0);
signal ss2:std_logic_vector(7 downto 0);
signal ss3:std_logic_vector(7 downto 0);
signal ss4:std_logic_vector(7 downto 0);
begin

ss1<=conv_std_logic_vector(s1,8);
ss2<=conv_std_logic_vector(s2,8);
ss3<=conv_std_logic_vector(s3,8);
ss4<=conv_std_logic_vector(s4,8);

u3:fangbo port map(main_clk,frequence,s1);
u4:jieti port map(main_clk,frequence,s2);
u5:sanjiao port map(main_clk,frequence,s3);
u6:sin2 port map(main_clk,frequence,s4);

ss1<=conv_std_logic_vector(s1,8);
ss2<=conv_std_logic_vector(s2,8);
ss3<=conv_std_logic_vector(s3,8);
ss4<=conv_std_logic_vector(s4,8);
--��·ѡ����
u7:xzq port map(ss1,ss2,ss3,ss4,sel_ect,y_out);

end test;


 
