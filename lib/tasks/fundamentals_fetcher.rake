# rake fundamentals_fetcher
desc 'Runs weekly to fetch all fundamental data required'
task :fundamentals_fetcher => :environment do |t, args|
  # POPULATE THIS DATA FROM https://financialmodelingprep.com/api/v3/company/profile/AAPL by only asking for Ticker and calling API

  @ticker_array = Company.pluck(:ticker)
  update_income_statement
  update_balance_sheet
  update_cash_flows


end

def update_income_statement
  response = Faraday.get("https://financialmodelingprep.com/api/v3/financials/income-statement/#{@ticker_array.join(',')}")
  parsed_response = JSON.parse(response.body, object_class: OpenStruct)


  parsed_response.financials.each do |statement_item|
    company = Company.find_by(ticker: statement_item.symbol)
    statement_item.financials.each do |item|
      summary = Summary.find_or_create_by(company_id: company.id, date_key: date_parser(item.date))
      summary.update_attributes(
        revenue: item["Revenue"],
        earnings_before_tax: item["Earnings before Tax"] ,
        interest_expense: item["Interest Expense"] ,
        tax_expense: item["Income Tax Expense"] ,
        net_income: item["Net Income"] ,
        number_shares_outstanding: item["Weighted Average Shs Out (Dil)"] ,
        gross_margin: item["Gross Margin"] ,
        ebit: item["EBIT"]
      )
    end
  end
end

def update_balance_sheet
  response = Faraday.get("https://financialmodelingprep.com/api/v3/financials/balance-sheet-statement/#{@ticker_array.join(',')}")
  parsed_response = JSON.parse(response.body, object_class: OpenStruct)


  parsed_response.financialStatementList.each do |statement_item|
    company = Company.find_by(ticker: statement_item.symbol)
    statement_item.financials.each do |item|
      summary = Summary.find_or_create_by(company_id: company.id, date_key: date_parser(item.date))
      summary.update_attributes(
        cash_st_investments: BigDecimal(item['Cash and short-term investments']),
      )
    end
  end
end

def update_cash_flows
  cash_flow = Faraday.get("https://financialmodelingprep.com/api/v3/financials/cash-flow-statement/#{@ticker_array.join(',')}")
  parsed_cash_flow = JSON.parse(cash_flow.body, object_class: OpenStruct)


  parsed_cash_flow.financialStatementList.each do |cash_flow_item|
    company = Company.find_by(ticker: cash_flow_item.symbol)
    cash_flow_item.financials.each do |item|
      summary = Summary.find_or_create_by(company_id: company.id, date_key: date_parser(item.date))
      summary.update_attributes(
        free_cashflow: item["Free Cash Flow"],
        operating_cashflow: item["Operating Cash Flow"]
      )
    end
  end
end

def date_parser(t)
  if t =~ %r{(\d+)-(\d+)}
    Date.strptime(t, '%Y-%m').end_of_month
  else
    t.to_date
  end
end
