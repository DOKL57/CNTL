defmodule Cntl.Repo do
  use Ecto.Repo,
    otp_app: :cntl,
    adapter: Ecto.Adapters.Postgres
end
