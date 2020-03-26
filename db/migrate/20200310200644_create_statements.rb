class CreateStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :statements do |t|
      t.references   :company
      t.date         :reporting_date
      # Income statement
      t.decimal      :total_revenue, precision: 20, scale: 4
      t.decimal      :cost_of_revenue, precision: 20, scale: 4
      t.decimal      :gross_profit, precision: 20, scale: 4
      t.decimal      :research_development, precision: 20, scale: 4
      t.decimal      :selling_general_and_administrative, precision: 20, scale: 4
      t.decimal      :non_recurring, precision: 20, scale: 4
      t.decimal      :others, precision: 20, scale: 4
      t.decimal      :total_operating_expenses, precision: 20, scale: 4
      t.decimal      :operating_income_or_loss, precision: 20, scale: 4
      t.decimal      :total_other_income_expenses_net, precision: 20, scale: 4
      t.decimal      :earnings_before_interest_and_taxes, precision: 20, scale: 4
      t.decimal      :interest_expense, precision: 20, scale: 4
      t.decimal      :income_before_tax, precision: 20, scale: 4
      t.decimal      :income_tax_expense, precision: 20, scale: 4
      t.decimal      :minority_interest, precision: 20, scale: 4
      t.decimal      :net_income_from_continuing_ops, precision: 20, scale: 4
      t.decimal      :discontinued_operations, precision: 20, scale: 4
      t.decimal      :extraordinary_items, precision: 20, scale: 4
      t.decimal      :effect_of_accounting_changes, precision: 20, scale: 4
      t.decimal      :other_items, precision: 20, scale: 4
      t.decimal      :net_income, precision: 20, scale: 4
      t.decimal      :preferred_stock_and_other_adjustments, precision: 20, scale: 4
      t.decimal      :net_income_applicable_to_common_shares, precision: 20, scale: 4
      # Balance Sheet
      t.decimal      :cash_and_cash_equivalents, precision: 20, scale: 4
      t.decimal      :short_term_investments, precision: 20, scale: 4
      t.decimal      :net_receivables, precision: 20, scale: 4
      t.decimal      :inventory, precision: 20, scale: 4
      t.decimal      :other_current_assets, precision: 20, scale: 4
      t.decimal      :total_current_assets, precision: 20, scale: 4
      t.decimal      :long_term_investments, precision: 20, scale: 4
      t.decimal      :property__plant_and_equipment, precision: 20, scale: 4
      t.decimal      :goodwill, precision: 20, scale: 4
      t.decimal      :intangible_assets, precision: 20, scale: 4
      t.decimal      :accumulated_amortization, precision: 20, scale: 4
      t.decimal      :other_assets, precision: 20, scale: 4
      t.decimal      :deferred_long_term_asset_charges, precision: 20, scale: 4
      t.decimal      :total_assets, precision: 20, scale: 4
      t.decimal      :accounts_payable, precision: 20, scale: 4
      t.decimal      :short_current_long_term_debt, precision: 20, scale: 4
      t.decimal      :other_current_liabilities, precision: 20, scale: 4
      t.decimal      :total_current_liabilities, precision: 20, scale: 4
      t.decimal      :long_term_debt, precision: 20, scale: 4
      t.decimal      :other_liabilities, precision: 20, scale: 4
      t.decimal      :deferred_long_term_liability_charges, precision: 20, scale: 4
      t.decimal      :negative_goodwill, precision: 20, scale: 4
      t.decimal      :total_liabilities, precision: 20, scale: 4
      t.decimal      :misc__stocks_options_warrants, precision: 20, scale: 4
      t.decimal      :redeemable_preferred_stock, precision: 20, scale: 4
      t.decimal      :preferred_stock, precision: 20, scale: 4
      t.decimal      :common_stock, precision: 20, scale: 4
      t.decimal      :retained_earnings, precision: 20, scale: 4
      t.decimal      :treasury_stock, precision: 20, scale: 4
      t.decimal      :capital_surplus, precision: 20, scale: 4
      t.decimal      :other_stockholder_equity, precision: 20, scale: 4
      t.decimal      :total_stockholders_equity, precision: 20, scale: 4
      t.decimal      :net_tangible_assets, precision: 20, scale: 4

      # Cash Flow Statement
      t.decimal      :depreciation, precision: 20, scale: 4
      t.decimal      :adjustments_to_net_income, precision: 20, scale: 4
      t.decimal      :changes_in_accounts_receivables, precision: 20, scale: 4
      t.decimal      :changes_in_liabilities, precision: 20, scale: 4
      t.decimal      :changes_in_inventories, precision: 20, scale: 4
      t.decimal      :changes_in_other_operating_activities, precision: 20, scale: 4
      t.decimal      :total_cash_flow_from_operating_activities, precision: 20, scale: 4
      t.decimal      :capital_expenditure, precision: 20, scale: 4
      t.decimal      :investments, precision: 20, scale: 4
      t.decimal      :other_cash_flows_from_investing_activities, precision: 20, scale: 4
      t.decimal      :total_cash_flows_from_investing_activities, precision: 20, scale: 4
      t.decimal      :dividends_paid, precision: 20, scale: 4
      t.decimal      :sale_purchase_of_stock, precision: 20, scale: 4
      t.decimal      :net_borrowings, precision: 20, scale: 4
      t.decimal      :other_cash_flows_from_financing_activities, precision: 20, scale: 4
      t.decimal      :total_cash_flows_from_financing_activities, precision: 20, scale: 4
      t.decimal      :effect_of_exchange_rate_changes, precision: 20, scale: 4
      t.decimal      :change_in_cash_and_cash_equivalents, precision: 20, scale: 4

      t.decimal      :weighted_average_diluted_shares_outst, precision: 20, scale: 4
      t.timestamps
    end
  end
end
