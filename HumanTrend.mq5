#property copyright "Copyright 2026, JanMihail"
#property version "1.00"

#property indicator_separate_window
#property indicator_minimum -1
#property indicator_maximum 1

#property indicator_buffers 2
#property indicator_plots 1

#property indicator_type1 DRAW_HISTOGRAM
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2

#include "ChartDrawer.mqh"
#include "Logger.mqh"

//--- input parameters
input int MA1_PERIOD = 10;
input int MA2_PERIOD = 20;
input int MA_DELTA_FOR_START_TREND_PIPS = 200;
input int MA_DELTA_FOR_FINISH_BY_TOUCH_PIPS = 200;    // Максимальное расстояние между скользящими
input double MA_DELTA_FOR_FINISH_SUZGENIE_KOEF = 0.5; // Коэффициент сужения больше которого закрытие тренда

namespace HumanTrend {

enum TrendStatus {
    TREND_STATUS_FIND_START, // Поиск начала тренда
    TREND_STATUS_FIND_FINISH // Поиск конца тренда
};

TrendStatus trendStatus;

//--- indicator buffers
double trendBuffer[];
double deltaMax; // Максимальное расстояние между скользящими в моменте

//--- MA1
int maHandle1;
double maBuffer1[];

//--- MA2
int maHandle2;
double maBuffer2[];

int OnInit() {

    trendStatus = TREND_STATUS_FIND_START;

    //--- indicator buffers mapping
    SetIndexBuffer(0, trendBuffer, INDICATOR_DATA);
    deltaMax = 0.0;

    //--- MA1
    maHandle1 = iMA(Symbol(), PERIOD_CURRENT, MA1_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
    if (maHandle1 == INVALID_HANDLE) {
        Logger::error("Ошибка создания MA1");
        Logger::printLastError(__FUNCSIG__, __LINE__);
        return (INIT_FAILED);
    }
    ChartIndicatorAdd(0, 0, maHandle1);

    //--- MA2
    maHandle2 = iMA(Symbol(), PERIOD_CURRENT, MA2_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
    if (maHandle2 == INVALID_HANDLE) {
        Logger::error("Ошибка создания MA2");
        Logger::printLastError(__FUNCSIG__, __LINE__);
        return (INIT_FAILED);
    }
    ChartIndicatorAdd(0, 0, maHandle2);

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
    if (prev_calculated == 0) {
        return (rates_total);
    }

    //--- Пересчитываем индикаторы MA только при формировании новой свечи
    if (prev_calculated < rates_total) {
        RecalcMAs(rates_total);
    }

    for (int i = prev_calculated; i < rates_total; i++) {
        if (trendStatus == TREND_STATUS_FIND_FINISH) {

            //---Актуализация deltaMax
            double delta = MathAbs(maBuffer1[i - 1] - maBuffer2[i - 1]);
            deltaMax = MathMax(delta, deltaMax);

            double suzgenieKoef = 1 - (delta / deltaMax);

            if (suzgenieKoef > MA_DELTA_FOR_FINISH_SUZGENIE_KOEF) {
                trendBuffer[i] = 0;
                trendStatus = TREND_STATUS_FIND_START;

                ChartDrawer::drawRightPriceLabel(time[i], close[i], clrRed, 2, false);
            } else {
                bool isBull = maBuffer1[i - 1] > maBuffer2[i - 1];
                trendBuffer[i - 1] = isBull ? 1 : -1;
            }

            break;
        }

        //--- Поиск начала тренда
        double delta1 = MathAbs(maBuffer1[i - 2] - maBuffer2[i - 2]);
        double delta2 = MathAbs(maBuffer1[i - 1] - maBuffer2[i - 1]);

        bool existTrend = delta2 > delta1 && delta2 > MA_DELTA_FOR_START_TREND_PIPS * _Point;
        bool isBull = existTrend && maBuffer1[i - 1] > maBuffer2[i - 1];

        trendBuffer[i - 1] = !existTrend ? 0 : isBull ? 1 : -1;

        if (existTrend) {
            trendStatus = TREND_STATUS_FIND_FINISH;
            deltaMax = delta2;

            ChartDrawer::drawLeftPriceLabel(time[i], close[i], clrGreen, 2, false);
        }
    }

    //--- Поиск конца тренда
    if (trendStatus == TREND_STATUS_FIND_FINISH) {
        int currentBarIdx = rates_total - 1;

        if (trendBuffer[currentBarIdx - 1] == 0) {
            Logger::error("Тренд в данном месте не может быть 0. БАГА!!!");
        }

        bool maDeltaForFinish = MathAbs(maBuffer1[currentBarIdx - 1] - maBuffer2[currentBarIdx - 1]) > MA_DELTA_FOR_FINISH_BY_TOUCH_PIPS * _Point;
        bool priceTouchMa1 = (trendBuffer[currentBarIdx - 1] == 1 && maBuffer1[currentBarIdx - 1] > close[currentBarIdx]) ||
                             (trendBuffer[currentBarIdx - 1] == -1 && maBuffer1[currentBarIdx - 1] < close[currentBarIdx]);

        if (maDeltaForFinish && priceTouchMa1) {
            trendBuffer[currentBarIdx] = 0;
            trendStatus = TREND_STATUS_FIND_START;

            ChartDrawer::drawRightPriceLabel(time[currentBarIdx], close[currentBarIdx], clrRed, 2, false);
        }
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