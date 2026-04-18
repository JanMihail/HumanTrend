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

#include "Logger.mqh"

namespace HumanTrend {

//--- input parameters
input int MA1_PERIOD = 10;
input int MA2_PERIOD = 20;
input int MA_DELTA_PIPS = 200;

//--- indicator buffers
double TrendBuffer[];

//--- MA1
int maHandle1;
double maBuffer1[];

//--- MA2
int maHandle2;
double maBuffer2[];

int OnInit() {
    //--- indicator buffers mapping
    SetIndexBuffer(0, TrendBuffer, INDICATOR_DATA);

    //--- MA1
    maHandle1 = iMA(Symbol(), PERIOD_CURRENT, MA1_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
    if (maHandle1 == INVALID_HANDLE) {
        Logger::error("Ошибка создания MA1");
        Logger::printLastError(__FUNCSIG__, __LINE__);
        return (INIT_FAILED);
    }
    // ChartIndicatorAdd(0, 0, maHandle1);

    //--- MA2
    maHandle2 = iMA(Symbol(), PERIOD_CURRENT, MA2_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
    if (maHandle2 == INVALID_HANDLE) {
        Logger::error("Ошибка создания MA2");
        Logger::printLastError(__FUNCSIG__, __LINE__);
        return (INIT_FAILED);
    }
    // ChartIndicatorAdd(0, 0, maHandle2);

    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    IndicatorRelease(maHandle1);
    IndicatorRelease(maHandle2);

    Logger::info("Deinitialize complete! ReasonCode: " + IntegerToString(reason));
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
    RecalcMAs(rates_total);

    for (int i = prev_calculated; i < rates_total; i++) {

        if (i == 0) {
            continue;
        }

        Logger::info(StringFormat("i = %d, time = %s, MA1: %G, MA2: %G", i, TimeToString(time[i]), maBuffer1[i - 1], maBuffer2[i - 1]));

        bool existTrend = MathAbs(maBuffer1[i - 1] - maBuffer2[i - 1]) > MA_DELTA_PIPS * _Point;
        bool isBull = existTrend && maBuffer1[i - 1] > maBuffer2[i - 1];

        TrendBuffer[i] = !existTrend ? 0 : isBull ? 1 : -1;
    }

    //--- return value of prev_calculated for next call
    return (rates_total);
}

void RecalcMAs(const int bufferSize) {
    int res = CopyBuffer(maHandle1, 0, 0, bufferSize, maBuffer1);

    if (res < 0) {
        Logger::error("Ошибка копирования буфера MA1");
        Logger::printLastError(__FUNCSIG__, __LINE__);
    }

    res = CopyBuffer(maHandle2, 0, 0, bufferSize, maBuffer2);

    if (res < 0) {
        Logger::error("Ошибка копирования буфера MA2");
        Logger::printLastError(__FUNCSIG__, __LINE__);
    }
}

}