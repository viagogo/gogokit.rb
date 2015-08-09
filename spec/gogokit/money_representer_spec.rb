require 'spec_helper'

describe 'GogoKit::MoneyRepresenter' do
  it 'should map money amount' do
    expected_amount = 23.45
    money_json = "{\"amount\": #{expected_amount}, \"currency_code\": \"USD\"" \
                 ",\"display\": \"$19.36\"}"
    representer = GogoKit::Money.new.extend(GogoKit::MoneyRepresenter)
    money = representer.from_json(money_json)

    expect(money.amount).to eq(expected_amount)
  end

  it 'should map money currency_code' do
    expected_currency_code = 'EXP'
    money_json = "{\"amount\": 19.36, \"currency_code\":" \
                 "\"#{expected_currency_code}\", \"display\": \"$19.36\"}"
    representer = GogoKit::Money.new.extend(GogoKit::MoneyRepresenter)
    money = representer.from_json(money_json)

    expect(money.currency_code).to eq(expected_currency_code)
  end

  it 'should map money display' do
    expected_display = '$23.45'
    money_json = "{\"amount\": 19.36, \"currency_code\": \"USD\"" \
                 ",\"display\": \"#{expected_display}\"}"
    representer = GogoKit::Money.new.extend(GogoKit::MoneyRepresenter)
    money = representer.from_json(money_json)

    expect(money.display).to eq(expected_display)
  end
end
