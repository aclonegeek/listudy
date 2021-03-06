defmodule ListudyWeb.EventSearchLive do
  use Phoenix.LiveView

  alias Listudy.Events
  import ListudyWeb.Gettext
  alias ListudyWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <h1><%= dgettext("events", "Events") %></h1>
    <form phx-change="suggest" phx-submit="search">
      <input class="big_search" type="text" name="q" value="<%= @query %>" list="matches" placeholder="<%= dgettext("events", "Search")%>..." autocomplete="off"/>
      <br>
      <%= for match <- @matches do %>
        <a href="<%= Routes.event_path(@socket, :show, @locale, match.slug) %>"><%= match.name %></a>
        <br>
      <% end %>
    </form>
    """
  end

  def mount(%{"locale" => locale}, _session, socket) do
    result = Events.search_by_title("")
    Gettext.put_locale(ListudyWeb.Gettext, locale)
    socket = assign(socket, noindex: true)
    {:ok, assign(socket, query: nil, matches: result, locale: locale)}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    result = Events.search_by_title(query)
    {:noreply, assign(socket, matches: result)}
  end
end
