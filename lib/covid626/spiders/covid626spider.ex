defmodule Covid626Spider do
  @behaviour Crawly.Spider

  @impl Crawly.Spider

  def base_url() do
    "https://www.erlang-solutions.com"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: ["https://erlang-solutions.com/blog.html"]
    ]
  end

  @impl Crawly.Spider
  def parse_item(_response) do
    %Crawly.ParsedItem{:items => [], :requests => []}
  end
end