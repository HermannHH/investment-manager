# rake 'parse_wall_street_journal[BAC]'
desc 'Fetches & parses data from the Wall Street Journal'
task :parse_wall_street_journal, [:ticker] => :environment do |t, args|
  @ticker = args[:ticker]
  # parse_income_statement
  parse_balance_sheet
end


def parse_income_statement

  doc = Nokogiri::HTML(open("https://www.wsj.com/market-data/quotes/#{@ticker}/financials/annual/income-statement"))
  # parsed_response = JSON.parse(response.body, object_class: OpenStruct)
  doc.css('.cr_dataTable').each do |link|
    puts link.content
  end
end


def parse_balance_sheet

  doc = Nokogiri::HTML(open("https://www.wsj.com/market-data/quotes/#{@ticker}/financials/annual/balance-sheet"))
  # parsed_response = JSON.parse(response.body, object_class: OpenStruct)
  data = {}
  tables = doc.css('.cr_dataTable')
  tables.each_with_index do |table, index|
    type = index == 1 ? "liabilities_and_shareholders_equity" : "assets"
    headings = table.css('th').select { |item| !item.content.blank?}[0..-2]
    cells = table.css('td').select { |item| !item.content.blank?}

    # heading.each do |heading|
    #   data
    # end
    # heading[0] - Start & end date
    # heading[0] - Amount multiplier
    # Rest of headings - years
    # ---Loop through cells
    # cell[0] - attrib
    #  Rest of cells - value per year

    # STEP 1 - dates = Date::MONTHNAMES.compact.map { |m| [m[0..2], m] }.to_h
    # STEP 2 - dt = dates.map {|key, val| { month_name: val } if heading[0].downcase =~ /#{val.downcase}/ }.compact
    # STEP 3 - start_time = dt[0][:month_name].to_datetime end_time = dt[1][:month_name].to_datetime
    binding.pry
  end
end
