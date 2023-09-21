Inputs:
    Length(20),
    BB_mult(2.0),
    KC_mult_high(1.0),
    KC_mult_mid(1.5),
    KC_mult_low(2.0),
    Detect_Sqz_Start(true),
    Detect_Sqz_Fire(true),
    Bar_width(10);

Variables:
    BB_basis(0),
    dev(0),
    BB_upper(0),
    BB_lower(0),
    KC_basis(0),
    devKC(0),
    KC_upper_high(0),
    KC_lower_high(0),
    KC_upper_mid(0),
    KC_lower_mid(0),
    KC_upper_low(0),
    KC_lower_low(0),
    NoSqz(false),
    LowSqz(false),
    MidSqz(false),
    HighSqz(false),
    mom(0),
    mom_color(0),
    mom_c_1(0),
    mom_c_2(0),
    sq_color(0),
    AvgHL(0),
    AvgClose(0),
    SumXY(0),
    SumX(0),
    SumY(0),
    SumX2(0);

BB_basis = Average(Close, Length);
dev = BB_mult * StdDev(Close, Length);
BB_upper = BB_basis + dev;
BB_lower = BB_basis - dev;

KC_basis = Average(Close, Length);
devKC = Average(TrueRange, Length);
KC_upper_high = KC_basis + devKC * KC_mult_high;
KC_lower_high = KC_basis - devKC * KC_mult_high;
KC_upper_mid = KC_basis + devKC * KC_mult_mid;
KC_lower_mid = KC_basis - devKC * KC_mult_mid;
KC_upper_low = KC_basis + devKC * KC_mult_low;
KC_lower_low = KC_basis - devKC * KC_mult_low;

Vars: oLRSlope(0), oLRAngle(0), oLRIntercept(0), oLRValueRaw(0);
Value1 = LinearReg (Close - ((Highest(high, length) + Lowest(low, length))/2 + average(close, length))/2, length, 0, oLRSlope, oLRAngle, oLRIntercept, oLRValueRaw);

mom = oLRIntercept + oLRSlope * (length - 1 - 0);

if Detect_Sqz_Start and (NoSqz[1] = False) and (NoSqz = True) then
    Alert("Squeeze Started");

if Detect_Sqz_Fire and (NoSqz = True) and (NoSqz[1] = False) then
    Alert("Squeeze Fired");
  
if mom > mom[1] then
    mom_c_1 = 16776960
else
    mom_c_1 = 8421376;
      
if mom < mom[1] then
    mom_c_2 = 255
else
    mom_c_2 = 65535;

if mom > 0 then
  mom_color = mom_c_1
else
  mom_color = mom_c_2;    

PlotPB(mom, 0, "MOM", mom_color, 0, Bar_width);


