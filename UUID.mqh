//###<Indicators/HumanTrend/HumanTrend.mq5>

namespace HumanTrend {

class UUID {

public:
    static string randomUuid() {
        ulong tickCount = GetMicrosecondCount();
        ulong uniqueId;
        do {
            uniqueId = ((ulong)TimeLocal() << 4) + tickCount;
        } while (tickCount == GetMicrosecondCount());
        return (string) uniqueId;
    }
};

}