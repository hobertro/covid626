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
  def parse_item(response) do
    urls = response.body
     |> Floki.find("a.more")
     |> Floki.attribute("href")
    requests = Enum.map(urls, fn url ->
      url
       |> build_absolute_url(response.request_url)
       |> Crawly.Utils.request_from_url()
    end)
    title = 
     response.body
      |> Floki.find("article.blog_post h1:first-child")
      |> Floki.text()
    author =
     response.body
      |> Floki.find("article.blog_post p.subheading")
      |> Floki.text(deep: false, sep: "")
      |> String.trim_leading()
      |> String.trim_trailing()
    
    text = Floki.find(response.body, "article.blog_post") |> Floki.text()
    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{title: title, author: author, text: text, url: response.request_url}
      ] 
    }
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url) |> to_string()
  end
end