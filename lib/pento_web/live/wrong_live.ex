defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    {:ok, assign(socket, score: 0, message: "Make a guess:", seconds: 0)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1

    {:noreply, assign(socket, message: message, score: score)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= time() %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
          text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <h2>
      Pomodoro
    </h2>
    <div><%= @seconds %></div>

    <button phx-click="start-clock">Start</button>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("start-clock", params, socket) do
    {:noreply, socket |> assign(seconds: 15)}
  end

  def handle_info(:tick, %{assigns: %{seconds: 0}} = socket) do
    {:noreply, socket |> assign(:seconds, 0)}
  end

  def handle_info(:tick, %{assigns: %{seconds: seconds}} = socket) do
    {:noreply, socket |> assign(:seconds, seconds - 1)}
  end
end
