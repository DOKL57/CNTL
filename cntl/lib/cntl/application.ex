defmodule Cntl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CntlWeb.Telemetry,
      Cntl.Repo,
      {DNSCluster, query: Application.get_env(:cntl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cntl.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cntl.Finch},
      # Start a worker by calling: Cntl.Worker.start_link(arg)
      # {Cntl.Worker, arg},
      # Start to serve requests, typically the last entry
      CntlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cntl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CntlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
