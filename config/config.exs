import Config

config :logger, :console,
  format: "$metadata[$level] $levelpad$message\n",
  level: :warn
