using HttpServer

http = HttpHandler() do req, res
    open(readall, "presentation.html")
end

run(Server(http), 8000)
