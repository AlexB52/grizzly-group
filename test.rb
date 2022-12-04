require "bundler/setup"
require "grizzly"

Mark = Struct.new(:score)
class MarkCollection < Grizzly::Collection
  def average_score
    sum(&:score) / size.to_f
  end
end

marks = MarkCollection.new (0..100).to_a.map { |i| Mark.new(i) }

puts marks.select { |mark| mark.score.even? }.
      average_score

# => 50.0

puts marks.select { |mark| mark.score.even? }.
      reject { |mark| mark.score <= 80 }.
      average_score

# => 91.0