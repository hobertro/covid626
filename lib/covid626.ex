defmodule Covid626 do
  @san_gabriel_valley ["Alhambra", "Altadena", "Arcadia", "Avocado Heights", "Azusa", "Baldwin Park", 
  "Basset", "Bradbury", "Charter Oak", "Citrus", "Covina", "Duarte", "East Pasadena", "East San Gabriel",
  "El Monte", "Glendora", "Hacienda Heights", "City of Industry", "Industry", "Irwindale", "La Puente",
  "Mayflower Village", "Monrovia", "Monterey Park", "North El Monte", "El Monte", "Pasadena", "- Pasadena", "Rosemead",
  "Rowland Heights", "San Gabriel", "San Marino", "Sierra Madre", "South El Monte", "South Pasadena", "South San Gabriel",
  "South San Jose Hills", "Temple City", "Valinda", "Vincent", "Walnut", "West Covina", "West Puente Valley"]
  @la_county_gov "http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm"

  def get_data() do
    case make_http_request do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = body 
          |> Floki.find("tr")
          |> Enum.map(fn row ->
          {_, _, a} = row # pattern matching to only get the lists of relevant data
        a
        end)
         |> filter_for_sgv
         |> get_values_for_cities
IO.inspect response
        total = total_cases(response)
        {:ok, response, total}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{ reason: reason}} ->
        IO.inspect reason
    end
  end

  def make_http_request do
    HTTPoison.get(@la_county_gov)
  end

  def filter_for_sgv(list) do
    Enum.filter(list, fn value -> 
      [head | _] = value
      {_, _, list} = head
      [head | _] = list
      str = filter_misc_values(head)
      Enum.member?(@san_gabriel_valley, str)
    end)
  end

  def get_values_for_cities(list) do
    map = %{}
    response = Enum.each(list, fn value -> 
      [head | tail]  = value
      {_, _, city}   = head
      {_, _, number} = List.first(tail)
      city   = filter_misc_values(List.first(city))
      number = number_of_cases(List.first(number))
      if map[city] do
        Map.update(map, city, String.to_integer(map[city]), &(&1 + String.to_integer(number)))
      else
        Map.put(map, city, String.to_integer(number)) 
      end
    end)
  end

  # def get_values_for_cities(list) do
  #   Enum.map(list, fn value -> 
  #     [head | tail]  = value
  #     {_, _, city}   = head
  #     {_, _, number} = List.first(tail)
  #     city   = filter_misc_values(List.first(city))
  #     number = number_of_cases(List.first(number))x  
  #     %{city: city, number_of_cases: number}
  #   end)
  # end

  def number_of_cases(number) do
    if number == "--" do
      "0"
    else 
      number
    end
  end

  def filter_misc_values(city) do
    String.replace_leading(city, "- ", "")
     |> String.replace_leading("City of ", "")
     |> String.replace_leading("Unincorporated - ", "")
     |> String.replace_trailing("***", "")
     |> String.replace_trailing("**", "")
     |> String.replace_trailing("*", "")
  end

  def total_cases(list) do
    Enum.reduce(list, 0, fn(map, acc) ->
      acc + String.to_integer(map[:number_of_cases])
    end)
  end
end
