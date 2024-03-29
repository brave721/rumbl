defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias RumblWeb.Auth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
