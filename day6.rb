require 'byebug'

class OrbitMap
  def self.connect_orbits(map_string)
    map = OrbitMap.new
    map_string.split("\n").each do |connection|
      a,b = connection.split(')')
      map.connect(a,b)
    end
    map
  end

  attr_reader :orbiters

  def initialize
    @orbiters = {}
  end

  def connect(root_name, child_name)
    orbiter_a =
      if @orbiters.keys.include?(root_name)
        @orbiters[root_name]
      else
        @orbiters[root_name] = Orbiter.new(root_name)
      end
    orbiter_b =
      if @orbiters.keys.include?(child_name)
        @orbiters[child_name]
      else
        @orbiters[child_name] = Orbiter.new(child_name,orbiter_a)
      end
    orbiter_a.add_orbiter(orbiter_b)
  end

  def [](orbiter_name)
    @orbiters[orbiter_name]
  end
end

class Orbiter
  attr_reader :orbiting, :orbiters
  def initialize(name,orbiting=nil)
    @orbiting = orbiting
    @orbiters = []
  end
  def add_orbiter(orbiter)
    @orbiters << orbiter
    if orbiter.orbiting.nil?
      orbiter.set_orbiting(self)
    end
  end
  def set_orbiting(planet_i_orbit)
    @orbiting = planet_i_orbit
  end
  def distance_from_COM
    return 0 unless @orbiting
    return 1 + @orbiting.distance_from_COM
  end
end

if __FILE__ == $0
  diagnostic_program = DATA.readline
  byebug
  p "done"
end

__END__
J1C)J1M
N2W)2DM
DST)VZL
555)45Q
S4C)DGK
H51)JLX
K4L)3F5
L58)T9K
GBC)NZT
L7B)CQB
L7L)R63
4LQ)KHZ
XWW)L61
R6W)DVN
91C)GPM
YWZ)51W
XK8)22K
NV2)DTP
5LQ)F4V
4H9)R4B
29X)R9H
1G5)W91
TZL)S4C
1Z7)1MY
N7V)1Z4
7YX)LQ9
PK9)D1Y
QVK)K1H
4FT)3X5
5M5)29X
5XH)H5K
LGK)V51
HMN)LNG
5QX)KHJ
797)TJR
SRV)4RT
1R4)MSZ
3SJ)XRT
X6N)J1N
WM8)LH2
KGZ)5ZP
ZY5)9GY
H5K)2LX
4QD)1ND
JDK)WRX
KSR)4LD
8Q3)W8B
51W)QZT
HSQ)CV5
35F)VW2
8Q9)845
8FS)XB4
WFX)N2F
BDG)G3G
Q7S)K1X
1MY)PCB
FRW)TZL
N78)Z9K
J4F)98D
4J2)6S3
9QY)1HG
RRX)SW4
DH7)CLW
M8W)4QD
9K9)1NV
KHW)T14
DQC)ZCG
R4H)MPG
FY9)HXB
7SF)J1C
SPT)P66
BB6)XZR
7MR)MDH
M4G)DBH
7RP)BHH
2H8)QKS
RL2)8ZM
598)68Q
MPG)WWF
BWN)J2D
FRF)JJM
QFJ)57P
NSS)BVH
3SM)HTP
N1K)SYL
33P)TY2
WWF)7SK
4V3)6PT
4LD)13S
9HN)CTC
Q87)48X
7MB)96M
6S3)B65
KFJ)5YL
DGK)TS5
2C3)YL7
M79)GRM
BRG)41X
GPJ)YLW
8FS)2LC
SL5)G5L
2MW)RHN
DDZ)J4F
ZQZ)4LQ
FZF)Z6X
XF1)JWS
B7C)6DM
GN9)N7V
F5K)2JX
7QR)FCC
3DG)2X7
L9C)RMW
XKM)26Q
FPK)5VT
RGQ)XF1
174)79T
1CP)KVB
X5Y)WWH
M1K)2X2
L53)76G
5MS)YX8
8P2)DPP
LMJ)B6X
NKD)24R
LH2)X86
D4N)CCC
1R2)N5J
LGF)YCQ
YL7)Y93
NCG)7NJ
RR2)MNR
24R)FPK
H62)RC8
HRX)H53
ZKS)N86
B95)RS5
Z8Y)QY7
J21)YL8
T32)FL9
92L)PLW
41X)YLV
8NY)DQC
3FS)VVC
2F2)W4C
PH4)WGK
TS5)4WQ
YMS)RHC
FW6)PQG
L3F)RV3
6XN)KSR
BZ3)88B
QJ6)LTG
BQJ)7J3
B5P)L22
MWG)QQ8
R4B)MGY
G5L)46V
XNW)3JL
QY7)HZV
2HK)J38
Y8W)WQV
GBT)L7L
SZP)87F
FN6)RP1
43G)4H9
TTZ)ZP2
NV2)F3M
Y3J)9K9
87F)8HN
RXZ)PH4
5YL)QQQ
S5Q)388
RJR)5MS
DBV)7FQ
D7F)QQ9
VG5)N78
JSD)6YZ
C7B)TRM
KVB)P7C
HL7)WL3
HNW)75P
Z9K)H51
Z4V)43G
G2D)Q6D
C94)DBV
6MK)FYV
Z4X)P5K
T9M)D7F
D4B)PNW
LB3)JDK
F3M)LPV
NJN)Y18
FV7)HSQ
XRT)YQG
4ML)RJR
6YZ)2N3
JCG)HSX
6MN)5LQ
TX5)JXH
596)NRC
2LC)KMP
3ML)THS
BHH)ZQZ
WLK)62P
WSB)BBL
ZBT)J1T
R1F)DS2
KBK)BY4
BWN)ZW6
HPP)3SZ
STM)BRG
WFX)XGR
2X2)2HK
V51)V9K
8LF)Q6N
2RB)M6G
HMW)NKD
R7R)9VS
L2Z)JFZ
W8B)Z99
PCG)4SK
4YG)JHN
WC8)N5C
798)J6P
4XX)MZT
7K7)XJY
8QZ)111
QZT)551
HQC)7VS
D5Y)JGF
X3X)ZHM
8SD)TVZ
Y67)N44
1S1)P2G
1W4)4BH
RH1)8NV
9D6)4W1
NJN)L2Z
JXH)1CP
4L7)3C7
3SZ)YL5
TF4)53L
96V)KKD
8TS)NCJ
C8W)JHB
GWZ)WDM
1PL)CLT
QJX)VDD
R63)BJT
1Z4)HHF
VNM)STM
Y7C)3BP
NQM)9V2
WTK)NKM
PQZ)584
26Q)BZ3
L6Q)J23
W7Z)RXZ
ZHM)PBW
HFS)9CB
VVY)822
64W)27N
SPS)5ZD
JJM)TW4
M5K)7FM
5ZY)X3Q
5VT)SYG
QP4)Z4S
9V2)FRW
DTP)VVY
3YF)4NN
9GY)5MV
WH4)1R2
2CC)1WL
39N)MR4
X21)6MN
LTG)64W
RDK)FCQ
NQ6)7J6
K7Y)8S7
M79)PFH
C21)WTK
3X5)HWM
987)BTG
HYH)Y8L
XRT)LPK
JYS)HFS
S4G)6D7
N37)356
D9F)MWG
P43)F8L
RHC)P3S
MWG)NSZ
ST7)HYY
Z4S)RRX
D39)XJR
Y3L)4XX
5X2)79C
WL1)7Q5
KYS)RW4
Q87)74P
YDN)HNN
3XH)4LW
596)VWL
RW4)RCF
WCG)CNL
S9D)GHQ
G31)DST
9VY)WC8
4WQ)MLF
388)Y9Y
845)R7H
PWR)M2T
L61)4GP
LML)L3F
H1H)GZQ
C21)DLS
XB4)L53
N5J)NQM
THS)CSB
XGR)QCB
SPT)4FT
7FQ)WMP
13S)8QZ
BVH)WMC
GSN)7CQ
ZDY)ZBD
T2Q)5J3
J6P)R6W
N5C)4H7
KKD)YKQ
KBJ)P9J
14B)K27
N9F)HYS
2LG)G2D
3C7)S2G
HB9)XT1
QQX)K1K
47H)14B
48Q)FQW
STP)PWR
NWW)ZY5
63F)FRL
4W1)8G8
7W6)CVN
RPS)4NP
9HN)1MR
M96)454
8ZM)RVB
XVT)7YX
M6G)WVP
ZPR)BNN
Q83)6SS
FM2)YMS
P7R)59B
WTB)7RP
YT1)D27
PW6)QBQ
J2D)L9L
8G8)8Q3
L12)GBC
FQW)2RB
Z8T)D1X
HYS)QQX
63F)72B
34Z)DSG
2GK)3XH
F5K)LD1
DQ3)QVK
SL5)88N
XWP)7SF
NSZ)47H
1Z2)NT6
FYV)M7W
KHJ)91C
RKZ)FS3
P7C)GW6
BYN)33X
QZN)HRX
7J5)L6X
2X8)QH4
KHZ)BB6
NCJ)9FL
JHN)Y67
FC5)BYN
GRM)CYQ
NST)3SJ
VZL)3LQ
1VH)XKM
LQZ)YD8
CD5)LGK
32Y)3V7
CTH)56S
K27)VNM
4NP)C7B
VDK)DR4
ZGY)848
ZNL)M96
WVP)91F
RHC)2D1
53L)YXF
CCC)L9C
81J)K36
CCM)2HF
6LG)CWR
98D)S2R
N2F)1W4
DMP)DMT
BGS)2MP
BHD)D5Y
7VS)6LG
WSN)6SD
HYP)1CV
K58)FLX
2X7)Y8X
Q6D)Z4V
RCF)MTW
J5B)F5K
5V1)CP9
CSQ)ZC8
J9F)WQW
8NV)BSQ
8HV)S7S
ZP2)3MZ
1CY)WCG
RMW)HCL
46V)J5B
9QF)JYP
LPV)LQZ
K6M)ZTH
MZQ)VDM
N16)CD5
Y5W)GX3
XQC)QJ6
7CQ)CSF
79C)X23
W7G)798
J23)LSZ
5J3)K4L
67H)WM3
GJF)LMX
TJR)YLG
3LQ)29L
BY4)63F
YL5)MPJ
BZV)951
RJ1)VG5
RTY)KS9
51W)BDG
P66)H62
Y89)JT5
KM7)VPJ
CSF)9HN
X89)G9X
G9X)J9F
CTC)32Y
FLX)FWV
6PN)HMN
V8Y)ST7
ZZ3)2FT
J1T)JMT
FH7)PW6
Y93)CMF
DK2)LB3
SWN)WSB
Z6R)QS4
7LB)29W
5ZX)96V
D1X)KFJ
X23)9F5
2FT)PR3
YX8)HL7
NFY)ZZ3
756)Y6V
D2C)LP3
1MH)1HR
TFS)NFY
CMF)271
1PS)QVR
J1M)FW6
9QF)GYC
D27)SWN
WMC)2CC
J38)RPY
1HG)1MF
5LQ)B43
N4P)ZPS
PR3)FNP
4H7)T9M
3BR)SC6
K1X)GPR
9TP)948
YQG)BRK
JYP)S4G
D1Y)4J2
Y89)RG2
DVQ)XY9
DMT)2MJ
K27)TY1
88B)YDT
43N)HB9
MGY)1MH
YFR)CTH
74N)JYS
X86)JCG
948)GY2
7MR)5RL
PZL)GR4
32Y)QZN
K1T)987
5ZD)644
7X3)9R8
WGK)XQC
DLS)2X8
RHN)T2Q
GR4)1SJ
6DM)L7B
4NP)JBQ
KS9)YJX
YLG)X21
G1S)1R4
5ZP)8HV
D1Y)K7Y
8MW)WY3
QJX)X75
GY2)3DG
CV5)GBG
K36)X1M
BTG)N1K
RV3)PKZ
V9K)W11
22K)G1S
CMH)M8W
M1J)LMJ
CMN)XVT
BSQ)PMB
J6P)MH2
LL3)H7T
KR1)KWQ
M7W)NLS
RS5)P6B
1ND)Q26
JBQ)NV2
RPL)JCW
56S)NPJ
6YZ)XWP
52S)X5Y
Z99)1DF
L22)28X
GKJ)S9D
4GP)9QY
NSZ)HYP
45Q)3BR
RSD)61Y
356)Y89
P5K)797
C84)NST
CJG)LZC
1MR)DNQ
LDQ)YZ4
61Y)174
822)R1F
6PT)VB1
8YY)QDQ
VYG)X6C
HHF)T68
46F)M9V
1MR)B7C
2MP)LL3
CTK)YWZ
T98)WL1
14J)BHD
J9N)GWM
MZT)K28
RPL)FH7
T58)35F
DPP)4L7
RVB)DQ3
QBZ)BSY
TSB)PCG
RG2)L6N
8G8)S6P
DQ3)X6N
88N)ML3
6NF)3M4
JFG)F85
X3Q)8FS
96M)3YF
D4B)SAN
LD1)P6P
9B8)416
BJT)C74
QVR)XLT
B43)RPM
QS4)6RG
YD8)96R
8HN)1G5
RJ1)9B8
BRK)ZBT
BHH)RKZ
TGZ)2QQ
NWM)1N6
WWH)46F
LP3)SPS
28X)LNX
X2X)CMH
CP9)T43
9F5)9QW
2MP)7MR
26D)67H
951)RGQ
P6P)KYS
H3H)T6Y
PY6)N37
M9V)Y3L
V56)M29
XWM)DMP
B65)3VX
BBL)W7G
96W)KHW
JGF)VNS
6KR)NWG
7P8)TQ6
394)M79
7QK)YZZ
BZ6)1Z2
D41)14J
848)LDQ
HYY)JP5
S7S)8YF
7HW)KD6
TW4)BMN
VPJ)X89
QCB)R4H
QHX)Z6R
WRX)YT1
3BP)SPT
1HR)1Z7
9LR)26D
S5Q)2C3
9W5)HYH
72B)BZV
LMX)MLN
JFZ)TCD
271)82P
8YF)RCS
9W5)C94
XJY)2GK
KMP)NWM
LZC)2MG
LPK)7MB
S2G)14Y
BMN)5MR
YL8)TQQ
TW4)8LF
HWM)P7R
QQQ)KLG
VFV)BWN
LKN)RH1
V51)RKK
R7H)8S2
LLY)X2X
3W9)FRF
KTP)Y7C
DSG)5QT
7J3)NPB
1R2)HL2
CSB)HPP
X7H)NWW
BSY)F4S
RS5)GSN
F85)N62
HYP)X7H
ZTH)KR1
69D)PTP
CLT)9JZ
LT1)GRR
YXF)LT1
FNP)QFJ
HL2)6R1
ML3)KNR
LQ9)ZSD
84B)5ZX
Q5S)Z8T
6FJ)P43
RP1)19V
GW6)FZF
2DK)WCR
J9X)Q83
WQW)6TK
TS5)8P2
V5R)5H5
D9Z)7QK
B6X)T32
29W)VDB
MLF)WSN
COM)5M5
HZV)XWM
M2T)9TP
F4V)ZXJ
PNQ)NQ6
YLW)DVQ
9VS)CTK
6TK)3ML
SHK)8TS
RC8)596
NRC)JFG
9CB)84B
S2R)263
W11)8CJ
7Q5)7J5
S12)KBK
DBH)HLK
DS2)DXC
9QW)SHK
BPQ)M4G
SC6)VV6
NT6)X8W
584)G31
D7S)5X2
T6Y)CCM
JMT)LML
91F)1CY
CVN)J9X
TY2)VFV
RKK)RTQ
QZS)Z7G
MH2)XWW
ZVQ)DH7
VB1)HP5
H7T)3W9
XN6)51K
1N6)1S1
ZSD)HQC
CYQ)SZP
NZT)LGF
GBG)HNG
L6X)WH4
2LJ)FN6
JT5)XNS
Q17)C5C
3JL)D39
VDD)R7R
55P)XNW
S8K)7LB
N86)8YY
RPM)X3X
HCL)XH1
H53)J9N
Y4R)MZQ
7ZX)D9Z
HTP)Y3J
MTW)BWW
T1M)Q87
B8K)C8W
R9H)NCG
48X)T58
BZV)N2W
SYL)YFR
YCQ)FM2
ZXJ)2H8
644)2MW
1CV)BZ6
6YD)81J
LPK)KTP
QQ8)N4P
VDM)H1H
7FM)JJJ
VZN)V56
RPY)62F
6SD)K1T
2Y9)BQJ
76G)598
CNL)H3H
S7K)69D
YYJ)D4B
WMP)GPJ
XH1)KM7
TJS)S77
6VN)PY6
N44)5PS
G3G)GJF
9FV)M1J
ZCG)J9T
CSF)BBR
WCR)L6Q
2HF)Q7S
9FL)BGS
P3S)PQZ
79T)NJN
ZJY)9FV
P9J)2PH
X8W)96W
GZQ)XH6
WCG)B81
HNN)912
KLG)KBJ
NLS)19J
JCW)Y8W
62F)LLY
QH4)V5R
7NJ)WS7
TY1)DTS
MNR)39N
72B)RL2
DPP)TF4
KWQ)1VH
NPJ)74N
Z7G)RT6
5MR)CJG
82P)TJS
M29)YDN
9LR)C21
26D)NSS
RT6)Z8Y
19J)ZJY
J71)WFX
QDQ)QZS
YZZ)756
9JZ)KPD
3V7)QW6
T9K)QJX
8S2)5V1
Y18)6VN
S6P)TQS
X75)K8H
8CJ)Q3J
ZPS)LYC
454)RTY
PBW)STP
Q26)VDK
45Q)D9F
TVZ)9QF
N1K)T2S
L6N)Y5W
RTQ)RPS
SSY)LFY
TQS)WM8
Y6V)ZKS
Q83)VXD
VDB)SSR
F4S)CMN
NSV)GWZ
MDH)D41
MCT)XK8
32Q)C84
QQ9)PK9
QW6)T1M
LGK)HMW
B81)V8Y
5RL)4CF
3SJ)KGZ
6RG)VMN
416)ZPR
T1M)VZN
PTP)ZDY
C8P)N16
3F5)T98
BNN)DDZ
6D7)D2C
YDT)Q5S
N62)JWH
YSY)QBZ
VDK)W5N
1DF)5ZY
9K5)J21
X6C)1PS
MSZ)G4Z
3VX)Z4X
P2G)K58
L58)RSD
51K)W88
CQB)RDK
TCD)D4N
PLW)L12
78J)LKN
9FL)QHX
WY3)5XH
68Q)J71
4RT)K6M
2MG)ZH1
19V)32Q
YJX)9VY
GHQ)6MK
KNR)VMM
GRR)NSV
JJJ)8NY
2DM)2DK
4NN)7P8
PMB)JSD
XT1)RR2
GPR)VS4
CN8)N9F
DNQ)6XN
8Q9)TX5
MR4)YSY
DR4)8Q9
PNW)CSQ
VSV)ZNL
FCC)SSY
GX3)2LG
J6G)V9M
2QH)7W6
33X)FY9
QKS)78J
N37)2L1
LYC)SRV
CLW)43N
91F)92L
XJR)TFS
XLT)TSB
YKQ)J6G
5H5)15Z
HSX)7HW
ZC8)6YD
7J6)S8K
2RN)HNW
CN8)YYJ
KPD)7ZX
VXD)VYG
ZW6)7K7
5QT)XN6
2D1)B95
P6B)7QR
MPJ)48Q
CMH)8MW
57P)B5P
GYC)5QX
2L1)M5K
K8H)4V3
GRR)9LR
HL7)ZVQ
WS7)MCT
57P)FV7
RJR)PL4
5MV)CPJ
5PS)55P
HLK)4ML
LNX)ML6
2MJ)BPQ
2N3)WLK
WM3)GN9
WDM)3SM
YZ4)B8K
LFY)VVJ
15Z)9K5
CWR)TGZ
XBY)6NF
MLN)MPK
NRC)33P
VVJ)PZL
K1K)6FJ
Q6N)XBY
4CF)RJ1
3M4)NWC
JP5)DT8
62P)1PL
K28)S12
PQG)S5Q
X1M)Q17
RCS)6PN
WL3)FC5
L6X)S7K
NWC)2LJ
29L)CN8
4BH)9W5
NWG)555
VWL)RPL
FRL)VSV
YLV)394
FL9)2QH
8S7)M1K
VW2)TTZ
PL4)2Y9
VV6)SL5
14Y)D7S
74P)G6Y
SSR)YOU
Y8L)2RN
W4C)W7Z
ML6)PNQ
K1H)QP4
75P)ZGY
W5N)WTB
WQV)Y4R
2QQ)9D6
59B)C8P
CPJ)3FS
PFH)KHN
6SS)2F2
C74)4YG
SYG)DK2
ZBD)7X3
W91)13L
X6C)52S
T43)8SD
2PH)GBT
G4Z)GKJ
598)L58
6R1)34Z
DVN)6KR
VMM)687
