require 'nokogiri'
require 'open-uri'

class YahooFinanceScraperService

  def initialize(ticker)
    @ticker = ticker
  end

  def parse_profile_data
    doc = Nokogiri::HTML(open("https://finance.yahoo.com/quote/#{@ticker}/profile?p=#{@ticker}"))
    asset_profile_container = doc.css(".asset-profile-container").css("div")
    name = asset_profile_container.css("h3").text
    sector_block = asset_profile_container.css("div p")[1]
    sector_spans = sector_block.css("span")
    sector = sector_spans[1].text
    industry = sector_spans[3].text

    description = doc.css(".quote-sub-section").css("p").text

    {
      name: name,
      sector: sector,
      industry: industry,
      description: description
    }.to_hash
  end

  def merge_statement_data
    income_statement = parse_income_statement
    balance_sheet = parse_balance_sheet
    cash_flow_statement = parse_cash_flow_statement
    merged = income_statement + balance_sheet + cash_flow_statement
    grouped = merged.group_by{ |d| d[:reporting_date] }
    grouped.map { |k,v| v.reduce({}, :merge) }
  end

  def parse_price_data
    doc = Nokogiri::HTML(open("https://finance.yahoo.com/quote/#{@ticker}?p=#{@ticker}"))
    left_summary_table = doc.css("[data-test=left-summary-table]")
    right_summary_table = doc.css("[data-test=right-summary-table]")

    last_closing_price_row = left_summary_table.css('table tbody tr')[0]
    last_closing_price = last_closing_price_row.css('td')[1].text

    three_y_monthly_beta_row = right_summary_table.css('table tbody tr')[1]
    three_y_monthly_beta = three_y_monthly_beta_row.css('td')[1].text

    {
      last_closing_price: parse_value(last_closing_price),
      three_y_monthly_beta: parse_value(three_y_monthly_beta)
    }.to_hash

  end

  def parse_income_statement
    line_items = parse_line_items("https://finance.yahoo.com/quote/#{@ticker}/financials?p=#{@ticker}")
  end

  def parse_balance_sheet
    line_items = parse_line_items("https://finance.yahoo.com/quote/#{@ticker}/balance-sheet?p=#{@ticker}")
  end

  def parse_cash_flow_statement
    line_items = parse_line_items("https://finance.yahoo.com/quote/#{@ticker}/cash-flow?p=#{@ticker}")
  end

  private

    def parse_value(v)
      if v =~ %r{(\d+)/(\d+)/(\d+)}
        v.to_date
      else
        v.gsub(',','').to_d
      end
    end

    def parse_line_items(url)
      line_items = []
      doc = Nokogiri::HTML(open(url))
      rows = doc.css("[data-test=qsp-financial]").css("div table tr")
      dates = rows[0].css('td')
      dates.shift
      dates.each do |d|
        line_items.push(
          reporting_date: Date.strptime(d.text, "%m/%d/%Y").to_s
        )
      end
      rows.shift
      rows.each do |row|
        cols = row.css('td')
        clean_cols = cols.reject do |col| !col['colspan'].blank? end
        label = clean_cols[0]&.text
        unless label.blank?
          clean_cols.shift
          line_items.each_with_index do |line_item, index|
            line_item[label.gsub(' ', '_').gsub(".", "_").gsub("/", "").gsub(",", "_").gsub("'", "").underscore.to_sym] = parse_value(clean_cols[index].text)
          end
        end
      end
      line_items
    end

end
