defmodule Covid626.Repo do
  use Ecto.Repo,
    otp_app: :covid626,
    adapter: Ecto.Adapters.Postgres
end
