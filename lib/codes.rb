Stormy = %w(A-- A- A A+ A+N A--N A-N AN TR- TR-- TR TR+ TR+N TR-N TR--N TRN TRW- TRW-- TRW TRW+ TRW+N T T+ T+N TN Q- Q Q+ Q+N Q-N QN)
Rainy = %w(L L-- L- L+ L+N LN L--N L-N RW RW- RW-- RW+ RW+N RWN RW-N RW--N R-- R- R R+ R+N R--N R-N RN)
Vary = %w(B BD BDN BN BNN D DN IF IFN K KN -OVC -OVCN ZF ZFN)
Cloudy = %w(TF TH OVC OVCN X XN BKN)
Sunny = %w(-BKN -BKNN BKNN CLR CLRN H HN -SCT SCT -SCTN SCTN)
Foggy = %(FS FN)
Mixed = %w(G G- G+ G+N GN G-N I I- I+ I+N M M+ M+N MN IN I-N)
Snowy = %w(BS BSN IC ICN IP- IP-- IP IP+ IP+N IP-N IP--N IPN IPW IPW- IPW-- IPW+ IPW+N IPWN IPW-N IPW--N N- N N+ N+N N-N NN P- P P+ P+N P-N PN RS R-S R-S- RS- RSN R-SN R-S-N RS-N S-- S- S S+ S+N SG- SG-- SG SG+ SG+N SG-N SG--N SGN S--N S-N SN SP- SP-- SP SP-N SP--N SPN SW SW- SW-- SW+ SW+N SWN SW-N SW--N T- T-N U- U U+ U+N U-N UN V V- V+ V+N VN V-N W W- W+ W+N WN W-N Y- Y Y+ Y+N Y-N YN Z- Z Z+ Z+N ZL ZL- ZL-- ZL+ ZL+N ZLN ZL-N ZL--N Z-N ZN ZR- ZR-- ZR ZR+ ZR-N ZR--N)

module Condition
  def self.for(code)
    return :cloudy if Cloudy.include?(code)
    return :stormy if Stormy.include?(code)
    return :rainy if Rainy.include?(code)
    return :vary if Vary.include?(code)
    return :sunny if Sunny.include?(code)
    return :foggy if Foggy.include?(code)
    return :mixed if Mixed.include?(code)
    return :snowy if Snowy.include?(code)
  end
end
