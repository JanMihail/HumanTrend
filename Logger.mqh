//###<Indicators/HumanTrend/HumanTrend.mq5>

class Logger {

private:
    static void log(string level, string message) {
        PrintFormat("%s: %s", level, message);
    }

public:
    static void printLastError(string functionName, int lineNumber) {
        log("FATAL ERROR", StringFormat("func: %s, line: %d, errorCode: %d", functionName, lineNumber, GetLastError()));
    }

    static void debug(string message) {
        log("DEBUG", message);
    }

    static void info(string message) {
        log("INFO", message);
    }

    static void warn(string message) {
        log("WARN", message);
    }

    static void error(string message) {
        log("ERROR", message);
    }
};
