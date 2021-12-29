-- Leveraging dependencies already loaded into the lua tree by kong
local jwt_parser = require "kong.plugins.jwt.jwt_parser"
local redis = require "resty.redis"
local cjson = require "cjson"
local kong_constants = require "kong.constants"


local SESSION_KEY_PREFIX = "session:info:"


local _M = {}


local function is_present(str)
    return str and str ~= "" and str ~= null
end


local function set_session_headers(session_details)
    local set_header = kong.service.request.set_header
    local clear_header = kong.service.request.clear_header

    if session_details.userId then
        set_header("X-Authenticated-Userid", session_details.userId)
    else
        clear_header("X-Authenticated-Userid")
    end

    if session_details.username then
        set_header("X-Authenticated-Username", session_details.username)
    else
        clear_header("X-Authenticated-Username")
    end

    if session_details.displayName then
        set_header("X-Authenticated-Displayname", session_details.displayName)
    else
        clear_header("X-Authenticated-Displayname")
    end

    if session_details.userType then
        set_header("X-Authenticated-Usertype", session_details.userType)
    else
        clear_header("X-Authenticated-Usertype")
    end

    if session_details.globalPermissions then
        set_header("X-Authenticated-Global-Permissions", table.concat(session_details.globalPermissions, ","))
    else
        clear_header("X-Authenticated-Global-Permissions")
    end
end


local function load_session_details(session_key, redis)
    local key = SESSION_KEY_PREFIX .. session_key

    -- Get session
    local res, err =  redis:get(key)
    if not res or res == ngx.null or res == '' then
        return nil
    end

    local session_details = cjson.decode(res);


    -- Extend active session ttl
    local max_idle_time = session_details.maxIdleTime
    local res, err = redis:expire(key, (max_idle_time * 60))
    if res == 0 then
        kong.log.err("Failed to properly set a ttl on provided key.")
        return nil
    end

    return session_details
end


local function get_redis_connection(conf)
    local redis_client = redis:new()

    redis_client:set_timeout(conf.redis_timeout)

    local ok, err = redis_client:connect(conf.redis_host, conf.redis_port)
    if not ok then
        kong.log.err("Failed to connect to Redis: ", err)
        return nil, err
    end

    local times, err = redis_client:get_reused_times()
    if err then
        kong.log.err("Failed to get connection reused times: ", err)
        return nil, err
    end

    if times == 0 then
        if is_present(conf.redis_password) then
            local ok, err = redis_client:auth(conf.redis_password)
            if not ok then
                kong.log.err("Failed to properly authenticate to Redis.")
                return nil, err
            end
        elseif is_present(os.getenv("REDIS_PASSWORD")) then
            local ok, err = redis_client:auth(os.getenv("REDIS_PASSWORD"))
            if not ok then
                kong.log.err("Failed to properly authenticate to Redis.")
                return nil, err
            end
        end
    end

    return redis_client
end


local function get_payload(token)
    local jwt, err = jwt_parser:new(token)
    if err then
        return nil
    end

    return jwt.claims
end


local function session_timeout_error(conf)

    if conf.anonymous then
        -- get configured anonymous user
        local consumer_cache_key = kong.db.consumers:cache_key(conf.anonymous)
        local consumer, err = kong.cache:get(consumer_cache_key, nil, kong.client.load_consumer, conf.anonymous, true)

        if consumer then
            -- allow configured anonymous consumer upstream
            kong.client.authenticate(consumer, nil)
            return
        else
            kong.log.err("Failed to properly load configured consumer. Request unauthorized.")
        end
    end

    return kong.response.exit(401, {message = "Unauthorized. Session has ended."}, { ["Content-Type"] = "application/json" })
end


function _M.execute(conf)

    if kong.request.get_header(kong_constants.HEADERS.ANONYMOUS) then
        -- Authentication has already failed but anonymous consumer is configured on jwt plugin
        -- We will allow anonymous consumer to proceed as well
        return
    end


    local jwt_token = kong.ctx.shared.authenticated_jwt_token

    if not jwt_token then
        return session_timeout_error(conf)
    end

    local payload = get_payload(jwt_token)
    if not payload and not payload.sid then
        return kong.response.exit(500, {message = "An unknown error occurred while processing request."}, { ["Content-Type"] = "application/json" })
    end


    local redis, err = get_redis_connection(conf)
    if redis then

        local session_key = string.format("%s:%s", payload.iss, payload.sid)
        local session_details = load_session_details(session_key, redis)

        redis:set_keepalive(10000, 100)

        if not session_details then
            return session_timeout_error(conf)
        end

        set_session_headers(session_details)
    else
        return kong.response.exit(500, {message = "An unknown error occurred while processing request."}, { ["Content-Type"] = "application/json" })
    end
end


return _M