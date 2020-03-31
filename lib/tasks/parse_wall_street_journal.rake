# rake 'parse_wall_street_journal[BAC]'
desc 'Fetches & parses data from the Wall Street Journal'
task :parse_wall_street_journal, [:ticker] => :environment do |t, args|
  @ticker = args[:ticker]
  financials = {}
  financials = financials.deep_merge(parse_income_statement)
  financials = financials.deep_merge(parse_balance_sheet)
  financials = financials.deep_merge(parse_cash_flow_statement)
  puts financials
  financials
end


def parse_income_statement
  parser("https://www.wsj.com/market-data/quotes/#{@ticker}/financials/annual/income-statement", "income_statement")
end

def parse_balance_sheet
  parser("https://www.wsj.com/market-data/quotes/#{@ticker}/financials/annual/balance-sheet", "balance_sheet")
end

def parse_cash_flow_statement
  parser("https://www.wsj.com/market-data/quotes/#{@ticker}/financials/annual/cash-flow", "cash_flow_statement")
end


def parser(url, book)
  doc = Nokogiri::HTML(open(url))
  tables = doc.css('.cr_dataTable')
  info_line = doc.css('.fiscalYr').first
  if info_line.content.downcase =~ /millions/
    amounts_in = "millions"
  elsif info_line.content.downcase =~ /thousands/
    amounts_in = "thousands"
  end
  reporting_months_extract = Date::MONTHNAMES.compact.map { |m| [m[0..2], m] }.to_h.map {|key, val| { month_name: val } if info_line.content.downcase =~ /#{val.downcase}/ }.compact
  headings_row = doc.css('thead').first.children.select {|t| t.content unless t.content.blank? }
  headings = headings_row.first.children.select {|t| t.content unless t.content.blank? }.drop(1).map{|col| {start_at: "#{col.content} #{reporting_months_extract[0][:month_name]}".to_datetime.at_beginning_of_month, end_at: "#{col.content} #{reporting_months_extract[1][:month_name]}".to_datetime.at_end_of_month, year_key: col.content}}[0..-2]
  reports = {
    amounts_in: amounts_in
  }
  tables.each_with_index do |table, index|

    table_rows = table.css('tr').select { |row| row.content unless row.content.blank?}.compact
    raw_financials = table_rows.drop(1).select {|t| t.content unless t.content.blank? }
    financials = []
    raw_financials.each do |item|
      financials << item.children.select { |row| row.children unless row.children.blank?}.compact
    end

    headings.each_with_index do |heading, key|
      reports[heading[:year_key].to_sym] = {
        statement_open_at: heading[:start_at],
        statement_end_at: heading[:end_at]
      } if reports[heading[:year_key].to_sym].blank?
      reports[heading[:year_key].to_sym][book.to_sym] = {} if reports[heading[:year_key].to_sym][book.to_sym].blank?


      financials.select { |row| row unless row[0].content.downcase.gsub(/[[:space:]]/, '') =~ /calculationpurpose/i }.compact.each do |fin|
        attr_name = fin[0].content.delete('^a-zA-Z').gsub(' ', '').underscore
        value = fin[key + 1].content
        if value =~ /%/i
          value = (value.delete('^0-9.').to_f / 100.to_f).to_f
        elsif value.starts_with?('(')
          value = "-#{value.delete('^0-9.%')}".to_f
        else
          value = value.delete('^0-9.%').to_f
        end
        reports[heading[:year_key].to_sym][book.to_sym][attr_name.to_sym] = BigDecimal(value, 2)
      end
    end
  end
  reports
end
