#!/usr/bin/env lua

local socket = require("socket")
local url = require("socket.url")

io.write("running in ", arg[1], " mode, listening on port ", arg[2], "\n")
if arg[1] == "udp" then
    -- udp
    local udp = socket.udp()
    udp:setsockname("*", arg[2])
    udp:settimeout(0)
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
elseif arg[1] == "tcp" then
    -- tcp
    local tcp = socket.tcp()
    tcp:bind("*", arg[2])
    tcp:listen()
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
