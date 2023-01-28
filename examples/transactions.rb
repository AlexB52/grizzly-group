require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'faker'
  gem 'byebug'
  gem 'grizzly-rb', path: '.', require: 'grizzly'
end

require "bigdecimal"

# Model Definitions

Transaction = Struct.new(:date, :price, :shares, :holding, keyword_init: true) do
  def to_s
    line = "%s | %s | %4s | %2s x %s = %5s"
    format line, date, holding.ticker, type, shares.abs, price, value
  end

  def type
    shares.negative? ? 'SELL' : 'BUY'
  end

  def value
    shares * price
  end

  def ticker
    holding.ticker
  end

  def industry
    holding.industry
  end
end

Holding = Struct.new(:ticker, :industry, :name, keyword_init: true) do
  def to_s
    "#{ticker} - #{name}"
  end
end

class Portfolio < Grizzly::Collection
  def total_shares
    sum(&:shares)
  end

  def average_cost
    value / BigDecimal(total_shares)
  end

  def value
    sum(&:value)
  end
end

# Seed data - holdings and transactions

@holdings = {}
@holdings["MAG"] = Holding.new(ticker: "MAG", industry: "Finance", name: "Maggio Group")
@holdings["ARM"] = Holding.new(ticker: "ARM", industry: "Finance", name: "Armstrong and Sons")
@holdings["CON"] = Holding.new(ticker: "CON", industry: "Finance", name: "Conn LLC")
@holdings["THP"] = Holding.new(ticker: "THP", industry: "Mining",  name: "Tremblay-Hilpert")
@holdings["FTB"] = Holding.new(ticker: "FTB", industry: "Mining",  name: "Fritsch-Bosco")
@holdings["MGK"] = Holding.new(ticker: "MGK", industry: "Mining",  name: "MacGyver-Kilback")
@holdings["SKI"] = Holding.new(ticker: "SKI", industry: "Technology",  name: "Skiles LLC")
@holdings["VFL"] = Holding.new(ticker: "VFL", industry: "Technology",  name: "Von-Flatley")

def setup(holdings = @holdings)
  transactions = []
  until transactions.count >= 100 && transactions.group_by(&:holding).all? { |holding, t| t.sum(&:shares) > 0 }
    next if (shares = Faker::Number.between(from: -2, to: 5)).zero?
    transactions << Transaction.new(
      date: Faker::Date.between(from: '2022-01-01', to: '2022-12-31'),
      price: Faker::Number.between(from: 200, to: 300),
      shares: shares,
      holding: holdings[holdings.keys.sample]
    )
  end
  transactions
end

portfolio = Portfolio.new(setup)

# Using grizzly-rb library to print financial data.

puts "=== TRANSACTIONS SORTED BY DATE ==="
puts
puts portfolio.sort_by!(&:date)
puts

# === TRANSACTIONS SORTED BY DATE ===

# 2022-01-04 | THP |  BUY |  3 x 231 =   693
# 2022-01-14 | SKI |  BUY |  2 x 207 =   414
# 2022-01-27 | FTB |  BUY |  1 x 269 =   269
# 2022-02-01 | MGK |  BUY |  3 x 252 =   756
# 2022-02-02 | FTB | SELL |  2 x 294 =  -588
# 2022-02-05 | FTB |  BUY |  2 x 251 =   502
# 2022-02-05 | VFL |  BUY |  5 x 278 =  1390
# 2022-02-14 | ARM |  BUY |  5 x 220 =  1100
# 2022-02-16 | THP |  BUY |  3 x 278 =   834
# 2022-02-17 | MAG |  BUY |  4 x 224 =   896
# 2022-02-27 | SKI |  BUY |  5 x 269 =  1345
# 2022-02-28 | MAG | SELL |  1 x 278 =  -278
# 2022-03-01 | CON |  BUY |  3 x 293 =   879
# 2022-03-06 | SKI |  BUY |  4 x 206 =   824
# 2022-03-21 | VFL |  BUY |  3 x 218 =   654
# 2022-03-30 | MGK |  BUY |  2 x 225 =   450
# 2022-03-31 | MAG |  BUY |  3 x 287 =   861
# 2022-04-06 | MGK |  BUY |  5 x 212 =  1060
# 2022-04-08 | VFL |  BUY |  1 x 272 =   272
# 2022-04-12 | CON | SELL |  1 x 280 =  -280
# 2022-04-14 | VFL |  BUY |  4 x 252 =  1008
# 2022-04-26 | VFL | SELL |  2 x 285 =  -570
# 2022-04-26 | MAG |  BUY |  3 x 214 =   642
# 2022-04-28 | VFL |  BUY |  1 x 289 =   289
# 2022-04-28 | CON |  BUY |  4 x 263 =  1052
# 2022-04-28 | SKI |  BUY |  2 x 231 =   462
# 2022-05-01 | VFL |  BUY |  2 x 256 =   512
# 2022-05-02 | CON |  BUY |  3 x 220 =   660
# 2022-05-05 | THP | SELL |  2 x 214 =  -428
# 2022-05-10 | SKI | SELL |  1 x 255 =  -255
# 2022-05-16 | MGK |  BUY |  1 x 276 =   276
# 2022-05-23 | MAG |  BUY |  3 x 236 =   708
# 2022-05-24 | FTB |  BUY |  3 x 204 =   612
# 2022-05-29 | THP |  BUY |  2 x 206 =   412
# 2022-05-29 | ARM |  BUY |  2 x 211 =   422
# 2022-06-04 | MAG |  BUY |  4 x 234 =   936
# 2022-06-07 | CON |  BUY |  3 x 218 =   654
# 2022-06-07 | VFL |  BUY |  4 x 287 =  1148
# 2022-06-07 | THP | SELL |  2 x 241 =  -482
# 2022-06-09 | SKI |  BUY |  5 x 290 =  1450
# 2022-06-11 | MAG |  BUY |  2 x 292 =   584
# 2022-06-15 | MAG |  BUY |  2 x 238 =   476
# 2022-06-19 | MGK |  BUY |  2 x 206 =   412
# 2022-06-20 | VFL |  BUY |  3 x 293 =   879
# 2022-06-25 | CON |  BUY |  5 x 201 =  1005
# 2022-07-01 | SKI |  BUY |  2 x 225 =   450
# 2022-07-06 | VFL |  BUY |  4 x 212 =   848
# 2022-07-07 | CON |  BUY |  4 x 219 =   876
# 2022-07-08 | FTB |  BUY |  2 x 261 =   522
# 2022-07-09 | CON |  BUY |  3 x 263 =   789
# 2022-07-11 | SKI |  BUY |  2 x 288 =   576
# 2022-07-13 | CON | SELL |  1 x 215 =  -215
# 2022-07-15 | MGK |  BUY |  4 x 241 =   964
# 2022-07-17 | CON |  BUY |  2 x 295 =   590
# 2022-07-18 | CON |  BUY |  4 x 254 =  1016
# 2022-07-22 | FTB | SELL |  2 x 295 =  -590
# 2022-08-01 | MAG |  BUY |  3 x 247 =   741
# 2022-08-02 | THP |  BUY |  2 x 208 =   416
# 2022-08-03 | MGK | SELL |  1 x 239 =  -239
# 2022-08-04 | MAG |  BUY |  1 x 293 =   293
# 2022-08-08 | FTB |  BUY |  4 x 259 =  1036
# 2022-08-09 | THP |  BUY |  5 x 249 =  1245
# 2022-08-24 | SKI |  BUY |  1 x 228 =   228
# 2022-08-26 | FTB |  BUY |  1 x 285 =   285
# 2022-08-28 | CON |  BUY |  2 x 297 =   594
# 2022-08-28 | SKI |  BUY |  5 x 283 =  1415
# 2022-08-29 | VFL |  BUY |  1 x 251 =   251
# 2022-09-01 | MGK |  BUY |  3 x 201 =   603
# 2022-09-01 | THP |  BUY |  5 x 229 =  1145
# 2022-09-02 | MGK |  BUY |  5 x 228 =  1140
# 2022-09-07 | THP |  BUY |  1 x 215 =   215
# 2022-09-13 | FTB |  BUY |  4 x 292 =  1168
# 2022-09-15 | VFL |  BUY |  4 x 218 =   872
# 2022-09-20 | THP | SELL |  1 x 279 =  -279
# 2022-09-24 | SKI |  BUY |  4 x 214 =   856
# 2022-09-28 | FTB |  BUY |  3 x 300 =   900
# 2022-10-07 | THP |  BUY |  5 x 236 =  1180
# 2022-10-15 | MGK |  BUY |  2 x 208 =   416
# 2022-10-15 | VFL | SELL |  2 x 217 =  -434
# 2022-10-18 | CON | SELL |  2 x 232 =  -464
# 2022-10-19 | MAG |  BUY |  1 x 241 =   241
# 2022-10-22 | SKI |  BUY |  2 x 225 =   450
# 2022-10-22 | THP |  BUY |  5 x 289 =  1445
# 2022-10-23 | ARM |  BUY |  2 x 235 =   470
# 2022-11-01 | THP |  BUY |  4 x 267 =  1068
# 2022-11-02 | MAG |  BUY |  2 x 206 =   412
# 2022-11-10 | VFL | SELL |  1 x 289 =  -289
# 2022-11-13 | THP | SELL |  1 x 209 =  -209
# 2022-11-15 | THP |  BUY |  2 x 253 =   506
# 2022-11-15 | CON |  BUY |  5 x 258 =  1290
# 2022-11-19 | MAG |  BUY |  5 x 246 =  1230
# 2022-11-22 | MGK | SELL |  1 x 292 =  -292
# 2022-11-30 | SKI |  BUY |  5 x 273 =  1365
# 2022-12-02 | CON | SELL |  1 x 245 =  -245
# 2022-12-03 | VFL |  BUY |  5 x 295 =  1475
# 2022-12-08 | MAG |  BUY |  3 x 217 =   651
# 2022-12-13 | ARM |  BUY |  5 x 285 =  1425
# 2022-12-14 | SKI | SELL |  1 x 237 =  -237
# 2022-12-26 | ARM |  BUY |  3 x 214 =   642
# 2022-12-30 | MAG |  BUY |  4 x 229 =   916


puts "=== TRANSACTIONS FOR MAG ==="
puts
mag = portfolio.select { |t| t.holding == @holdings["MAG"] }
puts "%s %10.2f, shares: %4s, cost average: %8.2f" % [@holdings["MAG"], portfolio.value, portfolio.total_shares, portfolio.average_cost]
puts mag
puts

# === TRANSACTIONS FOR MAG ===

# MAG - Maggio Group   56640.00, shares:  230, cost average:   246.26
# 2022-02-17 | MAG |  BUY |  4 x 224 =   896
# 2022-02-28 | MAG | SELL |  1 x 278 =  -278
# 2022-03-31 | MAG |  BUY |  3 x 287 =   861
# 2022-04-26 | MAG |  BUY |  3 x 214 =   642
# 2022-05-23 | MAG |  BUY |  3 x 236 =   708
# 2022-06-04 | MAG |  BUY |  4 x 234 =   936
# 2022-06-11 | MAG |  BUY |  2 x 292 =   584
# 2022-06-15 | MAG |  BUY |  2 x 238 =   476
# 2022-08-01 | MAG |  BUY |  3 x 247 =   741
# 2022-08-04 | MAG |  BUY |  1 x 293 =   293
# 2022-10-19 | MAG |  BUY |  1 x 241 =   241
# 2022-11-02 | MAG |  BUY |  2 x 206 =   412
# 2022-11-19 | MAG |  BUY |  5 x 246 =  1230
# 2022-12-08 | MAG |  BUY |  3 x 217 =   651
# 2022-12-30 | MAG |  BUY |  4 x 229 =   916


puts "=== PORTFOLIO GROUPED BY TICKER === "
puts
portfolio
  .sort_by(&:ticker)
  .group_by(&:holding)
  .each do |holding, portfolio|
    puts "%-25s %10.2f, shares: %4s, cost average: %8.2f" % [holding.name, portfolio.value, portfolio.total_shares, portfolio.average_cost]
  end
puts '-' * 74
puts "%-25s %10.2f, shares: %4s, cost average: %8.2f" % ["Portfolio total value:", portfolio.value, portfolio.total_shares, portfolio.average_cost]
puts

# === PORTFOLIO GROUPED BY TICKER ===

# Portfolio total value:      56640.00, shares:  230, cost average:   246.26
# Armstrong and Sons           4059.00, shares:   17, cost average:   238.76
# Conn LLC                     8201.00, shares:   33, cost average:   248.52
# Fritsch-Bosco                4116.00, shares:   16, cost average:   257.25
# Maggio Group                 9309.00, shares:   39, cost average:   238.69
# MacGyver-Kilback             5546.00, shares:   25, cost average:   221.84
# Skiles LLC                   9343.00, shares:   37, cost average:   252.51
# Tremblay-Hilpert             7761.00, shares:   31, cost average:   250.35
# Von-Flatley                  8305.00, shares:   32, cost average:   259.53


puts "=== PORTFOLIO GROUPED BY INDUSTRY ==="
puts

portfolio
  .sort_by { |transaction| [transaction.industry, transaction.ticker] }
  .group_by(&:industry)
  .each do |(industry, portfolio)|
    puts "%-25s %10.2f, shares: %4s, cost average: %8.2f" % [industry, portfolio.value, portfolio.total_shares, portfolio.average_cost]
    portfolio
      .group_by(&:holding)
      .each do |(holding, portfolio)|
        puts "  - %-21s %10.2f, shares: %4s, cost average: %8.2f" % [holding.name, portfolio.value, portfolio.total_shares, portfolio.average_cost]
      end
    puts
  end

# === PORTFOLIO GROUPED BY INDUSTRY ===

# Finance                     21569.00, shares:   89, cost average:   242.35
#   - Armstrong and Sons       4059.00, shares:   17, cost average:   238.76
#   - Conn LLC                 8201.00, shares:   33, cost average:   248.52
#   - Maggio Group             9309.00, shares:   39, cost average:   238.69

# Mining                      17423.00, shares:   72, cost average:   241.99
#   - Fritsch-Bosco            4116.00, shares:   16, cost average:   257.25
#   - MacGyver-Kilback         5546.00, shares:   25, cost average:   221.84
#   - Tremblay-Hilpert         7761.00, shares:   31, cost average:   250.35

# Technology                  17648.00, shares:   69, cost average:   255.77
#   - Skiles LLC               9343.00, shares:   37, cost average:   252.51
#   - Von-Flatley              8305.00, shares:   32, cost average:   259.53
