local TimerClass = {}

local Utils = import "Utils"

local RunService = game:GetService("RunService")


function TimerClass.new(): Timer
    local Timer = {}

    Timer.Tick = 0
    Timer.Time = 0

    function Timer:Start(Callback: any)
        assert(typeof(Callback) == "function", "type 'function' expected for 'Callback', got '" .. typeof(Callback) .. "'")
        self.Tick = os.clock()
        self.Callback = Callback

        self._Heartbeat = RunService.Heartbeat:Connect(function()
            self.Time = Utils.math_round(os.clock() - self.Tick, 2)
            self:Callback()
        end)


        function self:Start()
            error("attempted to start a timer more than once")
        end
    end

    function Timer:Destroy()
        self.Time = 0 -- do we really need to
        self._Heartbeat:Disconnect()
    end

    return Timer
end


return TimerClass