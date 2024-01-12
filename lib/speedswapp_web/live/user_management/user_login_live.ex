defmodule SpeedswappWeb.UserLoginLive do
  use SpeedswappWeb, :live_view

  def render(assigns) do
    ~H"""
    <.container>
      <h5 class="text-xl font-semibold tracking-tight text-gray-100">Account settings</h5>
      <p class="text-zinc-200">
        Don't have an account?
        <.link navigate={~p"/users/register"} class="font-semibold text-white hover:underline">
          Sign up
        </.link>
        for an account now.
      </p>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm text-white font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </.container>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
