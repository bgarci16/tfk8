local access = require "kong.plugins.tf-session.access"


local TFSessionHandler = {
    VERSION  = "1.0.0",
    PRIORITY = 999 -- Needs to run after consumer has been authenticated and before request termination
}


function TFSessionHandler:access(conf)
    return access.execute(conf)
end


return TFSessionHandler