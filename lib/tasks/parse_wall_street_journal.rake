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
  tables = doc.css('.cr_dataTable')

  info_line = doc.css('.fiscalYr').first
  reporting_months_extract = Date::MONTHNAMES.compact.map { |m| [m[0..2], m] }.to_h.map {|key, val| { month_name: val } if info_line.content.downcase =~ /#{val.downcase}/ }.compact
  headings_row = doc.css('thead').first.children.select {|t| t.content unless t.content.blank? }
  headings = headings_row.first.children.select {|t| t.content unless t.content.blank? }.drop(1).map{|col| {start_at: "#{col.content} #{reporting_months_extract[0][:month_name]}".to_datetime.at_beginning_of_month, end_at: "#{col.content} #{reporting_months_extract[1][:month_name]}".to_datetime.at_end_of_month, year_key: col.content}}[0..-2]

  reports = {}
  tables.each_with_index do |table, index|
    table_rows = table.css('tr').select { |row| row.content unless row.content.blank?}.compact
    raw_financials = table_rows.drop(1).select {|t| t.content unless t.content.blank? }
    financials = []
    raw_financials.each do |item|
      financials << item.children.select { |row| row.children unless row.children.blank?}.compact
    end
    headings.each_with_index do |heading, key|
      reports[heading[:year_key].to_sym] = {}
      financials.each do |fin|
        attr_name = fin[0].content.gsub(' ', '').underscore
        value = fin[key + 1].content
        # Clean percentage
        if value =~ /%/i
          value = value.tr("%","").to_f / 100
        elsif value.starts_with?('(')
          value = "-#{value.delete('^0-9')}".to_i
        else
          value = value.delete('^0-9').to_i
        end
        # value = BigDecimal(value.delete('^0-9'), 6)
        reports[heading[:year_key].to_sym][attr_name.to_sym] = value
      end
    end
  end
  puts reports
  reports
end
