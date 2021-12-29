local typedefs = require "kong.db.schema.typedefs"


return {
  name = "tf-session",
  fields = {
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          { anonymous = { type = "string" }, },
          { redis_host = typedefs.host({ required = true }) },
          { redis_port = typedefs.port({ required = true, default = 6379 }) },
          { redis_password = {
              type = "string",
              len_min = 0 },
          },
          { redis_timeout = {
              type = "number",
              required = true,
              default = 15000
            }
          },
        },
      },
    },
  },
}
