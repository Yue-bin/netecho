#!/usr/bin/env lua

local socket = require("socket")
local url = require("socket.url")

local proto = "tcp"
local port = 0

if not arg[2] then
    port = tonumber(arg[1]) or 0
else
    proto = arg[1]
    port = tonumber(arg[2]) or 0
end

-- 兼容性考虑：若不支持math.tointeger，则跳过整型检查
math.tointeger = math.tointeger or function() return true end
if (proto == "udp" or proto == "tcp") and (math.tointeger(port) and port > 0 and port < 65536) then
    io.write("running in ", proto, " mode, listening on port ", port, "\n")
    if proto == "udp" then
        -- udp
        local udp = socket.udp()
        udp:setsockname("*", port)
        udp:settimeout(0)
        port = nil
        while true do
            local data, ip, port = udp:receivefrom()
            if data then
                data = url.escape(data)
                print("received: \"" .. data .. "\" from " .. ip .. ":" .. port)
                data = "echo: \"" .. data .. "\" to " .. ip .. ":" .. port .. "\n"
                print(data)
                udp:sendto(data, ip, port)
            end
            socket.sleep(0.01)
        end
    elseif proto == "tcp" then
        -- tcp
        local tcp = socket.tcp()
        tcp:bind("*", port)
        tcp:listen()
        port = nil
        while true do
            local client = tcp:accept()
            local ip, port, nettype = client:getpeername()
            print("connected with " .. ip .. ":" .. port .. " using " .. nettype)
            client:send("connection established, you are " .. ip .. ":" .. port .. " using " .. nettype .. "\n")
            repeat
                local data = client:receive()
                if data then
                    print("received: \"" .. data .. "\"")
                    data = "echo: \"" .. data .. "\"\n"
                    print(data)
                    client:send(data)
                end
            until not data
            print("closing connection\n")
            client:close()
        end
    end
else
    io.stderr:write("usage: ", arg[0], " [tcp|udp] port\n")
end
