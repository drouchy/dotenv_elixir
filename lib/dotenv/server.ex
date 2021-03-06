defmodule Dotenv.Server do
  use GenServer.Behaviour

  def start_link(env_path) do
    :gen_server.start_link({:local, :dotenv}, __MODULE__, env_path, [])
  end

  def init(env_path) do
    env = Dotenv.load!(env_path)
    {:ok, env}
  end

  def handle_cast(:reload!, env) do
    {:noreply, Dotenv.load!(env.paths)}
  end

  def handle_cast({:reload!, env_path}, _env) do
    {:noreply, Dotenv.load!(env_path)}
  end

  def handle_call(:env, _from, env) do
    {:reply, env, env}
  end

  def handle_call({:get, key, fallback}, _from, env) do
    {:reply, env.get(key, fallback), env}
  end
end
