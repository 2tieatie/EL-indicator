Inputs: Length(20);

Vars: BB_basis(0), dev(0), BB_upper(0), BB_lower(0), KC_mult_high(1.0), KC_mult_mid(1.5), KC_mult_low(2.0),
      KC_basis(0), devKC(0), KC_upper_high(0), KC_lower_high(0), KC_upper_mid(0), KC_lower_mid(0), KC_upper_low(0),
      KC_lower_low(0), NoSqz(false), LowSqz(false), MidSqz(false), HighSqz(false),
      mom(0), mom_color(0), sq_color(0), Detect_Sqz_Start(true), Detect_Sqz_Fire(true);

BB_basis = Average(Close, Length);
dev = 2.0 * StandardDev(Close, Length, 1);
BB_upper = BB_basis + dev;
BB_lower = BB_basis - dev;
KC_basis = Average(Close, Length);
devKC = Average(MaxList(High - Low, AbsValue(High - Close[1]), AbsValue(Low - Close[1])), Length);

KC_upper_high = KC_basis + devKC * KC_mult_high;
KC_lower_high = KC_basis - devKC * KC_mult_high;
KC_upper_mid = KC_basis + devKC * KC_mult_mid;
KC_lower_mid = KC_basis - devKC * KC_mult_mid;
KC_upper_low = KC_basis + devKC * KC_mult_low;
KC_lower_low = KC_basis - devKC * KC_mult_low;

NoSqz = (BB_lower < KC_lower_low) or (BB_upper > KC_upper_low);
LowSqz = (BB_lower >= KC_lower_low) or (BB_upper <= KC_upper_low);
MidSqz = (BB_lower >= KC_lower_mid) or (BB_upper <= KC_upper_mid);
HighSqz = (BB_lower >= KC_lower_high) or (BB_upper <= KC_upper_high);

if HighSqz then
	sq_color = 255690
else if MidSqz then
	sq_color = 255
else if LowSqz then
	sq_color = 0
else
	sq_color = 65280;
PlotPB(5, -5, "SQZ", sq_color, 0, 10);
//Plot1(devKC, "devKC");
