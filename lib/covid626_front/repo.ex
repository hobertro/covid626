defmodule Covid626Front.Repo do
  use Ecto.Repo,
    otp_app: :covid626_front,
    adapter: Ecto.Adapters.Postgres
end
