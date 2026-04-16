#property copyright "Copyright 2026, JanMihail"
#property version "1.00"

#property indicator_separate_window
#property indicator_minimum - 1
#property indicator_maximum 1

#property indicator_buffers 1
#property indicator_plots 1

#property indicator_type1 DRAW_HISTOGRAM
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2

//--- input parameters
input int Input1;
input int Input2;

//--- indicator buffers
double TrendBuffer[];

int OnInit() {
    //--- indicator buffers mapping
    SetIndexBuffer(0, TrendBuffer, INDICATOR_DATA);

    return (INIT_SUCCEEDED);
}

int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const datetime &time[],
    const double &open[],
    const double &high[],
    const double &low[],
    const double &close[],
    const long &tick_volume[],
    const long &volume[],
    const int &spread[]
) {

    for (int i = prev_calculated; i < rates_total; i++) {
        // PrintFormat("prev_calculated = %G, rates_total = %G", prev_calculated, rates_total);
        // PrintFormat("time = %G, open = %G, close = %G", time[i], open[i], close[i]);

        if (i == 0) {
            continue;
        }

        bool isDoji = open[i - 1] == close[i - 1];
        bool isBull = !isDoji && open[i - 1] < close[i - 1];

        TrendBuffer[i] = isDoji ? 0 : isBull ? 1 : -1;
    }

    //--- return value of prev_calculated for next call
    return (rates_total);
}
