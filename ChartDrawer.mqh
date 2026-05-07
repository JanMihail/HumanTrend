//###<Indicators/HumanTrend/HumanTrend.mq5>

#include "Logger.mqh"
#include "UUID.mqh"

namespace HumanTrend {

class ChartDrawer {

public:
    static string drawSymbol(datetime x, double y, int symbolCode, color vColor, ENUM_ARROW_ANCHOR anchor) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_ARROW, 0, x, y)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_ARROWCODE, symbolCode)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_ANCHOR, anchor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }

    static string drawLeftPriceLabel(datetime x, double y, color vColor, int width, bool onTheBackOrder) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_ARROW_LEFT_PRICE, 0, x, y)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_WIDTH, width)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_BACK, onTheBackOrder)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }

    static string drawRightPriceLabel(datetime x, double y, color vColor, int width, bool onTheBackOrder) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_ARROW_RIGHT_PRICE, 0, x, y)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_WIDTH, width)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_BACK, onTheBackOrder)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }

    static string drawLine(datetime x1, double y1, datetime x2, double y2, color vColor, int width) {
        return drawLine(x1, y1, x2, y2, vColor, width, STYLE_SOLID, false, false);
    }

    static string drawLine(datetime x1, double y1, datetime x2, double y2, color vColor, int width, ENUM_LINE_STYLE style, bool onTheBackOrder, bool rayRight) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_TREND, 0, x1, y1, x2, y2)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_WIDTH, width)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_STYLE, style)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_BACK, onTheBackOrder)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_RAY_RIGHT, rayRight)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }

    static string drawText(datetime x, double y, string value, color vColor, ENUM_ANCHOR_POINT anchor) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_TEXT, 0, x, y)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetString(0, objId, OBJPROP_TEXT, value)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_ANCHOR, anchor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetString(0, objId, OBJPROP_FONT, "Calibri")) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_FONTSIZE, 8)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }

    static string drawRect(datetime x1, double y1, datetime x2, double y2, color vColor, int width, ENUM_LINE_STYLE style, bool onTheBackOrder, bool vFill) {
        string objId = UUID::randomUuid();

        if (!ObjectCreate(0, objId, OBJ_RECTANGLE, 0, x1, y1, x2, y2)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_COLOR, vColor)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_WIDTH, width)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_STYLE, style)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_FILL, vFill)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        if (!ObjectSetInteger(0, objId, OBJPROP_BACK, onTheBackOrder)) {
            Logger::printLastError(__FUNCSIG__, __LINE__);
            return "";
        }

        ChartRedraw();
        return objId;
    }
};

}